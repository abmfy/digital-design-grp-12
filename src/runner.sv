package runner_pkg;
    parameter GAME_WIDTH = 600;

    parameter RANDOM_SEED = 19260817;
endpackage

import runner_pkg::*;

module runner (
    input clk,
    input rst
);
    logic playing;

    logic[5:0] timer;

    // trex trex_inst(
    //     .clk(clk),
    //     .rst(rst),
    // );

    logic rng_load;
    logic[10:0] rng_data;
    lfsr_prng #(
        .DATA_WIDTH(11),
        .INVERT(0)
    ) prng_gap (
        .clk(clk),
        .load(rng_load),
        .seed(RANDOM_SEED),

        .enable(1),
        .data_out(rng_data)
    );

endmodule