module uart_tx #(

    parameter DATA_WIDTH   = 8,
    parameter CLKS_PER_BIT = 434

)(

    input  wire clk,
    input  wire rst,

    input  wire tx_start,
    input  wire [DATA_WIDTH-1:0] tx_data,
    
    output reg  tx_busy,
    output reg  tx,
    output reg  tx_done
);

    // FSM States
    localparam IDLE  = 3'd0;
    localparam START = 3'd1;
    localparam DATA  = 3'd2;
    localparam STOP  = 3'd3;
    localparam DONE  = 3'd4;

    reg [2:0] state;

    reg [15:0] clk_count;
    reg [3:0]  bit_index;

    reg [DATA_WIDTH-1:0] data_reg;

    // FSM
    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state      <= IDLE;
            tx         <= 1'b1;
            clk_count  <= 0;
            bit_index  <= 0;
            tx_done    <= 0;
        end

        else begin

            case (state)

                // IDLE
                IDLE: begin
                    tx_busy <= 0;
                    tx <= 1'b1;
                    tx_done <= 0;
                    clk_count <= 0;
                    bit_index <= 0;

                    if (tx_start) begin
                        tx_busy <= 1;
                        data_reg <= tx_data;
                        state <= START;
                    end
                end

                // ----------------
                // START BIT
                // ----------------
                START: begin
                    tx <= 1'b0;

                    if (clk_count < CLKS_PER_BIT-1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= DATA;
                    end
                end

                // DATA BITS
                DATA: begin
                    tx <= data_reg[bit_index];

                    if (clk_count < CLKS_PER_BIT-1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;

                        if (bit_index < DATA_WIDTH-1)
                            bit_index <= bit_index + 1;
                        else begin
                            bit_index <= 0;
                            state <= STOP;
                        end
                    end
                end

                // STOP BIT
                STOP: begin
                    tx <= 1'b1;

                    if (clk_count < CLKS_PER_BIT-1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= DONE;
                    end
                end

                // DONE
                DONE: begin
                    tx_done <= 1'b1;
                    tx_busy <= 0;
                    state <= IDLE;
                end

                default:
                    state <= IDLE;

            endcase

        end

    end

endmodule
