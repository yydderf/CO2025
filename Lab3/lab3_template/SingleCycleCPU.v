module SingleCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// top->start = 0 -> reset -> rst = 0 - rst = start
// When input start is high, cpu start running
// top->start = 1 -> run

// The rst signal is active low, which means the module will reset if the rst signal is zero.
// And you should follow this design.
wire rst = start;

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module
wire [31:0] nextPC;
wire [31:0] currPC;
PC m_PC(
    .clk(clk),
    .rst(rst),
    .pc_i(nextPC),
    .pc_o(currPC)
);

wire [31:0] sum1;
// add 4 to pc
Adder m_Adder_1(
    .a(currPC),
    .b(32'd4),
    .sum(sum1)
);

wire [31:0] inst; // inst -> writeReg, readReg1, readReg2, inst (ImmGen)
InstructionMemory m_InstMem(
    .readAddr(currPC),
    .inst(inst)
);

wire [31:0] PC_ID;
wire [31:0] PC_4_ID;
wire [31:0] Inst_ID;
IF_ID_Reg m_IF_ID_Reg(
    .clk(clk),
    .rst(rst),
    .PC_i(currPC),
    .PC_4_i(sum1),
    .Inst_i(inst),
    .PC_o(PC_ID),
    .PC_4_o(PC_4_ID),
    .Inst_o(Inst_ID)
);

wire BrEq;
wire BrLT;
wire [2:0] WB;
wire [1:0] M;
wire [2:0] EX;
wire [1:0] PCSel;

// wire [1:0] memtoReg;
// wire memRead;
// wire memWrite;
// wire regWrite;
// wire ALUSrc;
// wire [1:0] ALUOp;
Control m_Control(
    .opcode(Inst_ID[6:0]),
    .funct3(Inst_ID[14:12]),
    .BrEq(BrEq),
    .BrLT(BrLT),
    .M(M),
    .WB(WB),
    .EX(EX),
    .PCSel(PCSel)
);
wire [1:0] memtoReg;
wire memRead;
wire memWrite;
wire regWrite;
wire ALUSrc;
wire [1:0] ALUOp;

// For Student:
// Do not change the Register instance name!
// Or you will fail validation.

wire [4:0] writeReg_WB;
wire [31:0] writeData;
wire [31:0] readData1;
wire [31:0] readData2;
Register m_Register(
    .clk(clk),
    .rst(rst),
    .regWrite(regWrite),
    .readReg1(Inst_ID[19:15]),
    .readReg2(Inst_ID[24:20]),
    .writeReg(writeReg_WB),
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
);

// ======= for validation =======
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

// readData1, readData2 output from m_Register
BranchComp m_BranchComp(
    .A(readData1),
    .B(readData2),
    .BrEq(BrEq),
    .BrLT(BrLT)
);

wire [31:0] imm;
ImmGen m_ImmGen(
    .inst(Inst_ID),
    .imm(imm)
);

wire [31:0] shlImm;
ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(shlImm)
);

wire [31:0] sum2;
Adder m_Adder_2(
    .a(PC_ID),
    .b(shlImm),
    .sum(sum2)
);

wire [2:0] WB_EX;
wire [1:0] M_EX;
wire [31:0] PC_4_EX;
wire [31:0] readData1_EX;
wire [31:0] readData2_EX;
wire [31:0] imm_EX;
wire [4:0] writeReg_EX;
wire funct7_EX;
wire [2:0] funct3_EX;
ID_EX_Reg m_ID_EX_Reg(
    .clk(clk),
    .rst(rst),
    .WB_i(WB),
    .M_i(M),
    .EX_i(EX),
    .pc_4_i(PC_4_ID),
    .readData1_i(readData1),
    .readData2_i(readData2),
    .imm_i(imm),
    .funct7_i(Inst_ID[30]),
    .funct3_i(Inst_ID[14:12]),
    .writeReg_i(Inst_ID[11:7]),
    .WB_o(WB_EX),
    .M_o(M_EX),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .pc_4_o(PC_4_EX),
    .readData1_o(readData1_EX),
    .readData2_o(readData2_EX),
    .imm_o(imm_EX),
    .funct7_o(funct7_EX),
    .funct3_o(funct3_EX),
    .writeReg_o(writeReg_EX)
);

wire [31:0] ALUOut;
wire [3:0] ALUCtl;
wire zero;
ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(readData1_EX),
    .B(MuxALUOut),
    .ALUOut(ALUOut),
    .zero(zero)
);

Mux3to1 #(.size(32)) m_Mux_PC(
    .sel(PCSel),
    .s0(sum1),
    .s1(sum2),
    .s2(ALUOut),
    .out(nextPC)
);

wire [31:0] MuxALUOut;
Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2_EX),
    .s1(imm_EX),
    .out(MuxALUOut)
);

// combine ALUOp, funct7, and funct3 to determine ALUCtrl
// funct7 is used for R type operations
// funct3 is used to determine arithemetic operation type
// ALUOp: -> ALUCtrl: arithmetic operation
ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(funct7_EX),
    .funct3(funct3_EX),
    .ALUCtl(ALUCtl)
);

// EX_MEM
wire [2:0] WB_MEM;
wire [31:0] PC_4_MEM;
wire [31:0] ALUOut_MEM;
wire [31:0] readData2_MEM;
wire [4:0] writeReg_MEM;
EX_MEM_Reg m_EX_MEM_Reg (
    .clk(clk),
    .rst(rst),
    .WB_i(WB_EX),
    .M_i(M_EX),
    .pc_4_i(PC_4_EX),
    .ALUOut_i(ALUOut),
    .readData2_i(readData2_EX),
    .writeReg_i(writeReg_EX),
    .WB_o(WB_MEM),
    .memRead(memRead),
    .memWrite(memWrite),
    .pc_4_o(PC_4_MEM),
    .ALUOut_o(ALUOut_MEM),
    .readData2_o(readData2_MEM),
    .writeReg_o(writeReg_MEM)
);

wire [31:0] readData;
DataMemory m_DataMemory(
    .rst(rst),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut_MEM),
    .writeData(readData2_MEM),
    .readData(readData)
);

// MEM_WB
wire [31:0] PC_4_WB;
wire [31:0] ALUOut_WB;
wire [31:0] readData_WB;
MEM_WB_Reg m_MEM_WB_Reg (
    .clk(clk),
    .rst(rst),
    .WB_i(WB_MEM),
    .pc_4_i(PC_4_MEM),
    .ALUOut_i(ALUOut_MEM),
    .readData_i(readData),
    .writeReg_i(writeReg_MEM),
    .regWrite(regWrite),
    .memtoReg(memtoReg),
    .pc_4_o(PC_4_WB),
    .ALUOut_o(ALUOut_WB),
    .readData_o(readData_WB),
    .writeReg_o(writeReg_WB)
);


// memtoReg val: data source -> selected data
// 00: data from ALU
// 01: data from memory
// 10: data from adder1 (PC+4)
Mux3to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut_WB),
    .s1(readData_WB),
    .s2(PC_4_WB),
    .out(writeData)
);

endmodule
