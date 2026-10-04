module cnn_accelerator #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input wire clk,
    input wire reset,
    input wire start,

    // 3x3 input feature window
    input wire signed [DATA_WIDTH-1:0] pixel0,
    input wire signed [DATA_WIDTH-1:0] pixel1,
    input wire signed [DATA_WIDTH-1:0] pixel2,
    input wire signed [DATA_WIDTH-1:0] pixel3,
    input wire signed [DATA_WIDTH-1:0] pixel4,
    input wire signed [DATA_WIDTH-1:0] pixel5,
    input wire signed [DATA_WIDTH-1:0] pixel6,
    input wire signed [DATA_WIDTH-1:0] pixel7,
    input wire signed [DATA_WIDTH-1:0] pixel8,

    // 3x3 kernel weights
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

    output wire busy,
    output wire done
);

    // ------------------------------------------------------------
    // Control signals
    // ------------------------------------------------------------

    wire conv_start;
    wire relu_enable;
    wire pool_enable;
    wire conv_valid;

    // ------------------------------------------------------------
    // Convolution Engine
    // ------------------------------------------------------------

    conv3x3_engine #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) convolution (
        .clk(clk),
        .reset(reset),

        .start(conv_start),

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

        .result(convolution_result),
        .valid(conv_valid)
    );

    // ------------------------------------------------------------
    // ReLU
    // ------------------------------------------------------------

    relu #(
        .DATA_WIDTH(ACC_WIDTH)
    ) activation (
        .data_in(convolution_result),
        .data_out(relu_result)
    );

    // ------------------------------------------------------------
    // Controller
    // ------------------------------------------------------------

    cnn_controller controller (
        .clk(clk),
        .reset(reset),
        .start(start),

        .conv_valid(conv_valid),

        .conv_start(conv_start),
        .relu_enable(relu_enable),
        .pool_enable(pool_enable),

        .busy(busy),
        .done(done)
    );

endmodule
