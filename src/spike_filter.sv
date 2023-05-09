module spike_filter (
    input clk,
    input enable,
    input rst,
    input in,
    output logic out
);
  parameter WIDTH = 2;
  parameter INITIAL_VALUE = 1;

  logic [WIDTH-1:0] cnt = 0;

  always_ff @(posedge clk) begin
    if (rst) begin
      cnt <= INITIAL_VALUE[0];
      out <= INITIAL_VALUE[0];
    end else if (enable) begin
      if (cnt == 0) out <= 0;
      else if (~in) cnt <= cnt - 1;
      if (&cnt) out <= 1;
      else if (in) cnt <= cnt + 1;
    end
  end
endmodule
