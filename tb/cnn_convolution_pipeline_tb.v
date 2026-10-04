`timescale 1ns/1ps

module cnn_convolution_pipeline_tb;

    parameter DATA_WIDTH  = 8;
    parameter ACC_WIDTH   = 32;
    parameter IMAGE_WIDTH = 4;

    reg clk;
    reg reset;
    reg enable;

    reg signed [DATA_WIDTH-1:0] pixel_in;

    reg signed [DATA_WIDTH-1:0] weight0;
    reg signed [DATA_WIDTH-1:0] weight1;
    reg signed [DATA_WIDTH-1:0] weight2;

    reg signed [DATA_WIDTH-1:0] weight3;
    reg signed [DATA_WIDTH-1:0] weight4;
    reg signed [DATA_WIDTH-1:0] weight5;

    reg signed [DATA_WIDTH-1:0] weight6;
    reg signed [DATA_WIDTH-1:0] weight7;
    reg signed [DATA_WIDTH-1:0] weight8;

    wire signed [ACC_WIDTH-1:0] convolution_result;
    wire signed [ACC_WIDTH-1:0] relu_result;

    wire window_valid;


    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    always #5 clk = ~clk;


    // ------------------------------------------------
    // DUT
    // ------------------------------------------------

    cnn_convolution_pipeline #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .IMAGE_WIDTH(IMAGE_WIDTH)
    ) dut (

        .clk(clk),
        .reset(reset),
        .enable(enable),

        .pixel_in(pixel_in),

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

        .window_valid(window_valid)
    );


    // ------------------------------------------------
    // Send one pixel
    // ------------------------------------------------

    task send_pixel;

        input integer value;

        begin

            @(negedge clk);

            pixel_in = value;

            @(posedge clk);

            #1;

            if (window_valid) begin

                $display(
                    "Window valid -> Convolution = %0d, ReLU = %0d",
                    convolution_result,
                    relu_result
                );

            end

        end

    endtask


    // ------------------------------------------------
    // Test
    // ------------------------------------------------

    initial begin

        $dumpfile("cnn_convolution_pipeline.vcd");
        $dumpvars(0, cnn_convolution_pipeline_tb);


        clk = 0;
        reset = 1;
        enable = 0;

        pixel_in = 0;


        // ------------------------------------------------
        // Vertical edge detection kernel
        //
        //  1   0  -1
        //  1   0  -1
        //  1   0  -1
        // ------------------------------------------------

        weight0 = 1;
        weight1 = 0;
        weight2 = -1;

        weight3 = 1;
        weight4 = 0;
        weight5 = -1;

        weight6 = 1;
        weight7 = 0;
        weight8 = -1;


        #20;

        reset = 0;
        enable = 1;


        // ------------------------------------------------
        // 4x4 input image
        //
        //  1   2   3   4
        //  5   6   7   8
        //  9  10  11  12
        // 13  14  15  16
        // ------------------------------------------------

        send_pixel(1);
        send_pixel(2);
        send_pixel(3);
        send_pixel(4);

        send_pixel(5);
        send_pixel(6);
        send_pixel(7);
        send_pixel(8);

        send_pixel(9);
        send_pixel(10);
        send_pixel(11);
        send_pixel(12);

        send_pixel(13);
        send_pixel(14);
        send_pixel(15);
        send_pixel(16);


        #30;

        enable = 0;


        $display("");
        $display("------------------------------------------");
        $display("CNN CONVOLUTION PIPELINE TEST COMPLETE");
        $display("------------------------------------------");

        $finish;

    end

endmodule
