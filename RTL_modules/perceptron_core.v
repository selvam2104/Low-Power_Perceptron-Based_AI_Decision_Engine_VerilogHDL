module perceptron_core #(
    parameter DATA_WIDTH  = 8,
    parameter FRAC_WIDTH  = 4,
    parameter NUM_FEATURES = 8
)(
    input wire clk,
    input wire rst,
    input wire start,

    input wire signed [DATA_WIDTH-1:0] feature0,
    input wire signed [DATA_WIDTH-1:0] feature1,
    input wire signed [DATA_WIDTH-1:0] feature2,
    input wire signed [DATA_WIDTH-1:0] feature3,
    input wire signed [DATA_WIDTH-1:0] feature4,
    input wire signed [DATA_WIDTH-1:0] feature5,
    input wire signed [DATA_WIDTH-1:0] feature6,
    input wire signed [DATA_WIDTH-1:0] feature7,

    output reg signed [DATA_WIDTH-1:0] result,
    output reg done
);

    // Internal storage

    reg signed [DATA_WIDTH-1:0] features [0:NUM_FEATURES-1];
    reg signed [DATA_WIDTH-1:0] weights [0:NUM_FEATURES-1];
    reg signed [DATA_WIDTH-1:0] bias;

    //reg signed [2*DATA_WIDTH-1:0] mult_result;
    reg signed [(2*DATA_WIDTH)+FRAC_WIDTH+4:0] accumulator;
    reg [3:0] index;
    reg [2:0] state;
    reg start_d;

    localparam IDLE = 3'd0;
    localparam MAC = 3'd1;
    localparam ADD_BIAS = 3'd2;
    localparam DONE = 3'd3;

    initial begin
        
        /*
        weights[0] = 8'sd16;  // 1.0 in Q4.4
        weights[1] = 8'sd8;   // 0.5
        weights[2] = -8'sd4;  // -0.25
        weights[3] = 8'sd4;
        weights[4] = 8'sd2;
        weights[5] = 8'sd1;
        weights[6] = 8'sd3;
        weights[7] = -8'sd2;

        bias = 8'sd4; // 0.25
        */
        
        /*
        weights[0] = 8'sd12;   // vertical stroke (very important)
        weights[1] = -8'sd6;   // left density (low for "1")
        weights[2] = -8'sd6;   // right density
        weights[3] = 8'sd3;    // top
        weights[4] = 8'sd2;    // bottom
        weights[5] = -8'sd5;   // symmetry (low for "1")
        weights[6] = 8'sd4;    // edges
        weights[7] = 8'sd6;    // thickness

        bias = -8'sd20;
        */
        
        weights[0] = 8'sd6;    // vertical
        weights[1] = 8'sd8;    // left stroke
        weights[2] = 8'sd8;    // right stroke
        weights[3] = 8'sd5;    // top
        weights[4] = 8'sd12;   // middle bar
        weights[5] = 8'sd6;    // symmetry
        weights[6] = 8'sd4;    // edges
        weights[7] = 8'sd5;    // thickness

        bias = -8'sd25;

    end

    // Feature capture
    always @(posedge clk) begin
        if (state == IDLE && start) begin
            features[0] <= feature0;
            features[1] <= feature1;
            features[2] <= feature2;
            features[3] <= feature3;
            features[4] <= feature4;
            features[5] <= feature5;
            features[6] <= feature6;
            features[7] <= feature7;
        end
    end

    // FSM
    always @(posedge clk or posedge rst) begin

        if (rst) begin
            state <= IDLE;
            accumulator <= 0;
            index <= 0;
            done <= 0;
            result <= 0;
        end
        else begin
            case (state)

            IDLE: begin
                done <= 0;
                if (start) begin
                    accumulator <= 0;
                    index <= 0;
                    state <= MAC;
                end
            end

            MAC: begin
                accumulator <= accumulator + (features[index] * weights[index]);

                if (index < NUM_FEATURES-1)
                    index <= index + 1;
                else
                    state <= ADD_BIAS;
            end

            ADD_BIAS: begin
                accumulator <= accumulator + bias;
                state <= DONE;
            end

            DONE: begin
                // Convert back to Q4.4
                result <= accumulator >>> FRAC_WIDTH;
                done <= 1;
                state <= IDLE;
            end

            endcase
        end
    end

endmodule
