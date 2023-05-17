module palette (
    input [1:0] palette_index,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);
  always_comb begin
    case (palette_index)
      2'd1: begin
        red   = 8'h52;
        green = 8'h54;
        blue  = 8'h51;
      end
      2'd2: begin
        red   = 8'hd8;
        green = 8'hda;
        blue  = 8'hd7;
      end
      2'd3: begin
        red   = 8'hff;
        green = 8'hff;
        blue  = 8'hff;
      end
      default: begin
        red   = 8'h00;
        green = 8'h00;
        blue  = 8'h00;
      end
    endcase
  end
endmodule
