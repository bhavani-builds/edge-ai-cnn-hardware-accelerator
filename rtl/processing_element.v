module processing_element #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire signed [DATA_WIDTH-1:0] activation_in,
    input wire signed [DATA_WIDTH-1:0] weight_in,
    input wire signed [ACC_WIDTH-1:0]  acc_in,

    output reg signed [DATA_WIDTH-1:0] activation_out,
    output reg signed [DATA_WIDTH-1:0] weight_out,
    output reg signed [ACC_WIDTH-1:0]  acc_out
);

    always @(posedge clk) begin

        if (reset) begin
            activation_out <= 0;
            weight_out     <= 0;
            acc_out        <= 0;
        end

        else if (enable) begin

            // Forward data to the next PE
            activation_out <= activation_in;
            weight_out     <= weight_in;

            // Multiply-accumulate
            acc_out <= acc_in +
                       (activation_in * weight_in);

        end

    end

endmodule
