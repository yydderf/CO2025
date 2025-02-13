module PipelineCPU (
    input         clk,
    input         start,

    // Data memory ports
    output        byteMask,
    output        memWrite,
    output        memRead,
    output [31:0] address,
    output [31:0] writeData,
    input  [31:0] readData,

    // Instruction memory ports
    output [31:0] readAddr,
    input  [31:0] inst
);

// Your CPU core here!


endmodule
