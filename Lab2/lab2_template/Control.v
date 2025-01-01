module Control (
    input [6:0] opcode,
    input [2:0] funct3,
    input BrEq, BrLT,
    output reg memRead,
    output reg [1:0] memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite,
    output reg [1:0] PCSel
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal


endmodule

