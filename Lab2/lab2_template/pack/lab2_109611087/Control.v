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

    // memRead  1 : data is fetched from mem
    // memtoReg 00: data from ALU / 01: data from dmem / 10: data from PC + 4
    // ALUOp    00: direct addition / 01: subtraction / 10: R-type / 11: I-type
    // memWrite 1 : write to data memory
    // ALUSrc   1 : operand from imm
    // regWrite 1 : write to register
    // PCSel    00: PC + 4 / 01: PC + Imm << 1 / 10: PC = regs[rs1] + imm
    always @(*) begin
        case(opcode)
            7'b0000011: {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite, PCSel} = 10'b1_01_00_0_1_1_00; // I - lw
            7'b0010011: {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite, PCSel} = 10'b0_00_11_0_1_1_00; // I - addi, andi, ori, slti
            7'b0100011: {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite, PCSel} = 10'b0_00_00_1_1_0_00; // S - sw
            7'b0110011: {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite, PCSel} = 10'b0_00_10_0_0_1_00; // R - add, sub, and, or, slt
            7'b1100011: begin // beq, bne, blt, bge
                {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite} = {1'b0, 2'b00, 2'b01, 1'b0, 1'b0, 1'b0}; // branch taken (PCSel = 01)
                if ((funct3 == 3'b000 && BrEq)  || 
                    (funct3 == 3'b001 && !BrEq) ||
                    (funct3 == 3'b100 && BrLT)  ||
                    (funct3 == 3'b101 && !BrLT))  
                    PCSel = 2'b01; // branch taken (PCSel = 01)
                else
                    PCSel = 2'b00; // branch not taken (PCSel = 00)
            end
            7'b1100111: {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite, PCSel} = 10'b0_10_00_0_1_1_10; // I - jalr
            7'b1101111: {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite, PCSel} = 10'b0_10_00_0_0_1_01; // J - jal
            default:    {memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite, PCSel} = 10'bxxxxxxxxxx;
        endcase
        // $display("ALU: ALUctl = %h, A = %h, B = %h, Out = %h", ALUctl, A, B, ALUOut);
    end

endmodule
