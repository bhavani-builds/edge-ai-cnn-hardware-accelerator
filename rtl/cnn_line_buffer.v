module cnn_line_buffer #(
    parameter DATA_WIDTH = 8,
    parameter IMAGE_WIDTH = 4
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

    reg signed [DATA_WIDTH-1:0] line1 [0:IMAGE_WIDTH-1];
    reg signed [DATA_WIDTH-1:0] line2 [0:IMAGE_WIDTH-1];

    reg [15:0] column_count;
    reg [15:0] row_count;

    reg signed [DATA_WIDTH-1:0] pixel_row1;
    reg signed [DATA_WIDTH-1:0] pixel_row2;

    integer i;


    always @(posedge clk) begin

        if (reset) begin

            column_count <= 0;
            row_count <= 0;

            pixel_row1 <= 0;
            pixel_row2 <= 0;

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

            for (i = 0; i < IMAGE_WIDTH; i = i + 1) begin
                line1[i] <= 0;
                line2[i] <= 0;
            end

        end

        else if (enable) begin

            /*
             * Read pixels from previous two rows.
             */
            pixel_row1 <= line1[column_count];
            pixel_row2 <= line2[column_count];


            /*
             * Shift the line buffers.
             */
            line2[column_count] <= line1[column_count];
            line1[column_count] <= pixel_in;


            /*
             * Shift horizontal window.
             */
            window2 <= window1;
            window1 <= window0;
            window0 <= pixel_row2;

            window5 <= window4;
            window4 <= window3;
            window3 <= pixel_row1;

            window8 <= window7;
            window7 <= window6;
            window6 <= pixel_in;


            /*
             * A 3x3 window becomes valid
             * after at least two rows and
             * two columns are available.
             */
            if ((row_count >= 2) &&
                (column_count >= 2))
                valid <= 1'b1;
            else
                valid <= 1'b0;


            /*
             * Move to next column.
             */
            if (column_count == IMAGE_WIDTH-1) begin

                column_count <= 0;
                row_count <= row_count + 1;

            end
            else begin

                column_count <= column_count + 1;

            end

        end

        else begin
            valid <= 1'b0;
        end

    end

endmodule
