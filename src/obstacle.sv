import util_func::*;

package obstacle_pkg;
    typedef enum logic[2:0] {
        CACTUS_SMALL,
        CACTUS_LARGE,
        PTERODACTYL
    } type_t;

    typedef enum logic[2:0] {
        CACTUS_SMALL0,
        CACTUS_LARGE0,
        PTERODACTYL0,
        PTERODACTYL1
    } frame_t;

    typedef enum logic[1:0] {
        WAITING,
        RUNNING,
        CRASHED
    } state_t;

    parameter TYPE_COUNT = 3;
    parameter Y_POS_COUNT = 3;

    parameter int WIDTH[TYPE_COUNT] = '{
        CACTUS_SMALL: 17,
        CACTUS_LARGE: 25,
        PTERODACTYL: 46
    };

    parameter int HEIGHT[TYPE_COUNT] = '{
        CACTUS_SMALL: 35,
        CACTUS_LARGE: 50,
        PTERODACTYL: 40
    };
    parameter int Y_POS[TYPE_COUNT][Y_POS_COUNT] = '{
        CACTUS_SMALL: '{105, 105, 105},
        CACTUS_LARGE: '{90, 90, 90},
        PTERODACTYL: '{100, 75, 50}
    };
    parameter int MULTIPLE_SPEED[TYPE_COUNT] = '{
        CACTUS_SMALL: 4,
        CACTUS_LARGE: 7,
        PTERODACTYL: 999
    };
    parameter int MIN_GAP[TYPE_COUNT] = '{
        CACTUS_SMALL: 120,
        CACTUS_LARGE: 120,
        PTERODACTYL: 150
    };
    parameter int MIN_SPEED[TYPE_COUNT] = '{
        CACTUS_SMALL: 0,
        CACTUS_LARGE: 0,
        PTERODACTYL: 8
    };
    parameter int signed SPEED_OFFSET[TYPE_COUNT] = '{
        CACTUS_SMALL: 0,
        CACTUS_LARGE: 0,
        PTERODACTYL: 1
    };
    parameter int NUM_FRAMES[TYPE_COUNT] = '{
        CACTUS_SMALL: 0,
        CACTUS_LARGE: 0,
        PTERODACTYL: 2
    };

    parameter DEFAULT_DIMENSIONS_WIDTH = 150;

    parameter MAX_OBSTACLE_LENGTH = 3;

    parameter RANDOM_SEED = 19260817;
    
endpackage

import obstacle_pkg::*;

module obstacle (
    input clk,
    input rst,

    input[5:0] timer,

    input type_t typ,
    input start,
    input crash,

    input[1:0] size,

    input[3:0] speed,

    output logic signed[9:0] x_pos,
    output logic[9:0] y_pos,
    output logic[9:0] width,
    output logic[9:0] height,

    output logic[11:0] sprite_x_pos,
    output logic[11:0] sprite_y_pos  
);  
    state_t state, next_state;

    logic remove;

    logic[1:0] current_size;

    logic signed[1:0] speed_offset;

    logic[10:0] gap;

    frame_t frame;

    logic rng_load;
    logic[10:0] rng_data;
    lfsr_prng #(
        .DATA_WIDTH(11),
        .INVERT(0)
    ) prng_gap (
        .clk(clk),
        .load(rng_load),
        .seed(RANDOM_SEED),

        .enable(1),
        .data_out(rng_data)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            x_pos <= 0;
            y_pos <= 0;
            width <= 0;
            height <= 0;

            sprite_x_pos <= 0;
            sprite_y_pos <= 0;

            remove <= 0;
            current_size <= 0;
            speed_offset <= 0;
            gap <= 0;
            frame <= CACTUS_SMALL0;

            rng_load <= 1;
        end else begin
            state <= next_state;

            rng_load <= 0;

            if (next_state == RUNNING) begin
                if (state == WAITING) begin
                    initialize();
                end else begin
                    run();
                end
            end
        end
    end

    always_comb begin
        case (state)
            WAITING: begin
                next_state = start ? RUNNING : WAITING;
            end
            RUNNING: begin
                next_state = remove ? WAITING : RUNNING;
            end
            CRASHED: begin
                next_state = CRASHED;
            end
            default: begin
                next_state = WAITING;
            end
        endcase
    end

    task initialize;
        remove <= 0;

        // Only allow sizing if we're at the right speed.
        current_size <= get_size();

        height <= HEIGHT[typ];
        width <= get_width();
        x_pos<= DEFAULT_DIMENSIONS_WIDTH;
        y_pos <= Y_POS[typ][timer < 20 ? 0 : timer < 40 ? 1 : 2];

        // For obstacles that go at a different speed from the horizon.
        speed_offset <= timer[0] ? SPEED_OFFSET[typ] : -SPEED_OFFSET[typ];

        gap <= get_gap();

        case (typ)
            CACTUS_SMALL: begin
                frame <= CACTUS_SMALL0;
            end
            CACTUS_LARGE: begin
                frame <= CACTUS_LARGE0;
            end
            PTERODACTYL: begin
                frame <= PTERODACTYL0;
            end
            default: begin
                frame <= CACTUS_SMALL0;
            end
        endcase

    endtask

    task run;
        x_pos <= x_pos - $signed(speed) + speed_offset;

        if (NUM_FRAMES[typ]) begin
            if (typ == PTERODACTYL) begin
                frame <= inside_range(timer, 0, 10) ||
                    inside_range(timer, 20, 30) ||
                    inside_range(timer, 40, 50)
                ? PTERODACTYL0 : PTERODACTYL1;
            end
        end

        if (!is_visible()) begin
            remove <= 1;
        end
    endtask

    function logic is_visible;
        return x_pos + $signed(width) > 0;
    endfunction

    function logic[1:0] get_size;
        return speed > MULTIPLE_SPEED[typ] ? size : 1;
    endfunction

    function logic[9:0] get_width;
        return WIDTH[typ] * get_size();
    endfunction

    // Calculate a random gap size.
    // Minimum gap gets wider as speed increases.
    function logic[10:0] get_gap;
        static logic[10:0] min_gap = get_width() * speed + MIN_GAP[typ];
        // TODO: Use IP core if this is too slow.
        return rng_data % (min_gap >> 1) + min_gap;
    endfunction

endmodule
