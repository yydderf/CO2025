module ALU (
    input [3:0] ALUctl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut,
    output zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire
    // output zero is for determining taking branch or not (or you can change the design as you wish)

    // TODO: implement your ALU here
    // Hint: you can use operator to implement
    // add, addi, sub, and, andi, or, ori, slt, slti
    // Lw
    // Sw
    // beq, bne, blt, bge
    // jal, jalr

    always @(*) begin
        case(ALUctl)
            0: ALUOut = A & B;    // and
            1: ALUOut = A | B;    // or
            2: ALUOut = A + B;    // add
            3: ALUOut = A << B;   // sll
            4: ALUOut = $signed(A) < $signed(B) ? 1 : 0;  // slt
            5: ALUOut = A < B ? 1 : 0;    // sltu
            6: ALUOut = A - B;    // sub
            7: ALUOut = A ^ B;    // xor
            8: ALUOut = A >> B;   // srl
            10: ALUOut = A >>> B;  // sra
            default: ALUOut = 0;
        endcase
        // $display("ALU: ALUctl = %h, A = %h, B = %h, Out = %h", ALUctl, A, B, ALUOut);
    end
    assign zero = (ALUOut == 0);
endmodule


