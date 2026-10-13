`timescale 1ns/1ps
module digital_dice_tb;
    reg clk; reg rst; reg roll;
    wire valid;
    wire [3:0] dice_value;
    reg [3:0] held_value ;

    digital_dice uut (
        .clk(clk),
        .rst(rst),
        .roll(roll),
        .valid(valid),
        .dice_value(dice_value)
    );
    always #5 clk = ~clk;

    initial begin
        $timeformat(-9, 2, "ns", 10);

        // Generate waveform file
        $dumpfile("digital_dice.vcd");
        $dumpvars(0, digital_dice_tb);

        clk = 0; rst = 0; roll = 0; held_value = 0;
        $monitor("Time = %t | rst = %b | roll = %b | dice = %d | held = %d | valid = %b",
                 $time, rst, roll, dice_value, held_value, valid);

        // Test 1: Apply reset
        #2 rst = 1; #10;

        if (dice_value == 4'd1 && valid == 1'b1)
            $display("PASS: Reset test");
        else
            $display("FAIL: Reset test");

        rst = 0;

        // Test 2: Roll the dice for several clock cycles
        #8 roll = 1;
        #100 roll = 0;

        if (valid == 1'b1 &&
            dice_value >= 4'd1 &&
            dice_value <= 4'd6)
            $display("PASS: Dice range test");
        else
            $display("FAIL: Dice range test");

        // Test 3: Verify that the result holds
        held_value = dice_value;
        #30;

        if (dice_value == held_value)
            $display("PASS: Hold test");
        else
            $display("FAIL: Hold test");

        // Test 4: Roll again
        roll = 1;
        #50 roll = 0;

        if (valid == 1'b1 &&
            dice_value >= 4'd1 &&
            dice_value <= 4'd6)
            $display("PASS: Second roll range test");
        else
            $display("FAIL: Second roll range test");

        // Test 5: Reset while the dice is holding a result
        #10 rst = 1;
        #2;

        if (dice_value == 4'd1 && valid == 1'b1)
            $display("PASS: Reset during hold test");
        else
            $display("FAIL: Reset during hold test");

        rst = 0;

        #50 $finish;
    end
endmodule