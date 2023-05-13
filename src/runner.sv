package runner_pkg;
    parameter GAME_WIDTH = 600;
endpackage

import runner_pkg::*;

module runner(
    input clk,
    input rst
);
    logic playing;

    logic[5:0] timer;

    // trex trex_inst(
    //     .clk(clk),
    //     .rst(rst),
    // );

endmodule