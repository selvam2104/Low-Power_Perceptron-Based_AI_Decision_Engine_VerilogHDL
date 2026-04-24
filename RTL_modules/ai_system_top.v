module ai_system_top #(

    parameter DATA_WIDTH   = 8,
    parameter FRAC_WIDTH   = 4,
    parameter NUM_FEATURES = 8,
    parameter CLKS_PER_BIT = 434

)(

    input wire clk,
    input wire rst,
    input wire rx,
    output wire done,
    output wire signed [DATA_WIDTH-1:0] result,
    output wire led_out,
    output wire decision_valid,
    output wire tx
    //output wire tx_done
);

    // Feature Wires
    wire signed [DATA_WIDTH-1:0] feature0;
    wire signed [DATA_WIDTH-1:0] feature1;
    wire signed [DATA_WIDTH-1:0] feature2;
    wire signed [DATA_WIDTH-1:0] feature3;
    wire signed [DATA_WIDTH-1:0] feature4;
    wire signed [DATA_WIDTH-1:0] feature5;
    wire signed [DATA_WIDTH-1:0] feature6;
    wire signed [DATA_WIDTH-1:0] feature7;

    //wire packet_valid;
    wire prediction;
    //wire decision_valid;
    wire [DATA_WIDTH-1:0] tx_data;
    
    reg packet_valid_d;
    
    always @(posedge clk) begin
        packet_valid_d <= packet_valid;
    end
    
    wire start_pulse = packet_valid & ~packet_valid_d;
    wire tx_busy;
    
    assign led_out = prediction;
    
    // Communication Top
    comm_top comm_inst (

        .clk(clk),
        .rst(rst),
        .rx(rx),

        .feature0(feature0),
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .feature4(feature4),
        .feature5(feature5),
        .feature6(feature6),
        .feature7(feature7),

        .packet_valid(packet_valid)
    );

    // Perceptron AI Core
    perceptron_core #(
        .DATA_WIDTH(DATA_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH),
        .NUM_FEATURES(NUM_FEATURES)
    ) ai_core (

        .clk(clk),
        .rst(rst),
        .start(start_pulse),

        .feature0(feature0),
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .feature4(feature4),
        .feature5(feature5),
        .feature6(feature6),
        .feature7(feature7),

        .result(result),
        .done(done)
    );
    
    activation_layer #(
        .DATA_WIDTH(DATA_WIDTH),
        //.THRESHOLD(10)    //generic
        //.THRESHOLD(8)     //digit 1
        .THRESHOLD(15)      //char A
    ) act_layer (
        .clk(clk),
        .score(result),
        .valid(done),
        .prediction(prediction),
        .decision_valid(decision_valid)
    );
    
    uart_tx #(
        .DATA_WIDTH(8),
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_tx_inst (

        .clk(clk),
        .rst(rst),

        .tx_start(decision_valid & ~tx_busy),
        .tx_data({7'b0,prediction}),

        .tx(tx),
        .tx_done(tx_done)
    );

endmodule
