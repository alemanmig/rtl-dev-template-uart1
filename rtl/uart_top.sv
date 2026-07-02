module uart_top #(
  parameter int unsigned CLK_FREQ = 1000000,
  parameter int unsigned BAUD_RATE = 9600
) (
  input  logic       clk_i,
  input  logic       rst_ni,
  input  logic       rx_i,
  input  logic [7:0] tx_data_i,
  input  logic       tx_valid_i,
  output logic       tx_o,
  output logic       tx_ready_o,
  output logic [7:0] rx_data_o,
  output logic       rx_valid_o
);

  uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) u_uart_tx (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .tx_valid_i(tx_valid_i),
    .tx_data_i(tx_data_i),
    .tx_o(tx_o),
    .tx_ready_o(tx_ready_o)
  );

  uart_rx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) u_uart_rx (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .rx_i(rx_i),
    .rx_valid_o(rx_valid_o),
    .rx_data_o(rx_data_o)
  );

endmodule