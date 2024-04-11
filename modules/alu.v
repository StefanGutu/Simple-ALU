module alu(
    input clk,
    input rst,
    input bgn,
    input sh,
    input [3:0] control,
    input [3:0] pos,
    input [15:0] nr1,
    input [15:0] nr2,
    
    output reg borrow_next,
    output reg carry_next,
    output reg [31:0] outbus,
    output reg [31:0] neg
);

localparam P1 = 4'b0000;
localparam P2 = 4'b0001;
localparam P3 = 4'b0010;
localparam P4 = 4'b0011;
localparam P5 = 4'b0100;
localparam P6 = 4'b0101;
localparam P7 = 4'b0110;


wire [31:0] r1,r2,r9;
wire [15:0] r3,r4,r5,r6,r7,r8;
wire fin;
wire br_nxt,cr_nxt;

impart impart_i(.clk(clk),.rst(rst),.bgn(bgn),.inbus_q(nr1[14:0]),.inbus_m(nr2),.out_intreg(r1[31:16]),.out_rest(r1[15:0]),.fin(fin));

robertsn robertsn_i(.clk(clk),.rst(rst),.bgn(bgn),.inbus_q(nr1),.inbus_m(nr2),.outbus(r2),.fin(fin));

scazfsc scazfsc_i(.x(nr1),.y(nr2),.b(1'b0),.b_next(br_nxt),.z(r3[15:0]));

CSkA CSkA_i(.x(nr1),.y(nr2),.c_in(1'b0),.z(r4[15:0]),.c_fin(cr_nxt));

orop orop_i(.x(nr1),.y(nr2),.z(r5[15:0]));

andop andop_i(.x(nr1),.y(nr2),.z(r6[15:0]));

xorop xorop_i(.x(nr1),.y(nr2),.z(r7[15:0]));


always @(posedge clk,posedge rst) begin
    case (control)
    P1 : begin
        outbus = r1;
        borrow_next = 1'b0;
        carry_next = 1'b0;
    end
    P2 : begin
        outbus = r2;
        borrow_next = 1'b0;
        carry_next = 1'b0;
    end
    P3 : begin
        outbus = {16'b0,r3};
        borrow_next = br_nxt;
        carry_next = 1'b0;
    end
    P4 : begin
        outbus = {16'b0,r4};
        carry_next = cr_nxt;
        borrow_next = 1'b0;
    end
    P5 : begin
        outbus = {16'b0,r5};
        borrow_next = 1'b0;
        carry_next = 1'b0;
    end
    P6 : begin
        outbus = {16'b0,r6};
        borrow_next = 1'b0;
        carry_next = 1'b0;
    end
    P7 : begin
        outbus = {16'b0,r7};
        borrow_next = 1'b0;
        carry_next = 1'b0;
    end
    
    endcase

end


noop noop_i(.x(outbus),.z(r9));

always @(posedge clk,posedge rst) begin 
    neg = r9;
end

endmodule
