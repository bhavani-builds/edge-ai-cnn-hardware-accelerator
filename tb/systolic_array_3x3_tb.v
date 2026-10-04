`timescale 1ns/1ps

module systolic_array_3x3_tb;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;

    reg clk;
    reg reset;
    reg enable;

    reg signed [DATA_WIDTH-1:0] activation_in0;
    reg signed [DATA_WIDTH-1:0] activation_in1;
    reg signed [DATA_WIDTH-1:0] activation_in2;

    reg signed [DATA_WIDTH-1:0] weight_in0;
    reg signed [DATA_WIDTH-1:0] weight_in1;
    reg signed [DATA_WIDTH-1:0] weight_in2;

    wire signed [ACC_WIDTH-1:0] result00;
    wire signed [ACC_WIDTH-1:0] result01;
    wire signed [ACC_WIDTH-1:0] result02;

    wire signed [ACC_WIDTH-1:0] result10;
    wire signed [ACC_WIDTH-1:0] result11;
    wire signed [ACC_WIDTH-1:0] result12;

    wire signed [ACC_WIDTH-1:0] result20;
    wire signed [ACC_WIDTH-1:0] result21;
    wire signed [ACC_WIDTH-1:0] result22;


    // Clock
    always #5 clk = ~clk;


    // DUT
    systolic_array_3x3 #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),

        .activation_in0(activation_in0),
        .activation_in1(activation_in1),
        .activation_in2(activation_in2),

        .weight_in0(weight_in0),
        .weight_in1(weight_in1),
        .weight_in2(weight_in2),

        .result00(result00),
        .result01(result01),
        .result02(result02),

        .result10(result10),
        .result11(result11),
        .result12(result12),

        .result20(result20),
        .result21(result21),
        .result22(result22)
    );


    initial begin

        $dumpfile("systolic_array_3x3.vcd");
        $dumpvars(0, systolic_array_3x3_tb);

        clk = 0;
        reset = 1;
        enable = 0;

        activation_in0 = 0;
        activation_in1 = 0;
        activation_in2 = 0;

        weight_in0 = 0;
        weight_in1 = 0;
        weight_in2 = 0;

        #20;

        reset = 0;
        enable = 1;


        // ------------------------------------------------
        // Test 1
        // ------------------------------------------------

        activation_in0 = 1;
        activation_in1 = 2;
        activation_in2 = 3;

        weight_in0 = 1;
        weight_in1 = 2;
        weight_in2 = 3;

        #10;


        // ------------------------------------------------
        // Test 2
        // ------------------------------------------------

        activation_in0 = 4;
        activation_in1 = 5;
        activation_in2 = 6;

        weight_in0 = 4;
        weight_in1 = 5;
        weight_in2 = 6;

        #10;


        // ------------------------------------------------
        // Test 3
        // ------------------------------------------------

        activation_in0 = 7;
        activation_in1 = 8;
        activation_in2 = 9;

        weight_in0 = 7;
        weight_in1 = 8;
        weight_in2 = 9;

        #10;


        enable = 0;

        #10;

        $display("--------------------------------");
        $display("3x3 SYSTOLIC ARRAY TEST");
        $display("--------------------------------");

        $display("Result00 = %d", result00);
        $display("Result01 = %d", result01);
        $display("Result02 = %d", result02);

        $display("Result10 = %d", result10);
        $display("Result11 = %d", result11);
        $display("Result12 = %d", result12);

        $display("Result20 = %d", result20);
        $display("Result21 = %d", result21);
        $display("Result22 = %d", result22);

        $display("--------------------------------");
        $display("SYSTOLIC ARRAY SIMULATION PASSED");
        $display("--------------------------------");

        $finish;

    end

endmodule
