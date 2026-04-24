// UART Packet Parser
// Packet Format:
// [0xAA][D0][D1][D2][D3][D4][D5][D6][D7][0x55]

module packet_parser #(
    parameter DATA_WIDTH = 8
) (

    input wire clk,
    input wire rst,

    input wire [7:0] rx_data,
    input wire rx_done,

    output reg signed [DATA_WIDTH-1:0] feature0,
    output reg signed [DATA_WIDTH-1:0] feature1,
    output reg signed [DATA_WIDTH-1:0] feature2,
    output reg signed [DATA_WIDTH-1:0] feature3,
    output reg signed [DATA_WIDTH-1:0] feature4,
    output reg signed [DATA_WIDTH-1:0] feature5,
    output reg signed [DATA_WIDTH-1:0] feature6,
    output reg signed [DATA_WIDTH-1:0] feature7,

    output reg packet_valid
);

    // State encoding
    localparam WAIT_START = 2'b00;
    localparam RECEIVE_DATA = 2'b01;
    localparam WAIT_END = 2'b10;

    reg [1:0] state;
    reg [2:0] byte_index;  // counts 0 to 7
    reg [15:0] timeout_counter;
    
    reg [7:0] rx_data_reg;
    reg rx_done_reg;
    
    reg rx_done_d;
    reg [7:0] rx_data_d;
    wire rx_done_pulse = rx_done_reg & ~rx_done_d;
    
    always @(posedge clk) begin
        rx_data_reg <= rx_data;
        rx_done_reg <= rx_done;
    end
    
    always @(posedge clk) begin
        rx_done_d <= rx_done_reg;
        rx_data_d <= rx_data_reg;
    end
    
    // FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= WAIT_START;
            byte_index <=0;
            packet_valid <= 0;
            timeout_counter <= 0;
            
            feature0 <= 0;
            feature1 <= 0;
            feature2 <= 0;
            feature3 <= 0;
            feature4 <= 0;
            feature5 <= 0;
            feature6 <= 0;
            feature7 <= 0;

        end
        
        else begin
            if (rx_done_pulse)
                timeout_counter <= 0;
            else
                timeout_counter <= timeout_counter + 1;
                
            packet_valid <= 0;  // default

            if (timeout_counter > 500000) begin
                state <= WAIT_START;
                byte_index <= 0;
                timeout_counter <= 0;
            end
            
            else begin
                case (state)
                // WAIT FOR START BYTE (0xAA)
                WAIT_START:
                begin
                    byte_index <= 0;

                    if (rx_done_pulse && rx_data_reg == 8'hAA) begin
                        state <= RECEIVE_DATA;
                    end
                end

                // RECEIVE 8 DATA BYTES
                RECEIVE_DATA:
                begin
                    if (rx_done_pulse) begin
                        timeout_counter <= 0;
                        case (byte_index)
                            3'd0: feature0 <= rx_data_reg;
                            3'd1: feature1 <= rx_data_reg;
                            3'd2: feature2 <= rx_data_reg;
                            3'd3: feature3 <= rx_data_reg;
                            3'd4: feature4 <= rx_data_reg;
                            3'd5: feature5 <= rx_data_reg;
                            3'd6: feature6 <= rx_data_reg;
                            3'd7: feature7 <= rx_data_reg;
                        endcase

                        if (byte_index < 3'd7)
                            byte_index <= byte_index + 1;
                        else
                            state <= WAIT_END;
                    end
                end

                // WAIT FOR END BYTE (0x55)
                WAIT_END: begin
                    if (rx_done_pulse) begin
                        timeout_counter <= 0;
                        if (rx_data_reg == 8'h55)
                            packet_valid <= 1;

                        state <= WAIT_START;
                    end
                end

                default:
                    state <= WAIT_START;

                endcase
                end
            end
        end

endmodule
