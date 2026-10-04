`timescale 1ns/1ps

module cnn_accelerator_tb;

    reg clk;
    reg reset;
    reg start;

    reg signed [7:0] pixel0;
    reg signed [7:0] pixel1;
    reg signed [7:0] pixel2;
    reg signed [7:0] pixel3;
    reg signed [7:0] pixel4;
    reg signed [7:0] pixel5;
    reg signed [7:0] pixel6;
    reg signed [7:0] pixel7;
    reg signed [7:0] pixel8;

    reg signed [7:0] weight0;
    reg signed [7:0] weight1;
    reg signed [7:0] weight2;
    reg signed [7:0] weight3;
    reg signed [7:0] weight4;
    reg signed [7:0] weight5;
    reg signed [7:0] weight6;
    reg signed [7:0] weight7;
    reg signed [7:0] weight8;

    wire signed [31:0] convolution_result;
    wire signed [31:0] relu_result;

    wire busy;
    wire done;

    integer errors;

    cnn_accelerator dut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .pixel0(pixel0),
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3),
        .pixel4(pixel4),
        .pixel5(pixel5),
        .pixel6(pixel6),
        .pixel7(pixel7),
        .pixel8(pixel8),

        .weight0(weight0),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .weight4(weight4),
        .weight5(weight5),
        .weight6(weight6),
        .weight7(weight7),
        .weight8(weight8),

        .convolution_result(convolution_result),
        .relu_result(relu_result),

        .busy(busy),
        .done(done)
    );

    // Clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin

        errors = 0;

        $dumpfile("cnn_accelerator.vcd");
        $dumpvars(0, cnn_accelerator_tb);

        // --------------------------------------------------------
        // Reset
        // --------------------------------------------------------

        reset = 1'b1;
        start = 1'b0;

        #20;

        reset = 1'b0;

        // --------------------------------------------------------
        // Input image window
        //
        // 1  2  3
        // 4  5  6
        // 7  8  9
        // --------------------------------------------------------

        pixel0 = 8'sd1;
        pixel1 = 8'sd2;
        pixel2 = 8'sd3;

        pixel3 = 8'sd4;
        pixel4 = 8'sd5;
        pixel5 = 8'sd6;

        pixel6 = 8'sd7;
        pixel7 = 8'sd8;
        pixel8 = 8'sd9;

        // --------------------------------------------------------
        // Kernel
        //
        // 1  0 -1
        // 1  0 -1
        // 1  0 -1
        // --------------------------------------------------------

        weight0 = 8'sd1;
        weight1 = 8'sd0;
        weight2 = -8'sd1;

        weight3 = 8'sd1;
        weight4 = 8'sd0;
        weight5 = -8'sd1;

        weight6 = 8'sd1;
        weight7 = 8'sd0;
        weight8 = -8'sd1;

        // --------------------------------------------------------
        // Start CNN operation
        // --------------------------------------------------------

        @(posedge clk);

        start = 1'b1;

        @(posedge clk);

        start = 1'b0;

        // Wait for completion
        wait(done);

        #10;

        $display("");
        $display("======================================");
        $display("CNN ACCELERATOR VERIFICATION");
        $display("======================================");

        $display(
            "Convolution Result = %0d",
            convolution_result
        );

        $display(
            "ReLU Result        = %0d",
            relu_result
        );

        // Expected:
        //
        // 1*1 + 2*0 + 3*(-1)
        // + 4*1 + 5*0 + 6*(-1)
        // + 7*1 + 8*0 + 9*(-1)
        //
        // = -6

        if (convolution_result !== -32'sd6) begin

            $display(
                "FAIL: Expected convolution = -6, got %0d",
                convolution_result
            );

            errors = errors + 1;

        end

        else begin

            $display(
                "PASS: Convolution = %0d",
                convolution_result
            );

        end

        // ReLU(-6) = 0

        if (relu_result !== 32'sd0) begin

            $display(
                "FAIL: Expected ReLU = 0, got %0d",
                relu_result
            );

            errors = errors + 1;

        end

        else begin

            $display("PASS: ReLU = 0");

        end

        if (errors == 0) begin

            $display("");
            $display("======================================");
            $display("ALL CNN TESTS PASSED");
            $display("======================================");

        end

        else begin

            $display("");
            $display("======================================");
            $display(
                "CNN TEST FAILED - ERRORS = %0d",
                errors
            );
            $display("======================================");

            $fatal(1);

        end

        $finish;

    end

endmodule
