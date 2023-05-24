module resetter (
    input clk,
    input rst_in,
    output rst_out
);
    localparam WIDTH = 24;
    localparam CNT = 2 ** WIDTH - 1;
    logic[WIDTH-1:0] cnt;
        
    always @(posedge clk) begin
        if (cnt != CNT) begin
            cnt <= cnt + 1;
        end
        rst_out <= cnt != CNT || rst_in;
    end
endmodule
