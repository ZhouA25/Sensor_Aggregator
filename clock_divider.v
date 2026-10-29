module divider #( 
    parameter CLOCK_FREQ = 27_000_000,
    parameter DESIRED_FREQ = 1
)(
    input CLOCK,
    input RESET,
    output out_clk,
    output TICK
);
    reg new_clk = 0;
    localparam BLINK_FREQ = 2*DESIRED_FREQ;
    localparam count_limit1 = CLOCK_FREQ/BLINK_FREQ - 1;
    localparam count_limit2 = CLOCK_FREQ/DESIRED_FREQ - 1;
    reg [31:0] counter1 = 0;
    reg[31:0] counter2 = 0;
    reg tick = 0;
    always@(posedge CLOCK) begin
        if(RESET) begin
            counter1 <= 0;
            new_clk <= 0;
        end else begin
            if(counter1 == count_limit1) begin
                new_clk <= new_clk + 1'b1;
                counter1 <= 0;
            end else begin
                counter1 <= counter1 + 1;
            end
        end
    end
    always @(posedge CLOCK) begin
        if(RESET) begin
            counter2 <= 0;
            tick <= 0;
        end else begin
            if(counter2 == count_limit2) begin
                tick <= 1;
                counter2 <= 0;
            end else begin
                tick <= 0;
                counter2 <= counter2 + 1;
            end
        end
    end

    assign out_clk = new_clk;
    assign TICK = tick;
endmodule
