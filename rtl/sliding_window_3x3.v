module sliding_window_3x3 #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire signed [DATA_WIDTH-1:0] pixel_in,

    output reg signed [DATA_WIDTH-1:0] window0,
    output reg signed [DATA_WIDTH-1:0] window1,
    output reg signed [DATA_WIDTH-1:0] window2,

    output reg signed [DATA_WIDTH-1:0] window3,
    output reg signed [DATA_WIDTH-1:0] window4,
    output reg signed [DATA_WIDTH-1:0] window5,

    output reg signed [DATA_WIDTH-1:0] window6,
    output reg signed [DATA_WIDTH-1:0] window7,
    output reg signed [DATA_WIDTH-1:0] window8,

    output reg valid
);

    // Three rows of shift registers
    reg signed [DATA_WIDTH-1:0] row0_0;
    reg signed [DATA_WIDTH-1:0] row0_1;
    reg signed [DATA_WIDTH-1:0] row0_2;

    reg signed [DATA_WIDTH-1:0] row1_0;
    reg signed [DATA_WIDTH-1:0] row1_1;
    reg signed [DATA_WIDTH-1:0] row1_2;

    reg signed [DATA_WIDTH-1:0] row2_0;
    reg signed [DATA_WIDTH-1:0] row2_1;
    reg signed [DATA_WIDTH-1:0] row2_2;


    always @(posedge clk) begin

        if (reset) begin

            row0_0 <= 0;
            row0_1 <= 0;
            row0_2 <= 0;

            row1_0 <= 0;
            row1_1 <= 0;
            row1_2 <= 0;

            row2_0 <= 0;
            row2_1 <= 0;
            row2_2 <= 0;

            window0 <= 0;
            window1 <= 0;
            window2 <= 0;

            window3 <= 0;
            window4 <= 0;
            window5 <= 0;

            window6 <= 0;
            window7 <= 0;
            window8 <= 0;

            valid <= 1'b0;

        end

        else if (enable) begin

            // Shift pixels horizontally
            row0_2 <= row0_1;
            row0_1 <= row0_0;
            row0_0 <= pixel_in;

            row1_2 <= row1_1;
            row1_1 <= row1_0;
            row1_0 <= row0_2;

            row2_2 <= row2_1;
            row2_1 <= row2_0;
            row2_0 <= row1_2;


            // Generate 3x3 window
            window0 <= row2_2;
            window1 <= row2_1;
            window2 <= row2_0;

            window3 <= row1_2;
            window4 <= row1_1;
            window5 <= row1_0;

            window6 <= row0_2;
            window7 <= row0_1;
            window8 <= row0_0;

            valid <= 1'b1;

        end

        else begin
            valid <= 1'b0;
        end

    end

endmodule
