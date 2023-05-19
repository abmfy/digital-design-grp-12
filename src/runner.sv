package runner_pkg;
    typedef enum {
        WAITING,
        RUNNING,
        CRASHED
    } state_t;

    typedef enum {
        CACTUS_LARGE,
        CACTUS_SMALL,
        CLOUD,
        HORIZON,
        MOON,
        PTERODACTYL,
        TEXT_SPRITE,
        TREX,
        STAR
    } element_t;

    typedef struct packed {
        logic signed[10:0] x;
        logic[9:0] y;
        logic[9:0] w;
        logic[9:0] h;
    } collision_box_t;

    typedef struct packed {
        logic[11:0] x;
        logic[11:0] y;
        logic[11:0] w;
        logic[11:0] h;
    } sprite_t;

    typedef struct packed {
        logic signed[11:0] x;
        logic signed[11:0] y;
    } pos_t;

    parameter CLK_FREQ = 33_333_333;
    parameter FPS = 60;
    parameter CLK_PER_FRAME = CLK_FREQ / FPS;

    parameter CLEAR_TIME = 3 * FPS;

    // Scale from pixel speed to game speed
    parameter SPEED_SCALE = 1024;

    parameter SPEED = 6 * SPEED_SCALE;
    parameter MAX_SPEED = 13 * SPEED_SCALE;

    parameter ACCELERATION = 1;

    parameter RENDER_SLOTS = 32;
    parameter int RENDER_INDEX[ELEMENT_TYPES] = '{
        CACTUS_LARGE: 0,
        CACTUS_SMALL: 0,
        CLOUD: 7,
        HORIZON: 13,
        MOON: 15,
        PTERODACTYL: 0,
        TEXT_SPRITE: 16,
        TREX: 29,
        STAR: 30
    };

    parameter ELEMENT_TYPES = 9;

    parameter GAME_WIDTH = 600;
    parameter GAME_HEIGHT = 150;

    // (x, y)
    parameter int SPRITE[ELEMENT_TYPES][2] = '{
        CACTUS_LARGE: '{652, 2},
        CACTUS_SMALL: '{446, 2},
        CLOUD: '{166, 2},
        HORIZON: '{2, 104},
        MOON: '{954, 2},
        PTERODACTYL: '{260, 2},
        TEXT_SPRITE: '{1294, 2},
        TREX: '{1678, 2},
        STAR: '{1276, 2}
    };

    import trex_pkg::WAITING0;
    import trex_pkg::WAITING1;
    import trex_pkg::RUNNING0;
    import trex_pkg::RUNNING1;
    import trex_pkg::JUMPING0;
    import trex_pkg::DUCKING0;
    import trex_pkg::DUCKING1;
    import trex_pkg::CRASHED0;

    parameter int SPRITE_TREX_OFFSET[8] = '{
        WAITING0: 0,
        WAITING1: 88,
        RUNNING0: 176,
        RUNNING1: 264,
        JUMPING0: 0,
        DUCKING0: 528,
        DUCKING1: 646,
        CRASHED0: 440
    };

    import obstacle_pkg::WIDTH;
    import obstacle_pkg::NONE_0;
    import obstacle_pkg::CACTUS_SMALL_0;
    import obstacle_pkg::CACTUS_LARGE_0;
    import obstacle_pkg::PTERODACTYL_0;
    import obstacle_pkg::PTERODACTYL_1;

    // Offset of specific obstacles for each size.
    // Multiply by 2 for high DPI.
    parameter int SPRITE_OBSTACLE_OFFSET[5][3] = '{
        NONE_0: '{0, 0, 0},
        CACTUS_SMALL_0: '{
            0,
            17 * 1 * 2,
            17 * 3 * 2
        },
        CACTUS_LARGE_0: '{
            0,
            25 * 1 * 2,
            25 * 3 * 2
        },
        PTERODACTYL_0: '{0, 0, 0},
        PTERODACTYL_1: '{
            46 * 2,
            0,
            0
        }
    };

    parameter collision_box_t COLLISION_BOX_TREX[6] = '{
        '{22, 0, 17, 16},
        '{1, 18, 30, 9},
        '{10, 35, 14, 8},
        '{1, 24, 29, 5},
        '{5, 30, 21, 4},
        '{9, 34, 15, 4}
    };

    parameter collision_box_t COLLISION_BOX_TREX_DUCK = '{1, 18, 55, 25};

    parameter collision_box_t COLLISION_BOX_CACTUS_SMALL[3] = '{
        '{0, 7, 5, 27},
        '{4, 0, 6, 34},
        '{10, 4, 7, 14}
    };

    parameter collision_box_t COLLISION_BOX_CACTUS_LARGE[3] = '{
        '{0, 12, 7, 38},
        '{8, 0, 7, 49},
        '{13, 10, 10, 38}
    };
    
    parameter collision_box_t COLLISION_BOX_PTERODACTYL[5] = '{
        '{15, 15, 16, 5},
        '{18, 21, 24, 6},
        '{2, 14, 4, 3},
        '{6, 10, 4, 7},
        '{10, 8, 6, 9}
    };

