module PC (
    input clk,
    input rst,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

    // TODO: implement your program counter here
    always @(negedge clk, negedge rst) begin
        // rst == 0 to reset
        if (~rst)
            pc_o <= 32'd0;
        else
            pc_o <= pc_i;
    end
    

endmodule




