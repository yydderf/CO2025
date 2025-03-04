#include "VALU.h"  // Change this to your generated Verilog module header
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VALU* alu = new VALU;  // Change to your module name
    VerilatedVcdC* vcd = new VerilatedVcdC;
    Verilated::traceEverOn(true);
    alu->trace(vcd, 5);
    vcd->open("waveform.vcd");
    
    struct TestCase {
        int alu_ctl;
        int a;
        int b;
        int expected_out;
        int expected_zero;
    };
    
    TestCase tests[] = {
        {0b0010, 5, 3, 8, 0},    // ADD  (5 + 3 = 8)
        {0b0110, 7, 2, 5, 0},    // SUB  (7 - 2 = 5)
        {0b0000, 6, 3, 2, 0},    // AND  (6 & 3 = 2)
        {0b0001, 4, 1, 5, 0},    // OR   (4 | 1 = 5)
        {0b0111, 3, 5, 1, 0},    // SLT  (3 < 5 ? 1 : 0)
        {0b0111, 5, 3, 0, 1}     // SLT  (5 < 3 ? 1 : 0)
    };

    for (int i = 0; i < 6; i++) {
        alu->ALUctl = tests[i].alu_ctl;
        alu->A = tests[i].a;
        alu->B = tests[i].b;
        alu->eval();
        vcd->dump(i * 10);
        std::cout << "ALUctl: " << tests[i].alu_ctl
                  << " A: " << tests[i].a
                  << " B: " << tests[i].b
                  << " ALUOut: " << alu->ALUOut
                  << " Expected: " << tests[i].expected_out
                  << " Zero: " << (int)alu->zero
                  << " Expected Zero: " << tests[i].expected_zero << std::endl;
    }

    vcd->close();
    delete alu;
    return 0;
}
