module mac_array #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter NUM_MACS   = 9
)(
    input wire signed [DATA_WIDTH-1:0] weights [0:NUM_MACS-1],
    input wire signed [DATA_WIDTH-1:0] activations [0:NUM_MACS-1],

    input wire signed [ACC_WIDTH-1:0] accumulator_in,

    output reg signed [ACC_WIDTH-1:0] accumulator_out
);

    integer i;

    reg signed [ACC_WIDTH-1:0] partial_sum;

    always @(*) begin

        partial_sum = accumulator_in;

        for (i = 0; i < NUM_MACS; i = i + 1) begin

            partial_sum =
                partial_sum +
                (weights[i] * activations[i]);

        end

        accumulator_out = partial_sum;

    end

endmodule
