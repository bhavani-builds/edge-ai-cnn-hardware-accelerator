module max_pool2x2 #(
    parameter DATA_WIDTH = 32
)(
    input wire signed [DATA_WIDTH-1:0] data0,
    input wire signed [DATA_WIDTH-1:0] data1,
    input wire signed [DATA_WIDTH-1:0] data2,
    input wire signed [DATA_WIDTH-1:0] data3,

    output reg signed [DATA_WIDTH-1:0] max_value
);

    reg signed [DATA_WIDTH-1:0] max01;
    reg signed [DATA_WIDTH-1:0] max23;

    always @(*) begin

        // Compare first pair
        if (data0 > data1)
            max01 = data0;
        else
            max01 = data1;

        // Compare second pair
        if (data2 > data3)
            max23 = data2;
        else
            max23 = data3;

        // Final comparison
        if (max01 > max23)
            max_value = max01;
        else
            max_value = max23;

    end

endmodule
