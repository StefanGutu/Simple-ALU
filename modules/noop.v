module noop(
    input [31:0] x,
    output reg [31:0] z
);

always @(*) begin
    z = ~x;
end 
 
endmodule