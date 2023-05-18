module mod_top (
    // 时钟、复位
    input wire clk_100m,  // 100M 输入时钟
    input wire reset_n,   // 上电复位信号，低有效

    // 开关、LED 等
    input  wire clock_btn,          // 左侧微动开关，推荐作为手动时钟，带消抖电路，按下时为 1
    input  wire reset_btn,          // 右侧微动开关，推荐作为手动复位，带消抖电路，按下时为 1
    input wire [3:0] touch_btn,  // 四个按钮开关，按下时为 0
    input wire [15:0] dip_sw,  // 16 位拨码开关，拨到 “ON” 时为 0
    output wire [31:0] leds,  // 32 位 LED 灯，输出 1 时点亮
    output wire [7:0] dpy_digit,  // 七段数码管笔段信号
    output wire [7:0] dpy_segment,  // 七段数码管位扫描信号

    // // PS/2 键盘、鼠标接口
    // input  wire        ps2_clock,   // PS/2 时钟信号
    // input  wire        ps2_data,    // PS/2 数据信号

    // // USB 转 TTL 调试串口
    // output wire        uart_txd,    // 串口发送数据
    // input  wire        uart_rxd,    // 串口接收数据

    // // 4MB SRAM 内存
    // inout  wire [31:0] base_ram_data,   // SRAM 数据
    // output wire [19:0] base_ram_addr,   // SRAM 地址
    // output wire [3: 0] base_ram_be_n,   // SRAM 字节使能，低有效。如果不使用字节使能，请保持为0
    // output wire        base_ram_ce_n,   // SRAM 片选，低有效
    // output wire        base_ram_oe_n,   // SRAM 读使能，低有效
    // output wire        base_ram_we_n,   // SRAM 写使能，低有效

    // HDMI 图像输出
    output wire [7:0] video_red,    // 红色像素，8位
    output wire [7:0] video_green,  // 绿色像素，8位
    output wire [7:0] video_blue,   // 蓝色像素，8位
    output wire       video_hsync,  // 行同步（水平同步）信号
    output wire       video_vsync,  // 场同步（垂直同步）信号
    output wire       video_clk,    // 像素时钟输出
    output wire       video_de,     // 行数据有效信号，用于区分消隐区

    // // RS-232 串口
    // input  wire        rs232_rxd,   // 接收数据
    // output wire        rs232_txd,   // 发送数据
    // input  wire        rs232_cts,   // Clear-To-Send 控制信号
    // output wire        rs232_rts,   // Request-To-Send 控制信号

    // // SD 卡（SPI 模式）
    // output wire        sd_sclk,     // SPI 时钟
    // output wire        sd_mosi,
    // input  wire        sd_miso,
    // output wire        sd_cs,       // SPI 片选，低有效
    // input  wire        sd_cd,       // 卡插入检测，0 表示有卡插入
    // input  wire        sd_wp,       // 写保护检测，0 表示写保护状态

    // // SDRAM 内存，信号具体含义请参考数据手册
    // output wire [12:0] sdram_addr,
    // output wire [1: 0] sdram_bank,
    // output wire        sdram_cas_n,
    // output wire        sdram_ce_n,
    // output wire        sdram_cke,
    // output wire        sdram_clk,
    // inout wire [15:0] sdram_dq,
    // output wire        sdram_dqmh,
    // output wire        sdram_dqml,
    // output wire        sdram_ras_n,
    // output wire        sdram_we_n,

    // // GMII 以太网接口、MDIO 接口，信号具体含义请参考数据手册
    // output wire        eth_gtx_clk,
    // output wire        eth_rst_n,
    // input  wire        eth_rx_clk,
    // input  wire        eth_rx_dv,
    // input  wire        eth_rx_er,
    // input  wire [7: 0] eth_rxd,
    // output wire        eth_tx_clk,
    // output wire        eth_tx_en,
    // output wire        eth_tx_er,
    // output wire [7: 0] eth_txd,
    // input  wire        eth_col,
    // input  wire        eth_crs,
    // output wire        eth_mdc,
    // inout  wire        eth_mdio

    // 无线模块（传感器）
    input  wireless_tx,
    output wireless_rx,
    output wireless_set
);
  wire clk_vga;
  pll_vga pll_vga_inst (
      .inclk0(clk_100m),
      .c0    (clk_vga)
  );
  assign video_clk = clk_vga;

  wire clk_33m;
  pll_33m pll_33m_inst (
      .inclk0(clk_100m),
      .c0    (clk_33m)
  );

  wire [15:0] acceleration;
  wire [15:0] direction;

  sensor sensor_inst (
      .clk(clk_100m),
      .rst(reset_btn),
      .wireless_tx(wireless_tx),
      .wireless_rx(wireless_rx),
      .wireless_set(wireless_set),
      .acceleration(acceleration),
      .direction(direction)
  );

  dpy_scan dpy_scan_inst (
      .clk    (clk_100m),
      .number ({acceleration, direction}),
      .dp     (7'b0),
      .digit  (dpy_digit),
      .segment(dpy_segment)
  );

  wire jumping;
  wire ducking;

  motion_detector motion_detector_inst (
      .acceleration(acceleration),
      .direction(direction),
      .jumping(jumping),
      .ducking(ducking)
  );

  assign leds[15] = jumping;
  assign leds[0] = ducking;

  wire [11:0] write_x;
  wire [11:0] write_y;
  wire [1:0] write_palette;
  wire rst_screen_33m;

  vga vga_inst (
      .clk_vga(clk_vga),
      .clk_33m(clk_33m),
      .write_x(write_x),
      .write_y(write_y),
      .write_palette(write_palette),
      .rst_screen_33m(rst_screen_33m),
      .hsync(video_hsync),
      .vsync(video_vsync),
      .data_enable(video_de),
      .output_red(video_red),
      .output_green(video_green),
      .output_blue(video_blue)
  );

  paint_demo paint_demo_inst (
      .clk_33m(clk_33m),
      .rst(rst_screen_33m),
      .jumping(jumping),
      .ducking(ducking),
      .write_x(write_x),
      .write_y(write_y),
      .write_palette(write_palette)
  );
endmodule
