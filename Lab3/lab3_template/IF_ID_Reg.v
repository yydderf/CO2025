module IF_ID_Reg (
    input wire clk,
    input wire rst,
    input wire [31:0] PC_i,
    input wire [31:0] PC_4_i,
    input wire [31:0] Inst_i,
    output wire [31:0] PC_o,
    output wire [31:0] PC_4_o,
    output wire [31:0] Inst_o
);
    // TODO:
    // Besides the IF/ID stage register provided in the template file,
    // you will also need to create other stage registers such as ID/EX, EX/MEM, MEM/WB, etc.

    // Hint:
    // There are two approaches to implement the stage registers:
    // 1. Use a generic Pipeline Register module to instantiate the registers for each stage,
    //    where each Pipeline Register handles only one type of data. This approach is modular,
    //    making it easy to modify later.
    // 2. Directly specialize the Pipeline Register into distinct modules for each stage,
    //    which makes the design more intuitive and easier to understand.
    // Choose the design approach that best suits your needs.
    Pipeline_Register #(.WIDTH(32)) PC_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(PC_i),
        .data_o(PC_o)
    );
    Pipeline_Register #(.WIDTH(32)) PC_4_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(PC_4_i),
        .data_o(PC_4_o)
    );
    Pipeline_Register #(.WIDTH(32)) Inst_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(Inst_i),
        .data_o(Inst_o)
    );

endmodule
