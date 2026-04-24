module activation_layer #(
    parameter DATA_WIDTH = 8,
    parameter THRESHOLD  = 8'd10
)(
    input wire clk,
    input wire signed [DATA_WIDTH-1:0] score,
    input wire valid,
    output reg prediction,
    output reg decision_valid
);
    initial begin
        prediction = 0;
        decision_valid = 0;
    end
    
    always @(posedge clk) begin
        if (score > THRESHOLD)
            prediction = 1'b1;
        else
            prediction = 1'b0;
            
        decision_valid = valid;
    end

endmodule
