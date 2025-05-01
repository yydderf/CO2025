module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst,
    output reg signed [31:0] imm
);
    // Generate immediate value based on instruction type determined by the opcode (inst[6:0])
    always @(*) begin
        case (inst[6:0])
            7'b1100111,  // JALR
            7'b0010011,
            7'b0000011: imm = {{20{inst[31]}}, inst[31:20]}; // I-type
            7'b0100011: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            7'b1100011: imm = {{20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]};
            7'b0110111,
            7'b0010111: imm = {inst[31:12], 12'b0}; // lui, auipc
            7'b1101111: imm = {{12{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21]}; // J
            default:    imm = 32'b0;
        endcase
    end

endmodule


