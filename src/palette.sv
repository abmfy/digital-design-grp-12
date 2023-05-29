module palette #(
    MAX_NIGHT_RATE = 255,
    NIGHT_RATE = 0
) (
    input [1:0] palette_index,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);
  always_comb begin
    case (palette_index)
      2'd1: begin
        red   = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'h52 / MAX_NIGHT_RATE;
        green = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'h54 / MAX_NIGHT_RATE;
        blue  = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'h51 / MAX_NIGHT_RATE;
      end
      2'd2: begin
        red   = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'hd8 / MAX_NIGHT_RATE;
        green = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'hda / MAX_NIGHT_RATE;
        blue  = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'hd7 / MAX_NIGHT_RATE;
      end
      2'd3: begin
        red   = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'hff / MAX_NIGHT_RATE;
        green = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'hff / MAX_NIGHT_RATE;
        blue  = NIGHT_RATE * 255 / MAX_NIGHT_RATE + (MAX_NIGHT_RATE - NIGHT_RATE * 2) * 8'hff / MAX_NIGHT_RATE;
      end
      default: begin
        red   = NIGHT_RATE * 255 / MAX_NIGHT_RATE;
        green = NIGHT_RATE * 255 / MAX_NIGHT_RATE;
        blue  = NIGHT_RATE * 255 / MAX_NIGHT_RATE;
      end
    endcase
  end
endmodule
