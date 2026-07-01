module uart_rx #(
  parameter int unsigned CLK_FREQ = 1000000,
  parameter int unsigned BAUD_RATE = 9600
) (
  input  logic       clk_i,
  input  logic       rst_ni,
  input  logic       rx_i,
  output logic       rx_valid_o,
  output logic [7:0] rx_data_o
);

  localparam int unsigned BAUD_DIV = (CLK_FREQ + BAUD_RATE / 2) / BAUD_RATE;
  localparam int unsigned BAUD_DIV_MAX = BAUD_DIV - 1;
  localparam int unsigned BAUD_DIV_HALF = BAUD_DIV / 2;

  typedef enum logic [1:0] {
    IDLE = 2'b00,
    START = 2'b01,
    DATA = 2'b10,
    STOP = 2'b11
  } uart_rx_state_e;

  uart_rx_state_e state_q, state_d;
  logic [3:0] bit_cnt_q, bit_cnt_d;
  logic [15:0] baud_cnt_q, baud_cnt_d;
  logic [7:0] shift_reg_q, shift_reg_d;
  logic sample_bit;

  always_comb begin
    state_d = state_q;
    bit_cnt_d = bit_cnt_q;
    baud_cnt_d = baud_cnt_q;
    shift_reg_d = shift_reg_q;
    sample_bit = 1'b0;

    unique case (state_q)
      IDLE: begin
        if (!rx_i) begin
          state_d = START;
          baud_cnt_d = '0;
        end
      end

      START: begin
        if (baud_cnt_q == BAUD_DIV_HALF) begin
          if (!rx_i) begin
            state_d = DATA;
            baud_cnt_d = '0;
            bit_cnt_d = '0;
          end else begin
            state_d = IDLE;
            baud_cnt_d = '0;
          end
        end else begin
          baud_cnt_d = baud_cnt_q + 1'b1;
        end
      end

      DATA: begin
        if (baud_cnt_q == BAUD_DIV_HALF) begin
          sample_bit = 1'b1;
        end

        if (baud_cnt_q == BAUD_DIV_MAX) begin
          baud_cnt_d = '0;
          if (sample_bit) begin
            shift_reg_d = {rx_i, shift_reg_q[7:1]};
          end
          if (bit_cnt_q == 4'd7) begin
            state_d = STOP;
          end else begin
            bit_cnt_d = bit_cnt_q + 1'b1;
          end
        end else begin
          baud_cnt_d = baud_cnt_q + 1'b1;
        end
      end

      STOP: begin
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
      rx_valid_o <= 1'b0;
    end else begin
      state_q <= state_d;
      bit_cnt_q <= bit_cnt_d;
      baud_cnt_q <= baud_cnt_d;
      shift_reg_q <= shift_reg_d;
      rx_data_o <= shift_reg_d;
      if (state_q == STOP && baud_cnt_q == BAUD_DIV_MAX) begin
        rx_valid_o <= 1'b1;
      end else begin
        rx_valid_o <= 1'b0;
      end
    end
  end

endmodule
