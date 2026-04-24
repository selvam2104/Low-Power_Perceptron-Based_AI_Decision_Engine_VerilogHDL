module comm_top #(
    parameter DATA_WIDTH = 8
)(

    input clk,
    input rst,
    input rx,   // UART serial input

    output signed [DATA_WIDTH-1:0] feature0,
    output signed [DATA_WIDTH-1:0] feature1,
    output signed [DATA_WIDTH-1:0] feature2,
    output signed [DATA_WIDTH-1:0] feature3,
    output signed [DATA_WIDTH-1:0] feature4,
    output signed [DATA_WIDTH-1:0] feature5,
    output signed [DATA_WIDTH-1:0] feature6,
    output signed [DATA_WIDTH-1:0] feature7,

    output packet_valid
);

    wire [7:0] rx_data;
    wire rx_done;

    // UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(434),   // 50MHz / 115200 ? 433
        .DATA_WIDTH(DATA_WIDTH)
    ) uart_rx_inst (
        .clk(clk),
        .rst(rst),
        .rx_serial(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Packet Parser
    packet_parser #(
        .DATA_WIDTH(DATA_WIDTH)
    ) parser_inst (
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_done(rx_done),

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

endmodule
