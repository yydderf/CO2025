module ID_EX_Reg (
    input wire clk,
    input wire rst,
    input wire [2:0] WB_i,
    input wire [1:0] M_i,
    input wire [2:0] EX_i,
    input wire [31:0] pc_4_i,
    input wire [31:0] readData1_i,
    input wire [31:0] readData2_i,
    input wire [31:0] imm_i,
    input wire funct7_i,
    input wire [2:0] funct3_i,
    input wire [4:0] writeReg_i,
    output wire [2:0] WB_o,
    output wire [1:0] M_o,
    output wire ALUSrc,
    output wire [1:0] ALUOp,
    output wire [31:0] pc_4_o,
    output wire [31:0] readData1_o,
    output wire [31:0] readData2_o,
    output wire [31:0] imm_o,
    output wire funct7_o,
    output wire [2:0] funct3_o,
    output wire [4:0] writeReg_o
);
    Pipeline_Register #(.WIDTH(3)) WB_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(WB_i),
        .data_o(WB_o)
    );

    Pipeline_Register #(.WIDTH(2)) M_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(M_i),
        .data_o(M_o)
    );

    Pipeline_Register #(.WIDTH(1)) ALUSrc_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(EX_i[2]),
        .data_o(ALUSrc)
    );

    Pipeline_Register #(.WIDTH(2)) ALUOp_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(EX_i[1:0]),
        .data_o(ALUOp)
    );

    Pipeline_Register #(.WIDTH(32)) PC4_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(pc_4_i),
        .data_o(pc_4_o)
    );

    Pipeline_Register #(.WIDTH(32)) ReadData1_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(readData1_i),
        .data_o(readData1_o)
    );

    Pipeline_Register #(.WIDTH(32)) ReadData2_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(readData2_i),
        .data_o(readData2_o)
    );

    Pipeline_Register #(.WIDTH(32)) Imm_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(imm_i),
        .data_o(imm_o)
    );

    Pipeline_Register #(.WIDTH(1)) Funct7_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(funct7_i),
        .data_o(funct7_o)
    );

    Pipeline_Register #(.WIDTH(3)) Funct3_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(funct3_i),
        .data_o(funct3_o)
    );

    Pipeline_Register #(.WIDTH(5)) WriteReg_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(writeReg_i),
        .data_o(writeReg_o)
    );
endmodule
