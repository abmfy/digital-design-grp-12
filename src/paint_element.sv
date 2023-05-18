`timescale 1ns / 1ps

module paint_element #(
    COOR_WIDTH = 11,
    ROM_WIDTH = 19,
    SPRITE_WIDTH = 2446
) (
    input clk_33m,
    input rst, // start painting
    // left top coordinate on sprite
    input [COOR_WIDTH-1:0] sprite_x,
    input [COOR_WIDTH-1:0] sprite_y,
    // left top coordinate on frame
    input [COOR_WIDTH-1:0] frame_x,
    input [COOR_WIDTH-1:0] frame_y,
    // size of the element
    input [COOR_WIDTH-1:0] width,
    input [COOR_WIDTH-1:0] height,
    // write to RAM
    output [COOR_WIDTH-1:0] write_x,
    output [COOR_WIDTH-1:0] write_y,
    output [1:0] write_palette,
    // paint finished
    output finished
);

  logic [COOR_WIDTH-1:0] x;
  logic [COOR_WIDTH-1:0] y;
  logic [COOR_WIDTH-1:0] last_x[1:0];
  logic [COOR_WIDTH-1:0] last_y[1:0];

  assign finished = last_y[1] == height;

  always_ff @(posedge clk_33m) begin
    if (rst) begin
      x <= 0;
      y <= 0;
      last_x[0] <= 0;
      last_x[1] <= 0;
      last_y[0] <= 0;
      last_y[1] <= 0;
    end else if (!finished) begin
      if (x == width - 1) begin
        x <= 0;
        y <= y + 1;
      end else begin
        x <= x + 1;
      end
      last_x[0] <= x;
      last_x[1] <= last_x[0];
      last_y[0] <= y;
      last_y[1] <= last_y[0];
    end
  end

  logic [ROM_WIDTH-1:0] rom_addr;

  always_comb begin
    if (y == height) rom_addr = 0;
    else rom_addr = (sprite_x + x) + (sprite_y + y) * SPRITE_WIDTH;
  end

  wire [1:0] read_palette;
  rom_sprite rom_sprite_inst (
      .clock(clk_33m),
      .address(rom_addr),
      .q(read_palette)
  );

  assign write_x = finished ? 0 : frame_x + last_x[1];
  assign write_y = finished ? 0 : frame_y + last_y[1];
  assign write_palette = finished ? 0 : read_palette;
endmodule
