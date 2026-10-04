`timescale 1ns/1ps

module mac_array_tb;

    localparam DATA_WIDTH = 8;
    localparam ACC_WIDTH  = 32;
    localparam NUM_MACS   = 9;

    reg signed [DATA_WIDTH-1:0] weights [0:NUM_MACS-1];
    reg signed [DATA_WIDTH-1:0] activations [0:NUM_MACS-1];

    reg signed [ACC_WIDTH-1:0] accumulator_in;

    wire signed [ACC_WIDTH-1:0] accumulator_out;

    integer i;
    integer expected;
    integer errors;

    mac_array #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .NUM_MACS(NUM_MACS)
    ) dut (
        .weights(weights),
        .activations(activations),
        .accumulator_in(accumulator_in),
        .accumulator_out(accumulator_out)
    );

    initial begin

        errors = 0;
        accumulator_in = 0;

        // --------------------------------------------------------
        // Test vector
        // --------------------------------------------------------

        weights[0] = 1;
        weights[1] = 0;
        weights[2] = -1;

        weights[3] = 1;
        weights[4] = 0;
        weights[5] = -1;

        weights[6] = 1;
        weights[7] = 0;
        weights[8] = -1;

        activations[0] = 1;
        activations[1] = 2;
        activations[2] = 3;

        activations[3] = 4;
        activations[4] = 5;
        activations[5] = 6;

        activations[6] = 7;
        activations[7] = 8;
        activations[8] = 9;

        #10;

        // Expected:
        //
        // 1×1 + 2×0 + 3×(-1)
        // + 4×1 + 5×0 + 6×(-1)
        // + 7×1 + 8×0 + 9×(-1)
        //
        // = -6

        expected = -6;

        $display("");
        $display("======================================");
        $display("INT8 MAC ARRAY VERIFICATION");
        $display("======================================");

        $display(
            "Expected result = %0d",
            expected
        );

        $display(
            "Hardware result = %0d",
            accumulator_out
        );

        if (accumulator_out !== expected) begin

            $display("FAIL: MAC array result mismatch");

            errors = errors + 1;

        end

        else begin

            $display("PASS: MAC array result correct");

        end

        // --------------------------------------------------------
        // Second test
        // --------------------------------------------------------

        accumulator_in = 10;

        #10;

        expected = 4;

        $display("");
        $display("Test 2:");
        $display("Accumulator input = 10");
        $display("Expected result    = %0d", expected);
        $display("Hardware result    = %0d", accumulator_out);

        if (accumulator_out !== expected) begin

            $display("FAIL: Accumulator test failed");

            errors = errors + 1;

        end

        else begin

            $display("PASS: Accumulator test passed");

        end

        // --------------------------------------------------------
        // Final result
        // --------------------------------------------------------

        $display("");

        if (errors == 0) begin

            $display("======================================");
            $display("ALL MAC ARRAY TESTS PASSED");
            $display("======================================");

        end

        else begin

            $display("======================================");
            $display(
                "MAC ARRAY TEST FAILED - ERRORS = %0d",
                errors
            );
            $display("======================================");

            $fatal(1);

        end

        $finish;

    end

endmodule
