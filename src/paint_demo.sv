`timescale 1ns / 1ps

module paint_demo #(
    COOR_WIDTH = 12,
    ELEMENT_COUNT = 32,
    ELEMENT_WIDTH = 5
) (
    input clk_33m,
    input rst,
    output logic [COOR_WIDTH-1:0] write_x,
    output logic [COOR_WIDTH-1:0] write_y,
    output logic [1:0] write_palette
);
  logic painting_background;
  logic [ELEMENT_WIDTH-1:0] element_index;

  // paint background

  logic background_rst;
  logic background_wait;
  wire [COOR_WIDTH-1:0] background_x;
  wire [COOR_WIDTH-1:0] background_y;
  wire [1:0] background_palette;
  wire background_finished;

  paint_background #(
      .COOR_WIDTH(COOR_WIDTH)
  ) paint_background_inst (
      .clk_33m(clk_33m),
      .rst(background_rst),
      .write_x(background_x),
      .write_y(background_y),
      .write_palette(background_palette),
      .finished(background_finished)
  );

  // paint element

  logic element_rst;
  logic element_wait;
  logic [COOR_WIDTH-1:0] sprite_x;
  logic [COOR_WIDTH-1:0] sprite_y;
  logic [COOR_WIDTH-1:0] frame_x;
  logic [COOR_WIDTH-1:0] frame_y;
  logic [COOR_WIDTH-1:0] element_width;
  logic [COOR_WIDTH-1:0] element_height;
  wire [COOR_WIDTH-1:0] element_x;
  wire [COOR_WIDTH-1:0] element_y;
  wire [1:0] element_palette;
  wire element_finished;

  paint_element #(
      .COOR_WIDTH(COOR_WIDTH)
  ) paint_element_inst (
      .clk_33m(clk_33m),
      .rst(element_rst),
      .sprite_x(sprite_x),
      .sprite_y(sprite_y),
      .frame_x(frame_x),
      .frame_y(frame_y),
      .width(element_width),
      .height(element_height),
      .write_x(element_x),
      .write_y(element_y),
      .write_palette(element_palette),
      .finished(element_finished)
  );

  // element info

  logic [COOR_WIDTH-1:0] dino_x = 0;
  logic last_rst = 0;

  always_ff @(posedge clk_33m) begin
    if (rst && !last_rst) begin
      if (dino_x == 1192) dino_x <= 0;
      else dino_x <= dino_x + 1;
    end
    last_rst <= rst;
  end

  always_comb begin
    case (element_index)
      // ground
      0: begin
        sprite_x = 1084;
        sprite_y = 104;
        frame_x = 0;
        frame_y = 226;
        element_width = 1280;
        element_height = 24;
      end
      1: begin  // cactus
        sprite_x = 582;
        sprite_y = 2;
        frame_x = 300;
        frame_y = 178;
        element_width = 68;
        element_height = 70;
      end
      // dino
      3: begin
        sprite_x = dino_x & 8 ? 1854 : 1942;
        sprite_y = 2;
        frame_x = dino_x;
        frame_y = 156;
        element_width = 88;
        element_height = 94;
      end
      5: begin  // cactus
        sprite_x = 850;
        sprite_y = 2;
        frame_x = 700;
        frame_y = 148;
        element_width = 102;
        element_height = 100;
      end
      6: begin  // moon
        sprite_x = 1194;
        sprite_y = 2;
        frame_x = 800;
        frame_y = 30;
        element_width = 40;
        element_height = 80;
      end
      default: begin
        sprite_x = 0;
        sprite_y = 0;
        frame_x = 0;
        frame_y = 0;
        element_width = 0;
        element_height = 0;
      end
    endcase
  end

  // paint which

  always_ff @(posedge clk_33m) begin
    if (rst) begin
      painting_background <= 1;
      background_rst <= 1;
      background_wait <= 1;
      element_index <= 0;
      element_rst <= 1;
      element_wait <= 1;
    end else if (painting_background) begin
      if (background_wait) background_wait <= 0;
      else if (background_finished) painting_background <= 0;
      else background_rst <= 0;
    end else begin
      if (element_wait) begin
        element_wait <= 0;
      end else if (element_finished && element_index != ELEMENT_COUNT - 1) begin
        element_index <= element_index + 1;
        element_rst   <= 1;
        element_wait  <= 1;
      end else begin
        element_rst <= 0;
      end
    end
  end

  // output

  always_comb begin
    if (painting_background) begin
      write_x = background_x;
      write_y = background_y;
      write_palette = background_palette;
    end else begin
      write_x = element_x;
      write_y = element_y;
      write_palette = element_palette;
    end
  end
endmodule
