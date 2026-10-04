module mac_unit #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input  wire signed [DATA_WIDTH-1:0] weight,
    input  wire signed [DATA_WIDTH-1:0] activation,

    input  wire signed [ACC_WIDTH-1:0] accumulator_in,

    output wire signed [ACC_WIDTH-1:0] accumulator_out
);

    wire signed [(2*DATA_WIDTH)-1:0] product;

    assign product = weight * activation;

    assign accumulator_out =
        accumulator_in + product;

endmodule
