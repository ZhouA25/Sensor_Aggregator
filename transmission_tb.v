`timescale 1ns / 1ps
module transmission_tb();
    reg CLOCK = 0;
    reg RESET = 1'b1;
    wire new_clk;
    wire TX;
    integer errors = 0;

    localparam CLOCK_FREQ = 30;
    localparam BAUD = 5;

    transmitter #(.CLOCK_FREQ(CLOCK_FREQ), .BAUD(BAUD)) t(
        .clk(CLOCK),
        .RESET(RESET),
        .TX(TX)
    );
    always #5 CLOCK = ~CLOCK;
    localparam bit_period = CLOCK_FREQ/BAUD;

    task automatic receive_byte;
        output [7:0] rx_byte;
        begin
            @(negedge TX);
            repeat(bit_period/2) @(posedge CLOCK);
            if(!TX) begin
            for (integer i = 0; i <= 7; i = i + 1) begin
                repeat(bit_period) @(posedge CLOCK);
                rx_byte[i] = TX;
            end
            repeat(bit_period) @(posedge CLOCK);
            if(!TX) begin
                errors = errors + 1;
                $display("Framing Error at time: %0d", $time);
            end
            end else begin
                errors = errors + 1;
                $display("Mid-Start Bit Flip Error at time: %0d", $time);
            end
        end
    endtask


    reg[7:0] data;
    localparam expected = 8'b10010101;
    initial begin
        $dumpfile("build/transmission_tb.vcd");
        $dumpvars(0, transmission_tb);

        repeat(3) @(posedge CLOCK);
        RESET <= 0;
        receive_byte(data);
        if (data !== expected) begin
            $display("ERROR at %t: got %h, expected %h", $time, data, 8'h4A);
            errors = errors + 1;
        end
        repeat(4) begin
            receive_byte(data);
            if (data !== expected) begin
                $display("ERROR at %t: got %h, expected %h", $time, data, 8'h4A);
                errors = errors + 1;
            end
        end
        if (errors == 0) $display("PASS");
        else $display("FAIL, %0d errors", errors);
        $finish;
    end


    initial begin
        #100000;
        $display("TIMEOUT");
        $finish;
    end
endmodule

