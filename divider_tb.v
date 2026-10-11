`include "clock_divider.v"


module divider_tb();
    reg CLOCK = 0;
    reg RESET = 1'b1;
    wire new_clk;

    
    divider #(
        .CLOCK_FREQ(20),
        .DESIRED_FREQ(5)
    ) d 
    (
        .CLOCK(CLOCK),
        .RESET(RESET),
        .out_clk(new_clk)
    );

endmodule
