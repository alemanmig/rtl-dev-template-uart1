module uart_tb;

  localparam int unsigned CLK_FREQ = 1000000;
  localparam int unsigned BAUD_RATE = 9600;
  localparam time CLK_PERIOD = 10ns;

  logic clk_i;
  logic rst_ni;
  logic rx_i;
  logic [7:0] tx_data_i;
  logic tx_valid_i;
  logic tx_o;
  logic tx_ready_o;
  logic [7:0] rx_data_o;
  logic rx_valid_o;

  uart_top #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .rx_i(rx_i),
    .tx_data_i(tx_data_i),
    .tx_valid_i(tx_valid_i),
    .tx_o(tx_o),
    .tx_ready_o(tx_ready_o),
    .rx_data_o(rx_data_o),
    .rx_valid_o(rx_valid_o)
  );

  assign rx_i = tx_o;

  always begin
    clk_i = 1'b0;
    #(CLK_PERIOD / 2);
    clk_i = 1'b1;
    #(CLK_PERIOD / 2);
  end

  task automatic wait_cycles(input int unsigned cycles);
    repeat (cycles) @(posedge clk_i);
  endtask

  initial begin
    rst_ni = 1'b0;
    tx_data_i = '0;
    tx_valid_i = 1'b0;

    wait_cycles(5);
    rst_ni = 1'b1;

    tx_data_i = 8'hA5;
    tx_valid_i = 1'b1;
    @(posedge clk_i);
    tx_valid_i = 1'b0;

    wait (rx_valid_o);
    if (rx_data_o !== tx_data_i) begin
      $error("RX data mismatch, expected 0x%0h, got 0x%0h",
             tx_data_i, rx_data_o);
    end else begin
      $display("UART loopback test passed: 0x%0h", rx_data_o);
    end

    wait_cycles(100);
    $finish();
  end

endmodule
