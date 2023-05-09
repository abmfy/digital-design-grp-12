module async_receiver_sim;
  logic clk = 0;
  always #5 clk = ~clk;
  logic rst = 1;
  logic rx = 1;

  wire next_byte;
  wire [7:0] data;

  async_receiver async_receiver_inst (
      .clk(clk),
      .rst(rst),
      .rx(rx),
      .next_byte(next_byte),
      .data(data)
  );

  task receive_byte(input [7:0] d);
    rx = 1;
    #17361; // 57600 baud
    rx = 0;
    #17361;
    for (integer i = 0; i < 8; i += 1) begin
      rx = d[i];
      #17361;
    end
    rx = 1;
    #17361;
  endtask

  initial begin
    #1000;
    rst = 0;

    receive_byte(8'h55);
    #123456;
    receive_byte(8'h34);
    receive_byte(8'haf);
    receive_byte(8'h00);
    #654321;
    receive_byte(8'h17);
    receive_byte(8'hff);

    for (integer i = 0; i < 256; i += 1) begin
      receive_byte(i[7:0]);
    end
  end
endmodule
