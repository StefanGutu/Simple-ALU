module hsc(
    input x,
    input y,
    output reg b,
    output reg z
);

always @(*) begin
    b = ~x & y;
    z = x ^ y;
end


endmodule


//---------------------------------------------------------------------------------------------------


module fscn(
    input x,
    input y,
    input b,
    output reg b_next,
    output reg z
);

wire [1:0] b_wire;
wire [1:0] z_wire;

hsc hsc_1(.x(x), .y(y), .b(b_wire[0]), .z(z_wire[0]));

hsc hsc_2(.x(z_wire[0]), .y(b), .b(b_wire[1]), .z(z_wire[1]));

always @(*) begin
    z = z_wire[1];
    b_next = b_wire[1] | b_wire[0]; 
end

endmodule


//---------------------------------------------------------------------------------------------------



module scazfsc(
    input [15:0] x,
    input [15:0] y,
    input b,
    output reg b_next,
    output reg [15:0] z
);

wire [15:0] b_wire;
wire [15:0] z_wire;

genvar i;
    generate 
        for(i=0;i<16;i=i+1) begin : v
            if(i == 0) begin
                fscn fscn_i(.x(x[0]),.y(y[0]),.b(b),.b_next(b_wire[0]),.z(z_wire[0]));
            end 
            else begin
                fscn fscn_i(.x(x[i]),.y(y[i]),.b(b_wire[i-1]),.b_next(b_wire[i]),.z(z_wire[i]));
            end
        end
    endgenerate

always @(*) begin
    b_next = b_wire[15];
    z = z_wire;
end

endmodule