endpackage

import runner_pkg::RENDER_SLOTS;
import runner_pkg::sprite_t;
import runner_pkg::pos_t;

module runner (
    input clk,
    input rst,    

    input jumping,
    input ducking,

    input[10:0] random_seed,

    // DEBUG
    output logic obstacle_start[MAX_OBSTACLES],

    output sprite_t sprite[RENDER_SLOTS],
    output pos_t pos[RENDER_SLOTS]
);
    import runner_pkg::*;

    import distance_meter_pkg::MAX_DISTANCE_UNITS;
    import horizon_pkg::MAX_OBSTACLES;

    state_t state, next_state;

    logic update;
    logic[19:0] clk_counter;

    logic[5:0] timer;
    logic[14:0] speed;

    // Generate obstacles only after CLEAR_TIME.
    logic[7:0] clear_timer;
    logic has_obstacles;

    logic start;

    logic crashed;

    logic rng_load;
    bit[10:0] rng_data;
    lfsr_prng #(
        .DATA_WIDTH(11),
        .INVERT(0)
    ) prng_gap (
        .clk(clk),
        .load(rng_load),
        .seed(random_seed),

        .enable(1),
        .data_out(rng_data)
    );

    logic signed[11:0] trex_x_pos;
    logic signed[11:0] trex_y_pos;
    logic[9:0] trex_width;
    logic[9:0] trex_height;
    trex_pkg::frame_t trex_frame;

    trex trex_inst (
        .clk,
        .rst,

        .update,
        .timer,
        .speed(speed / SPEED_SCALE),

        .jump(jumping),
        .crash(state == CRASHED),

        .x_pos(trex_x_pos),
        .y_pos(trex_y_pos),
        .width(trex_width),
        .height(trex_height),
        .frame(trex_frame)
    );

    logic[3:0] distance_meter_digits[MAX_DISTANCE_UNITS];
    logic distance_meter_paint;

    distance_meter distance_meter_inst (
        .clk,
        .rst,

        .update,
        .speed,

        .digits(distance_meter_digits),
        .paint(distance_meter_paint)
    );

    // logic obstacle_start[MAX_OBSTACLES];

    logic signed[10:0] obstacle_x_pos[MAX_OBSTACLES];
    logic[9:0] obstacle_y_pos[MAX_OBSTACLES];
    logic[9:0] obstacle_width[MAX_OBSTACLES];
    logic[9:0] obstacle_height[MAX_OBSTACLES];
    logic[1:0] obstacle_size[MAX_OBSTACLES];

    obstacle_pkg::frame_t obstacle_frame[MAX_OBSTACLES];

    horizon horizon_inst (
        .clk,
        .rst,

        .update,
        .timer,

        .start,
        .crash(state == CRASHED),

        .speed,

        .rng_data,

        .has_obstacles,

        .obstacle_start,

        .obstacle_x_pos,
        .obstacle_y_pos,
        .obstacle_width,
        .obstacle_height,
        .obstacle_size,

        .obstacle_frame
    );

    always_comb begin
        case (state)
            WAITING: begin
                next_state = update && jumping ? RUNNING : WAITING;
            end
            RUNNING: begin
                if (crashed) begin
                    next_state = CRASHED;
                end else begin
                    next_state = RUNNING;
                end
            end
            CRASHED: begin
                next_state = CRASHED;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= WAITING;
            clk_counter <= 0;
            update <= 0;
            start <= 0;
            timer <= 0;
            speed <= 0;
            clear_timer <= 0;
            has_obstacles <= 0;
            rng_load <= 1;
        end else begin
            if (clk_counter + 1 == CLK_PER_FRAME) begin
                clk_counter <= 0;
                update <= 1;
                if (timer + 1 == FPS) begin
                    timer <= 0;
                end else begin
                    timer <= timer + 1;
                end
            end else begin
                clk_counter <= clk_counter + 1;
                update <= 0;
            end

            if (state == RUNNING && crashed) begin
                state <= CRASHED;
            end else begin
                state <= next_state;
                
                if (update && next_state == RUNNING) begin
                    rng_load <= 0;
                    if (state == WAITING) begin
                        init();
                    end else begin
                        run();
                    end
                end
            end
        end
    end

    task init;
        start <= 1;
        speed <= SPEED;
    endtask

    task run;
        clear_timer <= clear_timer + 1;
        if (clear_timer > CLEAR_TIME) begin
            has_obstacles <= 1;
        end
    endtask

    // Collision check.
    always_comb begin
        crashed = 0;
    end

    // Get the corresponding sprite type for a obstacle frame.
    function element_t element_type(obstacle_pkg::frame_t frame);
        case (frame)
            obstacle_pkg::NONE_0: return CACTUS_SMALL;
            obstacle_pkg::CACTUS_SMALL_0: return CACTUS_SMALL;
            obstacle_pkg::CACTUS_LARGE_0: return CACTUS_LARGE;
            obstacle_pkg::PTERODACTYL_0: return PTERODACTYL;
            obstacle_pkg::PTERODACTYL_1: return PTERODACTYL;
        endcase
    endfunction

    // Sprite output. Multiply by 2 for high DPI.
    always_comb begin
        for (int i = 0; i < RENDER_SLOTS; i++) begin
            sprite[i] = '{0, 0, 0, 0};
            pos[i] = '{0, 0};
        end

        sprite[RENDER_INDEX[TREX]] = '{
            SPRITE[TREX][0] + SPRITE_TREX_OFFSET[trex_frame],
            SPRITE[TREX][1],
            trex_width * 2,
            trex_pkg::HEIGHT * 2
        };
        pos[RENDER_INDEX[TREX]] = '{trex_x_pos * 2, trex_y_pos * 2};

        for (int i = 0; i < MAX_OBSTACLES; i++) begin
            if (obstacle_start[i] && obstacle_frame[i] != obstacle_pkg::NONE_0) begin
                sprite[RENDER_INDEX[element_type(obstacle_frame[i])] + i] = '{
                    SPRITE[element_type(obstacle_frame[i])][0]
                        + SPRITE_OBSTACLE_OFFSET[obstacle_frame[i]]
                            [obstacle_size[i] - 1],
                    SPRITE[element_type(obstacle_frame[i])][1],
                    obstacle_width[i] * 2,
                    obstacle_height[i] * 2
                };
                pos[RENDER_INDEX[element_type(obstacle_frame[i])] + i] = '{
                    obstacle_x_pos[i] * 2,
                    obstacle_y_pos[i] * 2
                };
            end
        end
    end

endmodule