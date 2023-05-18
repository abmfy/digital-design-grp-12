module sensor_sim;
  logic clk = 0;
  always #5 clk = ~clk;
  logic rst = 1;
  logic wireless_tx = 1;

  wire wireless_set;
  wire signed [15:0] acceleration = 0;
  wire signed [15:0] direction = 0;

  sensor sensor_inst (
      .clk(clk),
      .rst(rst),
      .wireless_tx(wireless_tx),
      .wireless_set(wireless_set),
      .acceleration(acceleration),
      .direction(direction)
  );

  task send_byte(input [7:0] d);
    wireless_tx = 1;
    #17361;  // 57600 baud
    wireless_tx = 0;
    #17361;
    for (integer i = 0; i < 8; i += 1) begin
      wireless_tx = d[i];
      #17361;
    end
    wireless_tx = 1;
    #17361;
  endtask

  task send_message(input [7:0] message_type, input [15:0] data[0:3]);
    logic [7:0] checksum;
    checksum = 8'h55 + message_type;
    for (integer i = 0; i < 4; i += 1) begin
      checksum += data[i][7:0] + data[i][15:8];
    end

    send_byte(8'h55);
    send_byte(message_type);
    for (integer i = 0; i < 4; i += 1) begin
      send_byte(data[i][7:0]);
      send_byte(data[i][15:8]);
    end
    send_byte(checksum);
  endtask

  initial begin
    #1000;
    rst = 0;

    send_message(8'h51, {16'h0123, 16'h4567, 16'h89ab, 16'hcdef});
    #233333;
    send_message(8'h52, {16'h0123, 16'h4567, 16'h89ab, 16'hcdef});
    send_byte(8'h76);  // noise
    send_message(8'h53, {16'h0123, 16'h4567, 16'h89ab, 16'hcdef});
    send_message(8'h54, {16'h0123, 16'h4567, 16'h89ab, 16'hcdef});
    #345678;
    send_message(8'h53, {16'hfedc, 16'hba98, 16'h7654, 16'h3210});
    send_byte(8'h13);  // noise
    send_message(8'h52, {16'hfedc, 16'hba98, 16'h7654, 16'h3210});
    #98765;
    send_message(8'h51, {16'hfedc, 16'hba98, 16'h7654, 16'h3210});
  end
endmodule
