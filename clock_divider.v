module divider #( 
    parameter CLOCK_FREQ = 27_000_000,
    parameter DESIRED_FREQ = 1
)(
    input CLOCK,
    input RESET,
    output clk
);
    reg new_clk = 0;
    localparam BLINK_FREQ = 2*DESIRED_FREQ;
    reg [31:0] count_limit = CLOCK_FREQ/BLINK_FREQ - 1;
    reg [31:0] counter = 0;

    always@(posedge CLOCK) begin
        if(RESET) begin
            counter <= 0;
        end else begin
            if(counter == count_limit) begin
                new_clk <= new_clk + 1'b1;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    assign clk = new_clk;
endmodule
