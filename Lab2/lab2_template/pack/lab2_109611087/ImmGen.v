module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst,
    output reg signed [31:0] imm
);
    // Generate immediate value based on instruction type determined by the opcode (inst[6:0])
    always @(*) begin
        case (inst[6:0])
            // U-Type: immediate is inst[31:12] and then 12 zeros (for LUI and AUIPC)
            7'b0110111,  // LUI
            7'b0010111:  // AUIPC
                imm = {inst[31:12], 12'b0};
            // J-Type: immediate is {inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}
            7'b1101111:
                imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            // I-Type: immediate is bits [31:20]
            7'b1100111,  // JALR
            7'b0000011,  // Load instructions (e.g., LB, LH, LW, etc.)
            7'b0010011,  // Immediate arithmetic (e.g., ADDI, SLTI, etc.)
            7'b1110011:  // Environment or system instructions (if applicable)
                imm = {{20{inst[31]}}, inst[31:20]};
            // S-Type: immediate is concatenation of inst[31:25] and inst[11:7]
            7'b0100011: 
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            // B-Type: immediate is {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0}
            7'b1100011: 
                imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
                
            default:
                imm = 32'b0;
        endcase
    end

endmodule

