module Pipeline_Register #(
    parameter WIDTH = 32
)(
    input wire clk,
    input wire rst,
    input wire [WIDTH-1:0] data_i,
    output reg [WIDTH-1:0] data_o
);
    // TODO: implement your pipeline register here
    // Hint: it stores inter-staged signals at the posedge of the clock.

endmodule
