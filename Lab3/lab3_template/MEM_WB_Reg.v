module MEM_WB_Reg (
    input wire clk,
    input wire rst,
    input wire [2:0] WB_i,
    input wire [31:0] pc_4_i,
    input wire [31:0] ALUOut_i,
    input wire [31:0] readData_i,
    input wire [4:0] writeReg_i,
    output wire regWrite,
    output wire [1:0] memtoReg,
    output wire [31:0] pc_4_o,
    output wire [31:0] ALUOut_o,
    output wire [31:0] readData_o,
    output wire [4:0] writeReg_o
);
    Pipeline_Register #(.WIDTH(1)) RegWrite_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(WB_i[2]),
        .data_o(regWrite)
    );

    Pipeline_Register #(.WIDTH(2)) MemtoReg_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(WB_i[1:0]),
        .data_o(memtoReg)
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

    Pipeline_Register #(.WIDTH(32)) ReadData_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(readData_i),
        .data_o(readData_o)
    );

    Pipeline_Register #(.WIDTH(5)) WriteReg_Reg (
        .clk(clk),
        .rst(rst),
        .data_i(writeReg_i),
        .data_o(writeReg_o)
    );

endmodule

