package obstacle_pkg;
    typedef enum logic[2:0] {
        NONE,
        CACTUS_SMALL,
        CACTUS_LARGE,
        PTERODACTYL
    } type_t;

    typedef enum logic[2:0] {
        NONE_0,
        CACTUS_SMALL_0,
        CACTUS_LARGE_0,
        PTERODACTYL_0,
        PTERODACTYL_1
    } frame_t;

    typedef enum logic[1:0] {
        WAITING,
        RUNNING,
        CRASHED
    } state_t;

    parameter TYPE_COUNT = 4;
    parameter Y_POS_COUNT = 3;

    parameter int WIDTH[TYPE_COUNT] = '{
        NONE: 0,
        CACTUS_SMALL: 17,
        CACTUS_LARGE: 25,
        PTERODACTYL: 46
    };

    parameter int HEIGHT[TYPE_COUNT] = '{
        NONE: 0,
        CACTUS_SMALL: 35,
        CACTUS_LARGE: 50,
        PTERODACTYL: 40
    };
    parameter int Y_POS[TYPE_COUNT][Y_POS_COUNT] = '{
        NONE: '{0, 0, 0},
        CACTUS_SMALL: '{105, 105, 105},
        CACTUS_LARGE: '{90, 90, 90},
        PTERODACTYL: '{100, 75, 50}
    };
    parameter int MULTIPLE_SPEED[TYPE_COUNT] = '{
        NONE: 0,
        CACTUS_SMALL: 4096,
        CACTUS_LARGE: 7168,
        PTERODACTYL: 1022976
    };
    parameter int MIN_GAP[TYPE_COUNT] = '{
        NONE: 0,
        CACTUS_SMALL: 120,
        CACTUS_LARGE: 120,
        PTERODACTYL: 150
    };
    parameter int MIN_SPEED[TYPE_COUNT] = '{
        NONE: 0,
        CACTUS_SMALL: 0,
        CACTUS_LARGE: 0,
        PTERODACTYL: 8704
    };
    parameter int signed SPEED_OFFSET[TYPE_COUNT] = '{
        NONE: 0,
        CACTUS_SMALL: 0,
        CACTUS_LARGE: 0,
        PTERODACTYL: 819
    };
    parameter int NUM_FRAMES[TYPE_COUNT] = '{
        NONE: 0,
        CACTUS_SMALL: 0,
        CACTUS_LARGE: 0,
        PTERODACTYL: 2
    };

    parameter MAX_OBSTACLE_LENGTH = 3;

    parameter GAME_WIDTH = 640;
    parameter SPEED_SCALE = 1024;

    import collision_pkg::collision_box_t;

    parameter COLLISION_BOX_COUNT = 5;

    parameter collision_box_t
        COLLISION_BOX[TYPE_COUNT][COLLISION_BOX_COUNT] = '{
        NONE: '{
            '{0, 0, 0, 0},
            '{0, 0, 0, 0},
            '{0, 0, 0, 0},
            '{0, 0, 0, 0},
            '{0, 0, 0, 0}
        },
        CACTUS_SMALL: '{
            '{0, 7, 5, 27},
            '{4, 0, 6, 34},
            '{10, 4, 7, 14},
            '{0, 0, 0, 0},
            '{0, 0, 0, 0}
        },
        CACTUS_LARGE: '{
            '{0, 12, 7, 38},
            '{8, 0, 7, 49},
            '{13, 10, 10, 38},
            '{0, 0, 0, 0},
            '{0, 0, 0, 0}
        },
        PTERODACTYL: '{
            '{15, 15, 16, 5},
            '{18, 21, 24, 6},
            '{2, 14, 4, 3},
            '{6, 10, 4, 7},
            '{10, 8, 6, 9}
        }
    };
    
endpackage

