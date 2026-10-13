module digital_dice (
    input  wire clk,
    input  wire rst,
    input  wire roll,
    output wire valid,
    output reg [3:0] dice_value
);
wire [7:0] random_state;

// instantiating the lfsr
lfsr ring (
    .clk(clk),
    .rst(rst),
    .random_state(random_state)
);

assign valid = (dice_value >= 4'd1) && (dice_value <= 4'd6); // validity check

always @(posedge clk or posedge rst) begin

    if(rst) begin
        dice_value <= 4'd1; // initialise dice to 1 on reset
    end

    else if (roll) begin // check the roll

        if (dice_value >= 4'd6 || dice_value == 4'd0) begin // checking boundary conditions
            dice_value <= 4'd1;
        end

        else begin
            dice_value <= (random_state % 6) + 1; // generate the pseudo-random sequence
        end
    end
end

endmodule