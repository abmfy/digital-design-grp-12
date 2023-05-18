module synchronizer (
    input  clk,
    input  enable,
    input  rst,
    input  in,
    output out
);
  parameter logic INITIAL_VALUE = 1'b1;

  logic [1:0] sync;

  always_ff @(posedge clk) begin
    if (rst) sync <= {2{INITIAL_VALUE}};
    else if (enable) sync <= {sync[0], in};
  end

  assign out = sync[1];
endmodule
