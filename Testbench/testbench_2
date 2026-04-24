`timescale 1ns/1ps

module ai_system_top_tb;

    parameter DATA_WIDTH   = 8;
    parameter FRAC_WIDTH   = 4;
    parameter NUM_FEATURES = 8;

    parameter CLK_PERIOD = 10;
    parameter CLKS_PER_BIT = 434;
    parameter BIT_PERIOD = CLKS_PER_BIT * CLK_PERIOD; // for 115200 baud with 50MHz clk approx

    reg clk;
    reg rst;
    reg rx;

    wire signed [DATA_WIDTH-1:0] result;
    //wire tx;
    //wire packet_valid;
    wire done;
    //wire tx_done;
    wire prediction;
    wire decision_valid;
    
    ai_system_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH),
        .NUM_FEATURES(NUM_FEATURES)
    ) dut (

        .clk(clk),
        .rst(rst),
        .rx(rx),
        .result(result),
        .done(done),
        .led_out(prediction),
        .decision_valid(decision_valid)
        //.tx(tx),
        //.tx_done(tx_done)
    );


    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;


    // UART transmit task
    task send_byte;
        input [7:0] data;
        integer i;
    begin
        // Start bit
        rx = 0;
        #(BIT_PERIOD);

        // Data bits (LSB first)
        for (i = 0; i < 8; i = i + 1) begin
            rx = data[i];
            #(BIT_PERIOD);
        end

        // Stop bit
        rx = 1;
        #(BIT_PERIOD);
    end
    endtask
    
    always @(posedge decision_valid) begin
    if (prediction)
        $display("RESULT: It is A");
        //$display("RESULT: It is 1");
        //$display("RESULT: YES");
    else
        $display("RESULT: Not A");
        //$display("RESULT: Not 1");
        //$display("RESULT: NO");
    end
    
    initial begin
        $monitor("TIME=%0t | done=%b | result=%d", $time, done, result);
    end
    initial begin

        clk = 0;
        rst = 1;
        rx  = 1;

        #200;
        rst = 0;

        #(20*BIT_PERIOD);
        
        send_byte(8'hAA);
        #(3*BIT_PERIOD);
        
        send_byte(8'd12);
        #(3*BIT_PERIOD);
        send_byte(8'd2);
        #(3*BIT_PERIOD);
        send_byte(8'd2);
        #(3*BIT_PERIOD);
        send_byte(8'd3);
        #(3*BIT_PERIOD);
        send_byte(8'd2);
        #(3*BIT_PERIOD);
        send_byte(8'd1);
        #(3*BIT_PERIOD);
        send_byte(8'd8);
        #(3*BIT_PERIOD);
        send_byte(8'd8);
        #(3*BIT_PERIOD);
        
        send_byte(8'h55);
        #(3*BIT_PERIOD);
        
        #3000000;
        
        $finish;

    end

endmodule
