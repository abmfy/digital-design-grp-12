`timescale 1ns / 1ps

parameter CLK_FREQ = 100_000_000;
parameter FPS = 60;
parameter CLK_PER_FRAME = CLK_FREQ / FPS;

module obstacle_sim;
    import obstacle_pkg::*;
    
    logic clk;
    logic rst;

    logic[5:0] timer = 0;

    type_t typ = CACTUS_SMALL;
    logic start = 0;
    logic crash = 0;

    logic[1:0] size = 0;

    logic[3:0] speed = 0;

    logic signed[9:0] x_pos;
    logic[9:0] y_pos;
    logic[9:0] width;
    logic[9:0] height;

    logic[11:0] sprite_x_pos;
    logic[11:0] sprite_y_pos;
    
    obstacle dut (
        .clk,
        .rst,
        .timer,
        .typ,
        .start,
        .crash,
        .size,
        .speed,
        .x_pos,
        .y_pos,
        .width,
        .height,
        .sprite_x_pos,
        .sprite_y_pos
    );

    integer counter = 0;

    initial begin
        forever begin
            #5 clk = 1;
            counter = counter + 1;
            if (counter == CLK_PER_FRAME) begin
                counter = 0;
                timer = timer + 1;
                if (timer == FPS) begin
                    timer = 0;
                end
            end
            #5 clk = 0;
        end
    end

    initial begin
        #100 rst = 1;
        #100 rst = 0;
        #100;
        speed = 6;
        crash = 0;

        typ = CACTUS_LARGE;
        size = 2;
        start = 1;
        #10;
        start = 0;
        #1000;

        typ = CACTUS_SMALL;
        size = 2;
        start = 1;
        #10;
        start = 0;
        #1000;

        #1000;
        typ = PTERODACTYL;
        size = 2;
        start = 1;
        #10;
        start = 0;
        #1000;

        $finish;
    end

endmodule
