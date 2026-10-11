`include "clock_divider.v"

module Agreggator(
    input clk,
    input RESET,
    input RXD,
    output reg[4:0] LEDS,
    output TXD
);


wire new_clk;
divider div 
( .CLOCK(clk), 
.RESET(RESET), 
.out_clk(new_clk));

always @(posedge new_clk) begin
    if(RESET) begin
        LEDS <= '1;
    end else begin
        LEDS <= LEDS + 1'b1;
    end
end

assign TXD = 1'b0;

endmodule
