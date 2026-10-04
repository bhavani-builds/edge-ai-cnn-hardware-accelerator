module cnn_inference_pipeline #(
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

    output wire signed [ACC_WIDTH-1:0] pooled_result,

    output wire window_valid,
    output wire pool_valid
);


    // ------------------------------------------------
    // CNN Convolution Pipeline
    // ------------------------------------------------

    cnn_convolution_pipeline #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .IMAGE_WIDTH(IMAGE_WIDTH)
    ) convolution_pipeline (

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
    // Max Pooling
    // ------------------------------------------------

    cnn_pooling_unit #(
        .DATA_WIDTH(ACC_WIDTH)
    ) pooling (

        .clk(clk),
        .reset(reset),
        .enable(enable),

        .data_in(relu_result),
        .data_valid(window_valid),

        .pool_out(pooled_result),
        .pool_valid(pool_valid)
    );


endmodule
