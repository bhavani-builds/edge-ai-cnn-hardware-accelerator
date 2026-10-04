module cnn_controller (
    input wire clk,
    input wire reset,

    input wire start,

    input wire conv_valid,

    output reg conv_start,
    output reg relu_enable,
    output reg pool_enable,

    output reg busy,
    output reg done
);

    localparam IDLE = 3'd0;
    localparam CONV = 3'd1;
    localparam RELU = 3'd2;
    localparam POOL = 3'd3;
    localparam DONE = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    always @(posedge clk) begin

        if (reset)
            state <= IDLE;
        else
            state <= next_state;

    end

    always @(*) begin

        next_state = state;

        case (state)

            IDLE: begin
                if (start)
                    next_state = CONV;
            end

            CONV: begin
                if (conv_valid)
                    next_state = RELU;
            end

            RELU: begin
                next_state = POOL;
            end

            POOL: begin
                next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end
