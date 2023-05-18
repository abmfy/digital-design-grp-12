module async_receiver (
    input clk,
    input rst,
    input rx,
    output next_byte,
    output logic [7:0] data
);
  parameter CLK_FREQUENCY = 100000000;  // 100 MHz
  parameter BAUD_RATE = 57600;
  parameter OVERSAMPLE_WIDTH = 3;
  parameter OVERSAMPLE_RATE = 1 << OVERSAMPLE_WIDTH;
  parameter OVERSAMPLE_DIVISOR = CLK_FREQUENCY / BAUD_RATE / OVERSAMPLE_RATE;
  parameter OVERSAMPLE_DIVISOR_BITS = $clog2(OVERSAMPLE_DIVISOR);

  logic [OVERSAMPLE_DIVISOR_BITS:0] oversample_counter = 0;
  always_ff @(posedge clk) begin
    if (rst) oversample_counter <= 0;
    else begin
      if (oversample_counter == OVERSAMPLE_DIVISOR - 1) begin
        oversample_counter <= 0;
      end else begin
        oversample_counter <= oversample_counter + 1;
      end
    end
  end
  wire oversample_tick;
  assign oversample_tick = (oversample_counter == OVERSAMPLE_DIVISOR - 1);

  wire rx_sync;
  synchronizer #(.INITIAL_VALUE(1)) synchronizer_rx (
      .clk(clk),
      .enable(oversample_tick),
      .rst(rst),
      .in(rx),
      .out(rx_sync)
  );

  wire rx_filtered;
  spike_filter #(.INITIAL_VALUE(1)) spike_filter_inst (
      .clk(clk),
      .enable(oversample_tick),
      .rst(rst),
      .in(rx_sync),
      .out(rx_filtered)
  );

  logic [3:0] state;

  logic [OVERSAMPLE_WIDTH-1:0] bit_counter;
  always_ff @(posedge clk) begin
    if (rst || state == 0) bit_counter <= 0;
    else if (oversample_tick) begin
      if (state == 0) bit_counter <= 0;
      else bit_counter <= bit_counter + 1;
    end
  end
  wire next_bit;
  assign next_bit = (bit_counter == OVERSAMPLE_RATE - 1);

  always @(posedge clk) begin
    if (rst) state <= 0;
    else if (oversample_tick)
      case (state)
        4'b0000: if (~rx_filtered) state <= 4'b1000;
        4'b1000: if (next_bit) state <= 4'b1001;
        4'b1001: if (next_bit) state <= 4'b1010;
        4'b1010: if (next_bit) state <= 4'b1011;
        4'b1011: if (next_bit) state <= 4'b1100;
        4'b1100: if (next_bit) state <= 4'b1101;
        4'b1101: if (next_bit) state <= 4'b1110;
        4'b1110: if (next_bit) state <= 4'b1111;
        4'b1111: if (next_bit) state <= 4'b0001;
        4'b0001: if (next_bit) state <= 4'b0000;
        default: state <= 4'b0000;
      endcase
  end

  assign next_byte = (oversample_tick && next_bit && state == 4'b0001);

  always @(posedge clk) begin
    if (rst) data <= 0;
    else if (oversample_tick && state[3] && next_bit) data <= {rx_filtered, data[7:1]};
  end
endmodule
