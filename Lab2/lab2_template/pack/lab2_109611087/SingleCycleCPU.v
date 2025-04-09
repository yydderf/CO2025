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
wire [6:0]  opcode;
wire [4:0]  rsW;
wire [2:0]  funct3;
wire [4:0]  rs1;
wire [4:0]  rs2;
wire [6:0]  funct7;
assign opcode = inst[6:0];
assign rsW    = inst[11:7];
assign funct3 = inst[14:12];
assign rs1    = inst[19:15];
assign rs2    = inst[24:20];
assign funct7 = inst[31:25];

wire        BrEq;
wire        BrLT;
wire        memRead;
wire [1:0]  memtoReg;
wire [1:0]  ALUOp;
wire        memWrite;
wire        ALUSrc;
wire        regWrite;
wire [1:0]  PCSel;
Control m_Control(
    .opcode(opcode),
    .funct3(funct3),
    .BrEq(BrEq),
    .BrLT(BrLT),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),
    .PCSel(PCSel)
);

// For Student:
// Do not change the Register instance name!
// Or you will fail validation.

wire [31:0] writeData;
wire [31:0] readData1;
wire [31:0] readData2;
Register m_Register(
    .clk(clk),
    .rst(rst),
    .regWrite(regWrite),
    .readReg1(rs1),
    .readReg2(rs2),
    .writeReg(rsW),
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
    .inst(inst),
    .imm(imm)
);

wire [31:0] shlImm;
ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(shlImm)
);

wire [31:0] sum2;
Adder m_Adder_2(
    .a(currPC),
    .b(shlImm),
    .sum(sum2)
);

wire [31:0] ALUOut;
wire [3:0] ALUCtl;
wire zero;
ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(readData1),
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
    .s0(readData2),
    .s1(imm),
    .out(MuxALUOut)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(funct7[5]),
    .funct3(funct3),
    .ALUCtl(ALUCtl)
);

wire [31:0] readData;
DataMemory m_DataMemory(
    .rst(rst),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(writeData),
    .readData(readData)
);

Mux3to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(readData),
    .s2(sum1),
    .out(writeData)
);

endmodule
