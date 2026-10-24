module traffic_light_controller #(
    parameter RED_CYCLES    = 5,
    parameter GREEN_CYCLES  = 5,
    parameter YELLOW_CYCLES = 2
)(
    input  wire clk, input  wire rst,
    output reg red, output reg yellow, output reg green
);

    // State encoding : Binary encoding
    localparam RED_STATE    = 2'b00;
    localparam GREEN_STATE  = 2'b01;
    localparam YELLOW_STATE = 2'b10;

    reg [1:0] state; reg [31:0] phase_count;

    // State transitions and timing
    always @(posedge clk) begin
        if (rst) begin
            state       <= RED_STATE;
            phase_count <= 0;
        end 
        else begin
            case (state)

                RED_STATE: begin
                    if (phase_count >= RED_CYCLES - 1) begin
                        state       <= GREEN_STATE;
                        phase_count <= 0;
                    end 
                    else begin
                        phase_count <= phase_count + 1;
                    end
                end

                GREEN_STATE: begin
                    if (phase_count >= GREEN_CYCLES - 1) begin
                        state       <= YELLOW_STATE;
                        phase_count <= 0;
                    end 
                    else begin
                        phase_count <= phase_count + 1;
                    end
                end

                YELLOW_STATE: begin
                    if (phase_count >= YELLOW_CYCLES - 1) begin
                        state       <= RED_STATE;
                        phase_count <= 0;
                    end 
                    else begin
                        phase_count <= phase_count + 1;
                    end
                end

                default: begin
                    state       <= RED_STATE;
                    phase_count <= 0;
                end

            endcase
        end
    end

    // Decoding the current state
    always @(*) begin
        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;

        case (state)
            RED_STATE:    red    = 1'b1;
            GREEN_STATE:  green  = 1'b1;
            YELLOW_STATE: yellow = 1'b1;

            default: red = 1'b1;
        endcase
    end

endmodule
