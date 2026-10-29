`timescale 1ns / 1ps

module divider_tb();
    reg CLOCK = 0;
    reg RESET = 1'b1;
    wire new_clk;

    localparam CLOCK_FREQ = 20;
    localparam DESIRED_FREQ = 5;
    integer errors = 0;
    divider #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .DESIRED_FREQ(DESIRED_FREQ)
    ) d 
    (
        .CLOCK(CLOCK),
        .RESET(RESET),
        .out_clk(new_clk)
    );

    always #5 CLOCK = ~CLOCK;
    localparam BLINK_FREQ = 2*DESIRED_FREQ;
    localparam count_limit = CLOCK_FREQ/BLINK_FREQ - 1;

    initial begin
        $dumpfile("build/divider_tb.vcd");
        $dumpvars(0, divider_tb);

        repeat(3) @(posedge CLOCK);
        RESET <= 0;
        repeat(10) @(posedge CLOCK);
        RESET <= 1;
        repeat(1) @(posedge CLOCK);
        RESET <= 0;
        repeat(20) @(posedge CLOCK);
        if (errors == 0) $display("PASS");
        else $display("FAIL, %0d errors", errors);
        $finish;
    end
    reg [31:0] counter = 0;
    reg last_new_clk = 0;
    reg seen_first = 0;
    always @(posedge CLOCK) begin
        if(RESET) begin
            seen_first = 0;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if(new_clk != last_new_clk && seen_first) begin
                if(counter != count_limit) begin
                    $display("ERROR at %t: got %0d, expected %0d", $time, counter, count_limit);
                    errors = errors + 1;
                end
                counter <= 0;
            end
            if(!seen_first) begin
                seen_first = 1;
                counter <= 0;
            end
        end
        last_new_clk = new_clk;
    end

    initial begin
        #100000;
        $display("TIMEOUT");
        $finish;
    end

endmodule