module obstacle (
    input clk,
    input rst,

    input update,
    input[5:0] timer,
    input[14:0] speed,

    input obstacle_pkg::type_t typ,
    input start,
    input crash,

    input bit[10:0] rng_data,

    output logic remove,
    output logic[10:0] gap,
    output logic visible,

    output logic signed[10:0] x_pos,
    output logic[9:0] y_pos,
    output logic[9:0] width,
    output logic[9:0] height,

    output logic[1:0] size,

    output obstacle_pkg::frame_t frame,

    output collision_pkg::collision_box_t
        collision_box[obstacle_pkg::COLLISION_BOX_COUNT]
);  
    import obstacle_pkg::*;

    import collision_pkg::*;
    import util_func::*;

    state_t state, next_state;

    logic signed[11:0] speed_offset;

    logic signed[20:0] x_pos_game;

    assign x_pos = x_pos_game / SPEED_SCALE;

    assign visible = x_pos + $signed(width) > 0;

    always_ff @(posedge clk) begin
        if (rst) begin
            x_pos_game <= 0;
            y_pos <= 0;
            width <= 0;
            height <= 0;

            remove <= 0;
            size <= 0;
            speed_offset <= 0;
            gap <= 0;
            frame <= NONE_0;
        end else if (update) begin
            state <= next_state;

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
                next_state = crash ? CRASHED : start ? RUNNING : WAITING;
            end
            RUNNING: begin
                next_state = crash ? CRASHED : remove ? WAITING : RUNNING;
            end
            CRASHED: begin
                next_state = CRASHED;
            end
            default: begin
                next_state = WAITING;
            end
        endcase
    end

    always_comb begin
        // Make a copy of the collision boxes, since these will change based on
        // obstacle type and size.
        automatic collision_box_t b[COLLISION_BOX_COUNT] = COLLISION_BOX[typ];

        // Make collision box adjustments,
        // Central box is adjusted to the size as one box.
        //      ____        ______        ________
        //    _|   |-|    _|     |-|    _|       |-|
        //   | |<->| |   | |<--->| |   | |<----->| |
        //   | | 1 | |   | |  2  | |   | |   3   | |
        //   |_|___|_|   |_|_____|_|   |_|_______|_|
        if (size > 1) begin
            b[1].w = width - b[0].w - b[2].w;
            b[2].x = width - b[2].w;
        end

        for (int i = 0; i < COLLISION_BOX_COUNT; i++) begin
            collision_box[i] = create_adjusted_collision_box(
                b[i],
                x_pos, y_pos
            );
        end
    end

    task initialize;
        remove <= 0;

        // Only allow sizing if we're at the right speed.
        size <= get_size();

        height <= HEIGHT[typ];
        width <= get_width();
        x_pos_game <= GAME_WIDTH * SPEED_SCALE;
        y_pos <= Y_POS[typ][timer < 20 ? 0 : timer < 40 ? 1 : 2];

        // For obstacles that go at a different speed from the horizon.
        speed_offset <= timer[0] ? SPEED_OFFSET[typ] : -SPEED_OFFSET[typ];

        gap <= get_gap();

        case (typ)
            CACTUS_SMALL: begin
                frame <= CACTUS_SMALL_0;
            end
            CACTUS_LARGE: begin
                frame <= CACTUS_LARGE_0;
            end
            PTERODACTYL: begin
                frame <= PTERODACTYL_0;
            end
            default: begin
                frame <= NONE_0;
            end
        endcase

    endtask

    task run;
        x_pos_game <= x_pos_game - $signed(speed) + speed_offset;

        if (NUM_FRAMES[typ]) begin
            if (typ == PTERODACTYL) begin
                frame <= inside_range(timer, 0, 10) ||
                    inside_range(timer, 20, 30) ||
                    inside_range(timer, 40, 50)
                ? PTERODACTYL_0 : PTERODACTYL_1;
            end
        end

        if (!visible) begin
            remove <= 1;
        end
    endtask

    function logic[1:0] get_size;
        return (speed > MULTIPLE_SPEED[typ]
            ? timer % MAX_OBSTACLE_LENGTH
            : 0) + 1;
    endfunction

    function logic[9:0] get_width;
        return WIDTH[typ] * get_size();
    endfunction

    // logic[10:0] min_gap, gap_calc;
    // assign min_gap = get_width() * speed / SPEED_SCALE + MIN_GAP[typ];

    // div divider (
    //     .denom(min_gap / 2),
    //     .numer(rng_data),
    //     .remain(gap_calc)
    // );

    
    // Calculate a random gap size.
    // Minimum gap gets wider as speed increases.
    function logic[10:0] get_gap;
        automatic logic[10:0] min_gap = get_width() * speed / SPEED_SCALE
            + MIN_GAP[typ];
        // TODO: Use IP core if this is too slow.
        return min_gap;
        // return rng_data % (min_gap >> 1) + min_gap;
    endfunction

endmodule
