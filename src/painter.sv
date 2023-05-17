import runner_pkg::sprite_t;
import runner_pkg::pos_t;

module painter #(
    COOR_WIDTH = 11,
    ELEMENT_COUNT = 32,
    ELEMENT_WIDTH = $clog2(COOR_WIDTH)
) (
    input clk_33m,
    input rst,

    input sprite_t sprite[ELEMENT_COUNT],
    input pos_t pos[ELEMENT_COUNT],

    output logic[COOR_WIDTH-1:0] write_x,
    output logic[COOR_WIDTH-1:0] write_y,
    output logic[1:0] write_palette
);
    logic painting_background;
    logic[ELEMENT_WIDTH-1:0] element_index;

    // paint background

    logic background_rst;
    logic background_wait;
    wire[COOR_WIDTH-1:0] background_x;
    wire[COOR_WIDTH-1:0] background_y;
    wire[1:0] background_palette;
    wire background_finished;

    paint_background #(
        .COOR_WIDTH(COOR_WIDTH)
    ) paint_background_inst (
        .clk_33m,
        .rst(background_rst),
        .write_x(background_x),
        .write_y(background_y),
        .write_palette(background_palette),
        .finished(background_finished)
    );

    // paint element

    logic element_rst;
    logic element_wait;
    logic[COOR_WIDTH-1:0] sprite_x;
    logic[COOR_WIDTH-1:0] sprite_y;
    logic signed[COOR_WIDTH:0] frame_x;
    logic signed[COOR_WIDTH:0] frame_y;
    logic[COOR_WIDTH-1:0] element_width;
    logic[COOR_WIDTH-1:0] element_height;
    wire[COOR_WIDTH-1:0] element_x;
    wire[COOR_WIDTH-1:0] element_y;
    wire[1:0] element_palette;
    wire element_finished;

    paint_element #(
        .COOR_WIDTH(COOR_WIDTH)
    ) paint_element_inst (
        .clk_33m,
        .rst(element_rst),
        .sprite_x,
        .sprite_y,
        .frame_x,
        .frame_y,
        .width(element_width),
        .height(element_height),
        .write_x(element_x),
        .write_y(element_y),
        .write_palette(element_palette),
        .finished(element_finished)
    );

    // element info

    always_comb begin
        frame_x = pos[29].x;
        frame_y = pos[29].y;
        sprite_x = sprite[29].x;
        sprite_y = sprite[29].y;
        element_width = sprite[29].w;
        element_height = sprite[29].h;
        // {frame_x, frame_y}
        //     = pos[element_index];
        // {sprite_x, sprite_y, element_width, element_height} 
        //     = sprite[element_index];
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
