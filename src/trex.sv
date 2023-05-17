package trex_pkg;
    typedef enum logic[2:0] {
        WAITING0, WAITING1,
        RUNNING0, RUNNING1,
        JUMPING0,
        DUCKING0, DUCKING1,
        CRASHED0
    } frame_t;

    typedef enum logic[2:0] {
        WAITING,
        RUNNING,
        JUMPING,
        DUCKING,
        CRASHED
    } state_t;

    parameter signed DROP_VELOCITY = -5;
    parameter HEIGHT = 47;
    parameter HEIGHT_DUCK  = 25;
    parameter START_X_POS = 50;
    parameter WIDTH = 44;
    parameter WIDTH_DUCK = 59;

    parameter GRAVITY = 6;
    parameter MAX_JUMP_HEIGHT = 30;
    parameter signed INITIAL_JUMP_VELOCITY = -9;

    // Position when on the ground.
    parameter GROUND_Y_POS = 150 - HEIGHT - 10;

    parameter MIN_JUMP_HEIGHT = GROUND_Y_POS - 30;

endpackage

// T-rex game character.
module trex (
    input clk,
    input rst,

    input update,
    input[5:0] timer,

    input[4:0] speed,

    input jump,
    input crash,

    output logic[9:0] x_pos,
    output logic[9:0] y_pos,
    output logic[9:0] width,
    output logic[9:0] height,

    output trex_pkg::frame_t frame
);
    import trex_pkg::*;
    import util_func::*;

    state_t state, next_state;

    logic signed[9:0] jump_velocity;
    logic[4:0] gravity_counter;

    logic reached_min_height;

    assign width = state == DUCKING ? WIDTH_DUCK : WIDTH;
    assign height = state == DUCKING ? HEIGHT_DUCK : HEIGHT;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= WAITING;
            x_pos <= START_X_POS;
            y_pos <= GROUND_Y_POS;
            frame <= WAITING0;
            jump_velocity <= 0;
            gravity_counter <= 0;
            reached_min_height <= 0;
        end else begin
            state <= next_state;

            update_frame();

            if (update) begin
                case (next_state)
                    RUNNING: begin
                        // Clear jumping state, e.g. jumping velocity.
                        reset();
                    end
                    JUMPING: begin
                        if (state == WAITING || state == RUNNING) begin
                            start_jump(speed);
                        end else if (state == JUMPING) begin
                            update_jump();
                        end
                    end
                endcase
            end
        end
    end

    always_comb begin
        case (state)
            WAITING: begin
                next_state = jump ? RUNNING : WAITING;
            end
            RUNNING: begin
                next_state = jump ? JUMPING : RUNNING;
            end
            JUMPING: begin
                next_state = $signed(y_pos) + jump_velocity
                    > $signed(GROUND_Y_POS)
                    ? RUNNING
                    : JUMPING;
            end
            DUCKING: begin
                // Not implemented yet
                next_state = RUNNING;
            end
            CRASHED: begin
                next_state = CRASHED;
            end
            default: begin
                next_state = WAITING;
            end
        endcase

        // Preserve state if not received update signal.
        if (!update) begin
            next_state = state;
        end
        
        if (crash &&
            (state == RUNNING || state == JUMPING || state == DUCKING)
        ) begin
            next_state = CRASHED;
        end
    end

    task reset;
        x_pos <= START_X_POS;
        y_pos <= GROUND_Y_POS;
        jump_velocity <= 0;
        gravity_counter <= 0;
    endtask

    // Update frame to render based on the next state.
    task update_frame;
        case (next_state)
            WAITING: begin
                frame <= timer >= 30 ? WAITING0 : WAITING1;
            end
            RUNNING: begin
                frame <= inside_range(timer, 0, 5) ||
                    inside_range(timer, 10, 15) ||
                    inside_range(timer, 20, 25) ||
                    inside_range(timer, 30, 35) ||
                    inside_range(timer, 40, 45) ||
                    inside_range(timer, 50, 55)
                ? RUNNING0 : RUNNING1;
            end
            JUMPING: begin
                frame <= JUMPING0;
            end
            DUCKING: begin
                frame <= inside_range(timer, 0, 10) ||
                    inside_range(timer, 20, 30) ||
                    inside_range(timer, 40, 50)
                ? DUCKING0 : RUNNING1;
            end
            CRASHED: begin
                frame <= CRASHED0;
            end
        endcase
    endtask

    // Initialize a jump.
    task start_jump(logic[3:0] speed);
        // Tweak the jump velocity based on the speed.
        jump_velocity <= INITIAL_JUMP_VELOCITY - (speed >> 3);
        gravity_counter <= 0;
        reached_min_height <= 0;
    endtask

    // Jump is complete, falling down.
    task end_jump;
        if (reached_min_height && jump_velocity < DROP_VELOCITY) begin
            jump_velocity <= DROP_VELOCITY;
        end
    endtask

    // Update frame for a jump.
    task update_jump;
        y_pos <= y_pos + jump_velocity;

        if (gravity_counter + GRAVITY >= 10) begin
            gravity_counter <= gravity_counter + GRAVITY - 10;
            jump_velocity <= jump_velocity + 1;
        end else begin
            gravity_counter <= gravity_counter + GRAVITY;
        end

        // Minimum height has been reached.
        if (y_pos < MIN_JUMP_HEIGHT) begin
            reached_min_height = 1;
        end

        // Reached max height.
        if (y_pos < MAX_JUMP_HEIGHT) begin
            end_jump();
        end
    endtask
    
endmodule
