module fac(
    input x,
    input y,
    input c,
    output reg z,
    output reg p,
    output reg c_nxt
);

always @(*) begin
    z = x ^ y ^ c;
    p = x || y;
    c_nxt = (x & c) | (y & c) | (x & y);
end

endmodule



//---------------------------------------------------------------------------------------------------


module facn(
    input x,
    input y,
    input c,
    output reg z,
    output reg c_nxt
);

  always @(*) begin
    z = x ^ y ^ c;
    c_nxt = (x & y) | (y & c) | (x & c);
  end

endmodule


//---------------------------------------------------------------------------------------------------


module rca(
    input [3:0] x,
    input [3:0] y,
    input c_in,
    output reg p,
    output reg [3:0] z,
    output reg c_fin
);

wire [3:0] temp_p;
wire [3:0] temp_c;
wire [3:0] temp_z;

genvar i;
    generate
        for(i=0;i<4;i=i+1) begin : v
            if(i == 0) begin
                fac fac_i(  .x(x[0]),
                            .y(y[0]),
                            .c(c_in),
                            .p(temp_p[0]),
                            .z(temp_z[0]),
                            .c_nxt(temp_c[0]));
            end
            else begin
                fac fac_i(  .x(x[i]),
                            .y(y[i]),
                            .c(temp_c[i-1]),
                            .p(temp_p[i]),
                            .z(temp_z[i]),
                            .c_nxt(temp_c[i]));
            end
        end
    endgenerate



always @(*) begin
    p = temp_p[0] & temp_p[1] & temp_p[2] & temp_p[3];
    c_fin = temp_c[3];
    z = {temp_z[3], temp_z[2], temp_z[1], temp_z[0]};
end

endmodule


//---------------------------------------------------------------------------------------------------



module rcan(
    input [3:0] x,
    input [3:0] y,
    input c_in,
    output reg [3:0] z,
    output reg c_fin
);

wire [3:0] temp_c;
wire [3:0] temp_z;

genvar i;
    generate
        for(i=0;i<4;i=i+1) begin : v
            if(i == 0) begin
                facn facn_i(.x(x[0]),
                            .y(y[0]),
                            .c(c_in),
                            .z(temp_z[0]),
                            .c_nxt(temp_c[0]));
            end
            else begin
                facn facn_i(.x(x[i]),
                            .y(y[i]),
                            .c(temp_c[i-1]),
                            .z(temp_z[i]),
                            .c_nxt(temp_c[i]));
            end
        end
    endgenerate



always @(*) begin
    c_fin = temp_c[3];
    z = {temp_z[3], temp_z[2], temp_z[1], temp_z[0]};
end

endmodule

//---------------------------------------------------------------------------------------------------



module CSkA(
    input [15:0] x,
    input [15:0] y,
    input c_in,
    output reg [15:0] z,
    output reg c_fin
);

reg [3:0] test;
reg [3:0] precedent_c;
wire [15:0] temp_z;
wire [3:0] temp_c;
wire [3:0] temp_p;

genvar i;
    generate 
        for(i = 0;i<4;i=i+1) begin : v

            if(i == 0) begin
                rcan rcan_i(.x(x[3:0])
                            ,.y(y[3:0])
                            ,.c_in(c_in)
                            ,.z(temp_z[3:0])
                            ,.c_fin(temp_c[0]));

                always @(*) begin            
                    precedent_c[0] = temp_c[0];
                    
                end

            end
            else if(i == 3) begin
                rcan rcan_i(.x(x[i*4+3:i*4])
                            ,.y(y[i*4+3:i*4])
                            ,.c_in(precedent_c[i-1])
                            ,.z(temp_z[i*4+3:i*4])
                            ,.c_fin(temp_c[i]));
                
                always @(*) begin            
                    
                end
            end
            else begin
                rca rca_i(  .x(x[i*4+3:i*4])
                            ,.y(y[i*4+3:i*4])
                            ,.c_in(precedent_c[i-1])
                            ,.z(temp_z[i*4+3:i*4])
                            ,.p(temp_p[i])
                            ,.c_fin(temp_c[i]));

                always @(*) begin
                    test[i-1] = precedent_c[i-1] & temp_p[i];
                    precedent_c[i] = temp_c[i] | test[i-1];
                end

                always @(*) begin            
                    precedent_c[0] = temp_c[0];
                    
                end

            end
        end
    endgenerate

always @(*) begin
    z = temp_z;
    c_fin = temp_c[0];
    
end

endmodule
