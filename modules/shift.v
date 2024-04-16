module shift(
    input [15:0] x,
    input  sh,
    input [3:0] pos,
    output reg [15:0] z
);


always @(*) begin
    case (sh) 

        2'b0 : z = x << pos;

        2'b1 : z = x >> pos;

    endcase
end


endmodule



