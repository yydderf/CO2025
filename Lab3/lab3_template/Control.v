module Control (
    input [6:0] opcode,
    input [2:0] funct3,
    input BrEq, BrLT,
    output reg [1:0] M,
    output reg [2:0] WB,
    output reg [2:0] EX,
    output reg [1:0] PCSel
);

    // memRead  1 : data is fetched from mem
    // memtoReg 00: data from ALU / 01: data from dmem / 10: data from PC + 4
    // ALUOp    00: direct addition / 01: subtraction / 10: R-type / 11: I-type
    // memWrite 1 : write to data memory
    // ALUSrc   1 : operand from imm
    // regWrite 1 : write to register
    // PCSel    00: PC + 4 / 01: PC + Imm << 1 / 10: PC = regs[rs1] + imm
    // [2] WB = regWrite, [1:0] WB = memtoReg[1:0]
    // [1] M  = memRead, [0] M = memWrite
    // [2] EX = ALUSrc, [1:0] EX = ALUOp
    always @(*) begin
        case(opcode)
            7'b0000011: {WB, M, EX, PCSel} = 10'b101_10_100_00; // I - lw
            7'b0010011: {WB, M, EX, PCSel} = 10'b100_00_111_00; // I - addi, andi, ori, slti
            7'b0100011: {WB, M, EX, PCSel} = 10'b000_01_100_00; // S - sw
            7'b0110011: {WB, M, EX, PCSel} = 10'b100_00_010_00; // R - add, sub, and, or, slt
            7'b1100011: begin // beq, bne, blt, bge
                {WB, M, EX} = 8'b000_00_001; // branch taken (PCSel = 01)
                if ((funct3 == 3'b000 && BrEq)  || 
                    (funct3 == 3'b001 && !BrEq) ||
                    (funct3 == 3'b100 && BrLT)  ||
                    (funct3 == 3'b101 && !BrLT))  
                    PCSel = 2'b01; // branch taken (PCSel = 01)
                else
                    PCSel = 2'b00; // branch not taken (PCSel = 00)
            end
            7'b1100111: {WB, M, EX, PCSel} = 10'b110_00_100_10; // I - jalr
            7'b1101111: {WB, M, EX, PCSel} = 10'b110_00_000_01; // J - jal
            default:    {WB, M, EX, PCSel} = 10'bxxx_xx_xxx_xx;
        endcase
        // $display("ALU: ALUctl = %h, A = %h, B = %h, Out = %h", ALUctl, A, B, ALUOut);
    end

endmodule
