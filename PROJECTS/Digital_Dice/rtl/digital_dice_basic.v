module digital_dice_basic (
    input  wire clk,
    input  wire rst,
    input  wire roll,
    output wire valid,
    output reg [3:0] dice_value 
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
            dice_value <= dice_value + 1'b1; // advabce the values 
        end
    end
end

endmodule