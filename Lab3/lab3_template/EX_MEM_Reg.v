module EX_MEM_Reg (
    input wire clk,
    input wire rst,
    input wire [2:0] WB_i,
    input wire [1:0] M_i,
    input wire [31:0] pc_4_i,
    input wire [31:0] ALUOut_i,
    input wire [31:0] readData2_i,
    input wire [4:0] writeReg_i,
    output wire [2:0] WB_o,
    output wire memRead,
    output wire memWrite,
    output wire [31:0] pc_4_o,
    output wire [31:0] ALUOut_o,
    output wire [31:0] readData2_o,
    output wire [4:0] writeReg_o
);
    Pipeline_Register #(.WIDTH(3)) WB_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(WB_i),
        .data_o(WB_o)
    );

    Pipeline_Register #(.WIDTH(1)) MemRead_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(M_i[1]),
        .data_o(memRead)
    );

    Pipeline_Register #(.WIDTH(1)) MemWrite_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(M_i[0]),
        .data_o(memWrite)
    );

    Pipeline_Register #(.WIDTH(32)) PC4_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(pc_4_i),
        .data_o(pc_4_o)
    );

    Pipeline_Register #(.WIDTH(32)) ALUOut_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(ALUOut_i),
        .data_o(ALUOut_o)
    );

    Pipeline_Register #(.WIDTH(32)) ReadData2_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(readData2_i),
        .data_o(readData2_o)
    );

    Pipeline_Register #(.WIDTH(5)) WriteReg_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(writeReg_i),
        .data_o(writeReg_o)
    );

endmodule
