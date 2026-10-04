`timescale 1ns/1ps

module sliding_window_3x3_tb;

    parameter DATA_WIDTH = 8;

    reg clk;
    reg reset;
    reg enable;

    reg signed [DATA_WIDTH-1:0] pixel_in;

    wire signed [DATA_WIDTH-1:0] window0;
    wire signed [DATA_WIDTH-1:0] window1;
    wire signed [DATA_WIDTH-1:0] window2;

    wire signed [DATA_WIDTH-1:0] window3;
    wire signed [DATA_WIDTH-1:0] window4;
    wire signed [DATA_WIDTH-1:0] window5;

    wire signed [DATA_WIDTH-1:0] window6;
    wire signed [DATA_WIDTH-1:0] window7;
    wire signed [DATA_WIDTH-1:0] window8;

    wire valid;


    // Clock
    always #5 clk = ~clk;


    // DUT
    sliding_window_3x3 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .pixel_in(pixel_in),

        .window0(window0),
        .window1(window1),
        .window2(window2),

        .window3(window3),
        .window4(window4),
        .window5(window5),

        .window6(window6),
        .window7(window7),
        .window8(window8),

        .valid(valid)
    );


    // Send one pixel
    task send_pixel;
        input integer value;
        begin
            @(negedge clk);
            pixel_in = value;
            @(posedge clk);
            #1;

            if (valid) begin
                $display(
                    "Window: %0d %0d %0d | %0d %0d %0d | %0d %0d %0d",
                    window0, window1, window2,
                    window3, window4, window5,
                    window6, window7, window8
                );
            end
        end
    endtask


    initial begin

        $dumpfile("sliding_window_3x3.vcd");
        $dumpvars(0, sliding_window_3x3_tb);

        clk = 0;
        reset = 1;
        enable = 0;
        pixel_in = 0;

        #20;

        reset = 0;
        enable = 1;


        // ------------------------------------------------
        // 4x4 image
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


        #20;

        enable = 0;

        $display("");
        $display("--------------------------------");
        $display("SLIDING WINDOW TEST COMPLETE");
        $display("--------------------------------");

        $finish;

    end

endmodule
