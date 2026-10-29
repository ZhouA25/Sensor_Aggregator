`include "clock_divider.v"

module transmitter #(
    parameter CLOCK_FREQ = 27_000_000,
    parameter BAUD = 115200

)(
    input clk,
    input RESET,
    output TX
);


wire new_clk;
wire TICK;
divider #(.CLOCK_FREQ(CLOCK_FREQ),.DESIRED_FREQ(BAUD))
div 
( .CLOCK(clk), 
.RESET(RESET), 
.out_clk(new_clk),
.TICK(TICK)
);

reg uart_out = 1;
localparam [1:0] START = 2'b00, DATA = 2'b01, DONE = 2'b11;
reg[1:0] state = START, next_state;
reg [2:0] counter = 0;

reg [7:0] data = 8'b10010101;

always @(*) begin
    case(state) 
        START: next_state = DATA;
        DATA: next_state = (counter == 3'b111) ? DONE : DATA;
        DONE: next_state = START;
        default: next_state = START;
    endcase
end
always @(posedge clk) begin
    if(RESET) begin
        uart_out <= 1;
        state <= START;
        counter <= 0;
    end else begin
        if(TICK) begin
            if(state == START) begin
                counter <= 0;
                uart_out <= 0;
            end 
            else if (state == DATA) begin
                counter <= counter + 1;
                uart_out <= data[counter];
            end
            else if (state == DONE) begin
                uart_out <= 1;
            end
            state <= next_state;
        end
    end
end
assign TX = uart_out;
endmodule
