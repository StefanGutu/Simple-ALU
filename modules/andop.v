module andop(
    input [15:0] x,
    input [15:0] y,
    output reg [15:0] z
);

always @(*) begin
    z = x & y;        
end

endmodule