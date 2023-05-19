// Handles displaying the distance meter.
package distance_meter_pkg;
    parameter GAME_WIDTH = 640;
    parameter SPEED_SCALE = 1024;

    parameter WIDTH = 10;
    parameter HEIGHT = 13;
    parameter DEST_WIDTH = 11;

    // Y positioning of the digits in the sprite sheet.
    // X position is always 0.
    parameter int Y_POS[10] = '{0, 13, 27, 40, 53, 67, 80, 93, 107, 120};

    // Distance meter config.

    // Number of digits.
    parameter MAX_DISTANCE_UNITS = 5;

    // Distance that causes achievement animation.
    parameter ACHIEVEMENT_DISTANCE = 100;

    // Used for conversion from pixel distance to a scaled unit.
    parameter COEFFICIENT = 40 * SPEED_SCALE;

    // Flash duration in frames.
    parameter FLASH_DURATION = 15;

    // Flash iterations for achievement animation.
    parameter FLASH_ITERATONS = 3;

    parameter X = GAME_WIDTH - (DEST_WIDTH * (MAX_DISTANCE_UNITS + 1));

endpackage

import distance_meter_pkg::*;

// Distance meter module.
module distance_meter(
    input clk,
    input rst,

    input update,

    input[14:0] speed,

    output logic[3:0] digits[MAX_DISTANCE_UNITS],
    output logic paint
);

    logic[15:0] distance_counter;
    logic[16:0] distance;

    logic achievement;
    logic[16:0] achievement_distance;
    logic[4:0] flash_timer;
    logic[2:0] flash_iterations;

    always_ff @(posedge clk) begin
        if (rst) begin
            paint <= 1;
            distance_counter <= 0;
            distance <= 0;
            achievement <= 0;
            achievement_distance <= 0;
            flash_timer <= 0;
            flash_iterations <= 0;
        end else if (!speed) begin
            achievement <= 0;
            paint <= 1;
        end else if (update) begin
            if (distance_counter + speed < COEFFICIENT) begin
                distance_counter <= distance_counter + speed;
            end else begin
                distance_counter <= distance_counter + speed - COEFFICIENT;
                if (distance + 1 < 10 ** MAX_DISTANCE_UNITS - 1) begin
                    distance <= distance + 1;
                end else begin
                    distance <= 10 ** MAX_DISTANCE_UNITS - 1;
                end
            end

            // Achievement unlocked.
            if (distance && distance % ACHIEVEMENT_DISTANCE == 0) begin
                achievement <= 1;
                achievement_distance <= distance;
                flash_iterations <= 0;
            end

            if (achievement) begin
                // Flash score.
                if (flash_iterations <= FLASH_ITERATONS) begin
                    flash_timer <= flash_timer + update;

                    if (flash_timer < FLASH_DURATION) begin
                        paint <= 0;
                    end else begin
                        paint <= 1;
                        if (flash_timer > FLASH_DURATION * 2) begin
                            flash_timer <= 0;
                            flash_iterations <= flash_iterations + 1;
                        end
                    end
                end else begin
                    achievement <= 0;
                    flash_timer <= 0;
                    flash_iterations <= 0;
                end
            end
        end
    end

    always_comb begin
        for (int i = 0; i < MAX_DISTANCE_UNITS; i++) begin
            digits[i] = (achievement ? achievement_distance : distance) /
                (10 ** (MAX_DISTANCE_UNITS - i - 1)) % 10;
        end
    end

endmodule
