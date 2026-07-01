module uart_tx #(
  parameter int unsigned CLK_FREQ = 1000000,
  parameter int unsigned BAUD_RATE = 9600
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic        tx_valid_i,
  input  logic [7:0]  tx_data_i,
  output logic        tx_o,
  output logic        tx_ready_o
);

  localparam int unsigned BAUD_DIV = (CLK_FREQ + BAUD_RATE / 2) / BAUD_RATE;
  localparam int unsigned BAUD_DIV_MAX = BAUD_DIV - 1;

  typedef enum logic [1:0] {
    IDLE = 2'b00,
    START = 2'b01,
    DATA = 2'b10,
    STOP = 2'b11
  } uart_tx_state_e;

  uart_tx_state_e state_q, state_d;
  logic [3:0] bit_cnt_q, bit_cnt_d;
  logic [15:0] baud_cnt_q, baud_cnt_d;
  logic [7:0] shift_reg_q, shift_reg_d;
  logic tx_o_d;

  assign tx_ready_o = (state_q == IDLE);

  always_comb begin
    state_d = state_q;
    bit_cnt_d = bit_cnt_q;
    baud_cnt_d = baud_cnt_q;
    shift_reg_d = shift_reg_q;
    tx_o_d = tx_o;

    unique case (state_q)
      IDLE: begin
        tx_o_d = 1'b1;
        if (tx_valid_i) begin
          state_d = START;
          baud_cnt_d = '0;
          bit_cnt_d = '0;
          shift_reg_d = tx_data_i;
          tx_o_d = 1'b0;
        end
      end

      START: begin
        if (baud_cnt_q == BAUD_DIV_MAX) begin
          baud_cnt_d = '0;
          state_d = DATA;
        end else begin
          baud_cnt_d = baud_cnt_q + 1'b1;
        end
      end

      DATA: begin
        if (baud_cnt_q == BAUD_DIV_MAX) begin
          baud_cnt_d = '0;
          if (bit_cnt_q == 4'd7) begin
            state_d = STOP;
          end else begin
            bit_cnt_d = bit_cnt_q + 1'b1;
            shift_reg_d = shift_reg_q >> 1;
          end
        end else begin
          baud_cnt_d = baud_cnt_q + 1'b1;
        end
        tx_o_d = shift_reg_q[0];
      end

      STOP: begin
        tx_o_d = 1'b1;
        if (baud_cnt_q == BAUD_DIV_MAX) begin
          baud_cnt_d = '0;
          state_d = IDLE;
        end else begin
          baud_cnt_d = baud_cnt_q + 1'b1;
        end
      end

      default: begin
        state_d = IDLE;
      end
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q <= IDLE;
      bit_cnt_q <= '0;
      baud_cnt_q <= '0;
      shift_reg_q <= '0;
      tx_o <= 1'b1;
    end else begin
      state_q <= state_d;
      bit_cnt_q <= bit_cnt_d;
      baud_cnt_q <= baud_cnt_d;
      shift_reg_q <= shift_reg_d;
      tx_o <= tx_o_d;
    end
  end

endmodule
