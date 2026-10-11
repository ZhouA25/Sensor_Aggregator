module Agreggator(
    input clk,
    input RESET,
    input RXD,
    output reg[4:0] LEDS,
    output TXD
);



always @(posedge clk) begin
    if(RESET) begin
        LEDS <= '1;
    end else begin
        LEDS <= LEDS + 1'b1;
    end
end

assign TXD = 1'b0;

endmodule
