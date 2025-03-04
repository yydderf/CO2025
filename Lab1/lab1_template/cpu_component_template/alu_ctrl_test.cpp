#include "VALUCtrl.h"  // Change this to your generated Verilog module header
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VALUCtrl* alu_ctrl = new VALUCtrl;  // Change to your module name
    VerilatedVcdC* vcd = new VerilatedVcdC;
    Verilated::traceEverOn(true);
    alu_ctrl->trace(vcd, 5);
    vcd->open("waveform.vcd");
    
    struct TestCase {
        int alu_op;
        int funct7;
        int funct3;
        int expected_ctl;
    };
    
    TestCase tests[] = {
        {0b10, 0b0, 0b000, 0b0010},  // ADD
        {0b10, 0b1, 0b000, 0b0110},  // SUB
        {0b10, 0b0, 0b111, 0b0000},  // AND
        {0b10, 0b0, 0b110, 0b0001},  // OR
        {0b10, 0b0, 0b010, 0b0111},  // SLT
        {0b11, 0b0, 0b000, 0b0010},  // ADDI
        {0b11, 0b0, 0b111, 0b0000},  // ANDI
        {0b11, 0b0, 0b110, 0b0001},  // ORI
        {0b11, 0b0, 0b010, 0b0111},  // SLTI
        {0b00, 0b0, 0b010, 0b0010},  // LW/SW
        {0b00, 0b0, 0b000, 0b0010},  // JALR
    };

    for (int i = 0; i < sizeof(tests)/sizeof(TestCase); i++) {
        alu_ctrl->ALUOp = tests[i].alu_op;
        alu_ctrl->funct7 = tests[i].funct7;
        alu_ctrl->funct3 = tests[i].funct3;
        alu_ctrl->eval();
        vcd->dump(i * 10);

        std::cout << "ALUOp: " << tests[i].alu_op
                  << " funct7: " << tests[i].funct7
                  << " funct3: " << tests[i].funct3
                  << " ALUCtl: " << (int)alu_ctrl->ALUCtl
                  << " Expected: " << tests[i].expected_ctl << std::endl;
    }

    vcd->close();
    delete alu_ctrl;
    return 0;
}
