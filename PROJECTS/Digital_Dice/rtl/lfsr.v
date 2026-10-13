module lfsr (
    input wire clk,
    input wire rst,
    output reg [7:0] random_state
);

wire feedback;
assign feedback = random_state[7] ^ random_state[5] ^ random_state[4] ^ random_state[3];

always @ (posedge clk or posedge rst) begin

    if (rst) begin
        random_state <= 8'hA5;
    end
    else begin
        random_state <= {random_state[6:0], feedback}; 
    end
    
end

endmodule