module Mux3to1 #(
    parameter size = 32
)
(
    input [1:0] sel,
    input signed [size-1:0] s0,
    input signed [size-1:0] s1,
    input signed [size-1:0] s2,
    output reg signed [size-1:0] out
);
    // TODO: implement your 3to1 multiplexer here
    always @(*) begin
        case (sel)
            2'b00: out = s0;
            2'b01: out = s1;
            2'b10: out = s2;
            default: out = s0;
        endcase
    end

endmodule
