`timescale 1ns/1ps

module lfsr_tb;
    reg clk, rst;
    wire [7:0] random_state;

    lfsr uut (
        .clk(clk),
        .rst(rst),
        .random_state(random_state)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;

        $monitor("Time=%0t | State=%h | Hex=%h",
                 $time, random_state, random_state);

        #2 rst = 1;
        #10 rst = 0;

        #200 $finish;
    end

endmodule