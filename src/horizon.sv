package horizon_pkg;
    typedef enum { 
        WAITING,
        RUNNING,
        UPDATE_OBSTACLES_0,
        UPDATE_OBSTACLES_1,
        UPDATE_OBSTACLES_2,
        CRASHED
    } state_t;

    parameter BG_CLOUD_SPEED_INV = 5;
    parameter CLOUD_FREQUENCY_INV = 2;
    parameter HORIZON_HEIGHT = 16;
    parameter MAX_CLOUDS = 6;

    parameter MAX_OBSTACLES = 7;
    parameter MAX_OBSTACLE_DUPLICATION = 2;
    parameter OBSTACLE_TYPES = obstacle_pkg::TYPE_COUNT - 1;

    parameter GAME_WIDTH = 600;
    parameter SPEED_SCALE = 1024;
endpackage

import horizon_pkg::MAX_OBSTACLES;

// Horizon background class.
module horizon (
    input clk,
    input rst,

    input update,
    input[5:0] timer,

    input start,
    input crash,

    input[14:0] speed,

    input bit[10:0] rng_data,

    // Enable obstacle generation.
    input has_obstacles,

    output logic obstacle_start[MAX_OBSTACLES],

    output logic signed[10:0] obstacle_x_pos[MAX_OBSTACLES],
    output logic[9:0] obstacle_y_pos[MAX_OBSTACLES],
    output logic[9:0] obstacle_width[MAX_OBSTACLES],
    output logic[9:0] obstacle_height[MAX_OBSTACLES],
    output logic[1:0] obstacle_size[MAX_OBSTACLES],

    output obstacle_pkg::frame_t obstacle_frame[MAX_OBSTACLES]
);
    import horizon_pkg::*;
    import obstacle_pkg::MAX_OBSTACLE_LENGTH;
    import obstacle_pkg::MIN_SPEED;

    typedef obstacle_pkg::type_t obstacle_t;
    typedef obstacle_pkg::frame_t obstacle_frame_t;
    
    state_t state, next_state;

    // Obstacle queue.
    logic[2:0] obstacle_front;
    logic[2:0] obstacle_back;

    logic obstacle_update;

    obstacle_t obstacle_type[MAX_OBSTACLES];
    logic obstacle_remove[MAX_OBSTACLES];
    logic[10:0] obstacle_gap[MAX_OBSTACLES];
    logic obstacle_visible[MAX_OBSTACLES];

    genvar i;
    generate
        for (i = 0; i < MAX_OBSTACLES; i++) begin: obstacles
            obstacle obstacle_inst (
                .clk,
                .rst, 

                .update(obstacle_update),
                .timer,
                .speed,

                .typ(obstacle_type[i]),
                .start(obstacle_start[i]),
                .crash,

                .rng_data,
                
                .remove(obstacle_remove[i]),
                .gap(obstacle_gap[i]),
                .visible(obstacle_visible[i]),

                .x_pos(obstacle_x_pos[i]),
                .y_pos(obstacle_y_pos[i]),
                .width(obstacle_width[i]),
                .height(obstacle_height[i]),
                .size(obstacle_size[i]),

                .frame(obstacle_frame[i])
            );
        end
    endgenerate

    always_comb begin
        case (state)
            WAITING: begin
                next_state = start ? RUNNING : WAITING;
            end
            RUNNING: begin
                if (crash) begin
                    next_state = CRASHED;
                end else begin
                    next_state = update ? UPDATE_OBSTACLES_0 : RUNNING;
                end
            end
            UPDATE_OBSTACLES_0: begin
                next_state = UPDATE_OBSTACLES_1;
            end
            UPDATE_OBSTACLES_1: begin
                next_state = UPDATE_OBSTACLES_2;
            end
            UPDATE_OBSTACLES_2: begin
                next_state = RUNNING;
            end
            CRASHED: begin
                next_state = CRASHED;
            end
            default: begin
                next_state = WAITING;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= WAITING;
            obstacle_update <= 0;
            obstacle_front <= 0;
            obstacle_back <= 0;
            for (int i = 0; i < MAX_OBSTACLES; i++) begin
                obstacle_start[i] <= 0;
                obstacle_type[i] <= obstacle_pkg::NONE;
            end
        end else begin
            state <= next_state;

            case (next_state)
                RUNNING: begin
                    obstacle_update <= 0;
                end
                UPDATE_OBSTACLES_0: begin
                    update_obstacles_0();
                end
                UPDATE_OBSTACLES_1: begin
                    update_obstacles_1();
                end
                UPDATE_OBSTACLES_2: begin
                    update_obstacles_2();
                end
            endcase
        end
    end

    // Mod increment.
    function logic[2:0] incr(logic[2:0] x);
        return x + 1 >= MAX_OBSTACLES ? 0 : x + 1;
    endfunction

    // Mod decrement.
    function logic[2:0] decr(logic[2:0] x);
        return !x ? MAX_OBSTACLES - 1 : x - 1;
    endfunction

    // Last element in the queue.
    function logic[2:0] last;
        return decr(obstacle_back);
    endfunction

    // Update existing obstacles and create new ones.
    task update_obstacles_0;
        obstacle_update <= 1;
        if (has_obstacles && obstacle_front == obstacle_back) begin
            add_new_obstacle();
        end else begin
            if (obstacle_visible[last()] &&
                obstacle_x_pos[last()] +
                $signed(obstacle_width[last()]) +
                $signed(obstacle_gap[last()]) < $signed(GAME_WIDTH)
            ) begin
                add_new_obstacle();
            end
        end
    endtask

    // Wait for obstacles to be updated.
    task update_obstacles_1;
        obstacle_update <= 0;
    endtask

    // Remove invisible obstacles.
    task update_obstacles_2;
        if (obstacle_remove[obstacle_front]) begin
            obstacle_front <= incr(obstacle_front);
            obstacle_start[obstacle_front] <= 0;
        end
    endtask

    // Returns whether the previous two obstacles are the same as the next one.
    function logic duplicate_obstacle_check(obstacle_t typ);
        automatic int duplicate_count = 0;
        automatic int now = decr(last());
        for (int i = 0;
             i < MAX_OBSTACLE_DUPLICATION;
             i++, now = decr(now)
        ) begin
            if (obstacle_type[now] == typ) begin
                duplicate_count++;
            end
        end
        return duplicate_count >= MAX_OBSTACLE_DUPLICATION;
    endfunction

    // Randomly pick a new obstacle type.
    function obstacle_t new_obstacle_type;
        automatic obstacle_t typ;
        // Try another type if duplicate or not allowed at current speed.
        for (int i = 0; i < OBSTACLE_TYPES; i++) begin
            typ = obstacle_t'(
                (rng_data + i) % OBSTACLE_TYPES + 1
            );
            if (!duplicate_obstacle_check(typ)
                && speed / SPEED_SCALE >= MIN_SPEED[typ]
            ) begin
                return typ;
            end
        end
        return obstacle_pkg::NONE;
    endfunction

    // Add a new obstacle to the queue.
    task add_new_obstacle;
        obstacle_back <= incr(obstacle_back);
        obstacle_type[obstacle_back] <= new_obstacle_type();
        obstacle_start[obstacle_back] <= 1;
    endtask

endmodule
