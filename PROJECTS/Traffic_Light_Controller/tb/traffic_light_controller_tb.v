`timescale 1ns / 1ps

module traffic_light_controller_tb;

localparam RED_CYCLES    = 5;
localparam GREEN_CYCLES  = 5;
localparam YELLOW_CYCLES = 2;

    reg clk; reg rst;
    wire red; wire yellow; wire green;
    integer pass_count; integer light_count;

    traffic_light_controller #(
        .RED_CYCLES(RED_CYCLES),
        .GREEN_CYCLES(GREEN_CYCLES),
        .YELLOW_CYCLES(YELLOW_CYCLES)
    ) dut (
        .clk(clk),
        .rst(rst),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // clock with 10ns period 
    initial clk = 0;
    always #5 clk = ~clk;

    // Continuous one-hot safety monitor
    always @(negedge clk) begin
        if (rst === 1'b0) begin
            if (({red, yellow, green} !== 3'b001) &&
                ({red, yellow, green} !== 3'b010) &&
                ({red, yellow, green} !== 3'b100))
                $fatal(1, "SAFETY FAIL: Invalid light combination %b%b%b at time %0t",
                    red, yellow, green, $time);
        end
    end

    // Waveform output for GTKWave
    initial begin
        $dumpfile("tb/traffic_light_controller.vcd");
        $dumpvars(0, traffic_light_controller_tb);
    end

    // Check expected lights and one-hot safety
    task check_lights;
        input expected_red;
        input expected_yellow;
        input expected_green;
        input [8*24-1:0] test_name;
        begin
            light_count = red + yellow + green;

            if ((red !== expected_red) || 
            (yellow !== expected_yellow) || 
            (green !== expected_green)) begin
                $display("FAIL: %0s at time %0t", test_name, $time);
                $display("Expected RYG = %b%b%b, Got = %b%b%b",
                         expected_red, expected_yellow, expected_green,
                         red, yellow, green);
                $fatal(1, "Output mismatch");
            end

            if (light_count != 1) begin
                $fatal(1, "Safety violation: not exactly one light is ON");
            end

            pass_count = pass_count + 1;
            $display("PASS: %0s at time %0t", test_name, $time);
        end
    endtask

    // Main test sequence
    initial begin
        $timeformat(-9, 0, " ns", 10);
        rst = 0; pass_count = 0;

        // Test 1: Apply synchronous reset
        @(negedge clk);
        rst = 1;

        @(posedge clk);
        #1;
        check_lights(1, 0, 0, "Reset selects RED");

        @(negedge clk);
        rst = 0;

        // Test 2: RED duration and RED -> GREEN
        repeat (RED_CYCLES - 1) begin
            @(posedge clk);
            #1;
            check_lights(1, 0, 0, "RED phase");
        end

        @(posedge clk);
        #1;
        check_lights(0, 0, 1, "RED to GREEN");

        // Test 3: GREEN duration and GREEN -> YELLOW
        repeat (GREEN_CYCLES - 1) begin
            @(posedge clk);
            #1;
            check_lights(0, 0, 1, "GREEN phase");
        end

        @(posedge clk);
        #1;
        check_lights(0, 1, 0, "GREEN to YELLOW");

        // Test 4: YELLOW duration and YELLOW -> RED
        repeat (YELLOW_CYCLES - 1) begin
            @(posedge clk);
            #1;
            check_lights(0, 1, 0, "YELLOW phase");
        end

        @(posedge clk);
        #1;
        check_lights(1, 0, 0, "YELLOW to RED");

        // Test 5: Verify the sequence repeats
        repeat (RED_CYCLES - 1) begin
            @(posedge clk);
            #1;
            check_lights(1, 0, 0, "Second RED phase");
        end

        @(posedge clk);
        #1;
        check_lights(0, 0, 1, "Second RED to GREEN");

        // Test 6: Reset while GREEN is active
        @(negedge clk);
        rst = 1;

        @(posedge clk);
        #1;
        check_lights(1, 0, 0, "Reset during GREEN");

        if(dut.phase_count !==0) 
        $fatal(1, "Fail : phase count was not cleared by reset during green");

        @(negedge clk);
        rst = 0;

        // Advance through RED and GREEN to reach YELLOW again
        repeat (RED_CYCLES - 1) begin
            @(posedge clk);
            #1;
            check_lights(1, 0, 0, "RED after GREEN reset");
        end

        @(posedge clk);
        #1;
        check_lights(0, 0, 1, "GREEN after reset");

        repeat (GREEN_CYCLES - 1) begin
            @(posedge clk);
            #1;
            check_lights(0, 0, 1, "GREEN phase before YELLOW reset");
        end

        @(posedge clk);
        #1;
        check_lights(0, 1, 0, "YELLOW before reset");

        // Test 7: Reset while YELLOW is active
        @(negedge clk);
        rst = 1;

        @(posedge clk);
        #1;
        check_lights(1, 0, 0, "Reset during YELLOW");

        if(dut.phase_count !==0) 
        $fatal(1, "Fail : phase count was not cleared by reset during yellow");

        @(negedge clk);
        rst = 0;

        $display("ALL TESTS PASSED");
        $display("Total successful checks: %0d", pass_count);

        $finish;
    end

endmodule