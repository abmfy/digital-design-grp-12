`timescale 1ns / 1ps

module trex_sim;
    import trex_pkg::*;
    
    logic clk;
    logic rst;
    logic[3:0] speed;
    logic jump;
    logic crash;
    logic[9:0] x_pos;
    logic[9:0] y_pos;
    frame_t frame;
    
    trex dut (
        .clk,
        .rst,
        .speed,
        .jump,
        .crash,
        .x_pos,
        .y_pos,
        .frame
    );

    initial begin
        forever begin
            #10 clk = 1;
            #10 clk = 0;
        end
    end

    initial begin
        #100 rst = 1;
        #100 rst = 0;
        speed = 6;
        #100 jump = 1;
        #100 jump = 0;
        #100 crash = 1;
        #100 $finish;
    end

endmodule
