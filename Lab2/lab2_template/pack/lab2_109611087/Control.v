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
    // R-Type 
    // I-Type 
    // S-Type 
    // B-Type 
    // U-Type 
    // J-Type 
    always @(*) begin
        memRead  = 0;       // 1: data is fetched from mem
        memtoReg = 2'b00;   // 00: data from ALU / 01: data from mem read / 10: data from PC + 4 / 11: data from imm
        ALUOp    = 2'b00;   // 00: direct addition / 01: subtraction / 10: R-type & I-type
        memWrite = 0;       // 1: write to data memory
        ALUSrc   = 0;       // 1: operand from imm
        regWrite = 0;       // 1: write to register
        PCSel    = 2'b00;   // 00: PC + 4 / 01: to branch target / 10: to jump target
        casez (opcode)
            7'b0?10111: begin // U lui, auipe
                regWrite = 1;
                if (opcode[5]) begin // lui
                    memtoReg = 2'b11;
                end else begin
                    ALUSrc = 1;
                end
            end
            7'b1101111: begin // J jal
                regWrite = 1;
                memtoReg = 2'b10;
                PCSel = 2'b10;
            end
            7'b1100111: begin // J jalr
                regWrite = 1;
                memtoReg = 2'b10;
                ALUSrc = 1;
                PCSel = 2'b10;
            end
            7'b0000011: begin // I lb, lh, lw, lbu, lhu
                regWrite = 1;
                memRead = 1;
                ALUSrc = 1;
                memtoReg = 2'b01;
            end
            7'b1100011: begin // B beq, bne, blt, bge, bltu, bgeu
                ALUOp = 2'b01;
                PCSel = 2'b01;
            end
            7'b0100011: begin // S sb, sh, sw
                ALUSrc = 1;
                memWrite = 1;
            end
            7'b0010011: begin
                // I addi, slti, xori, ori, andi
                // I slli, srli, srai
                regWrite = 1;
                ALUSrc = 1;
                ALUOp = 2'b10;
            end
            7'b0110011: begin // R add, sub, slt, slt, sltu, xor, srl, sra, or, and
                regWrite = 1;
                ALUOp = 2'b10;
            end
            7'b0001111: begin // I fence, fence.i
            end
            7'b1110011: begin
                // I ecall ebreak
                // I csrrw, csrrs, csrrc
                // I csrrwi, csrrsi, csrrci
            end
            default: begin 
            end
        endcase
    end


endmodule

