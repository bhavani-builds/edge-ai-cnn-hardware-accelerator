module cnn_convolution_pipeline #(
    parameter DATA_WIDTH  = 8,
    parameter ACC_WIDTH   = 32,
    parameter IMAGE_WIDTH = 4
)(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire signed [DATA_WIDTH-1:0] pixel_in,

    input wire signed [DATA_WIDTH-1:0] weight0,
    input wire signed [DATA_WIDTH-1:0] weight1,
    input wire signed [DATA_WIDTH-1:0] weight2,

    input wire signed [DATA_WIDTH-1:0] weight3,
    input wire signed [DATA_WIDTH-1:0] weight4,
    input wire signed [DATA_WIDTH-1:0] weight5,

    input wire signed [DATA_WIDTH-1:0] weight6,
    input wire signed [DATA_WIDTH-1:0] weight7,
    input wire signed [DATA_WIDTH-1:0] weight8,

    output wire signed [ACC_WIDTH-1:0] convolution_result,
    output wire signed [ACC_WIDTH-1:0] relu_result,

    output wire window_valid
);


    // ------------------------------------------------
    // 3x3 line buffer
    // ------------------------------------------------

    wire signed [DATA_WIDTH-1:0] window0;
    wire signed [DATA_WIDTH-1:0] window1;
    wire signed [DATA_WIDTH-1:0] window2;

    wire signed [DATA_WIDTH-1:0] window3;
    wire signed [DATA_WIDTH-1:0] window4;
    wire signed [DATA_WIDTH-1:0] window5;

    wire signed [DATA_WIDTH-1:0] window6;
    wire signed [DATA_WIDTH-1:0] window7;
    wire signed [DATA_WIDTH-1:0] window8;


    cnn_line_buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .IMAGE_WIDTH(IMAGE_WIDTH)
    ) line_buffer (
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

        .valid(window_valid)
    );


    // ------------------------------------------------
    // Convolution engine
    // ------------------------------------------------

    reg convolution_start;

    wire convolution_valid;


    always @(posedge clk) begin

        if (reset)
            convolution_start <= 1'b0;

        else
            convolution_start <= window_valid;

    end


    conv3x3_engine #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) convolution (
        .clk(clk),
        .reset(reset),

        .start(convolution_start),

        .pixel0(window0),
        .pixel1(window1),
        .pixel2(window2),

        .pixel3(window3),
        .pixel4(window4),
        .pixel5(window5),

        .pixel6(window6),
        .pixel7(window7),
        .pixel8(window8),

        .weight0(weight0),
        .weight1(weight1),
        .weight2(weight2),

        .weight3(weight3),
        .weight4(weight4),
        .weight5(weight5),

        .weight6(weight6),
        .weight7(weight7),
        .weight8(weight8),

        .result(convolution_result),
        .valid(convolution_valid)
    );


    // ------------------------------------------------
    // ReLU
    // ------------------------------------------------

    relu #(
        .DATA_WIDTH(ACC_WIDTH)
    ) activation (
        .data_in(convolution_result),
        .data_out(relu_result)
    );


endmodule
