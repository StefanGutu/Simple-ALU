module counter(
    input clk,
    input rst,
    input incr,
    input [4:0] cnt_in,
    output reg [4:0] cnt
);

always @(posedge clk,posedge rst) begin
    if(rst) begin
        cnt <= 5'b0;
    end
    else if(incr) begin
        cnt <= cnt_in + 1;    
    end
end

endmodule


//------------------------------------------------------------------------------------


module adder(
    input [15:0] x,
    input [15:0] y,
    input c_in,
    output reg [15:0] z,
    output reg c_out 
);

always @(*) begin
    {c_out,z} <= x + y + c_in;
end

endmodule


//------------------------------------------------------------------------------------


module m_reg(
    input clk,
    input rst,
    input ld,
    input neg,
    input [15:0] M,
    output reg [15:0] m_rez
);

always @(posedge clk,posedge rst) begin
    if(rst) begin
        m_rez <= 16'b0;
    end
    else begin
        if(ld) begin
            m_rez <= M;
        end
        else if(neg) begin
            m_rez <= ~M + 1'b1;
        end
    end
end

endmodule


//------------------------------------------------------------------------------------


module q_reg(
    input clk,
    input rst,
    input ld,
    input ld_out,
    input shift,
    input corector,
    input a0,
    input [15:0] Q,
    input [15:0] q_in,
    output reg [15:0] q_rez,
    output reg [15:0] out
);


always @(posedge clk,posedge rst) begin
    if(rst) begin
        q_rez <=16'b0;
    end
    else begin
        if(ld) begin
            q_rez <= Q;
        end
        else if(shift) begin 
            q_rez <= {a0,q_in[15:1]};
        end
        else if(corector) begin
            q_rez <= {q_in[15:1],1'b0};
        end
        else if(ld_out) begin
            out <= q_rez;
        end
    end
end


endmodule


//------------------------------------------------------------------------------------


module a_reg(
    input clk,
    input rst,
    input ld,
    input ld_out,
    input shift,
    input Q,
    input M,
    input F,
    input [15:0] A,
    output reg [15:0] a_rez,
    output reg f_out,
    output reg [15:0] out
);

always @(posedge clk,posedge rst) begin
    if(rst) begin
        a_rez <= 16'b0;
        f_out <= 0;
    end
    else begin
        if(ld) begin
            a_rez <= A;
        end
        else if(shift) begin
            f_out <= (Q & M) | F;
            a_rez <= {f_out,a_rez[15:1]};
        end
        else if(ld_out) begin
            out <= a_rez;
        end
    end
end

endmodule


//------------------------------------------------------------------------------------


module control(
    input clk,
    input rst,
    input bgn,
    input [4:0] counter,
    input Q,
    input A_neg,
    output reg fin,
    output reg c0,c1,c2,c3,c4,c5,c6
);

reg [3:0] nxt_state,state_reg;

parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;
parameter S9 = 4'b1001;
parameter S10 = 4'b1010;
parameter INIT = 4'b1011;
parameter FIN = 4'b1100;


always @(posedge clk,posedge rst) begin
    if (rst) begin
        state_reg <= INIT;
    end 
    else if(rst == 1'b0) begin
        state_reg <= nxt_state;        
    end
end


always @(*) begin
    case (state_reg)
        INIT : begin
            if(bgn == 1) begin
                nxt_state = S0;
                
            end
            else begin
                nxt_state = INIT;
            end
        end
        S0 : begin
            nxt_state = S1;           
        end
        S1 : begin
            nxt_state = S2;
        end
        S2 : begin
            nxt_state = S3;
        end 
        S3 : begin
            if(Q == 1'b1) begin
                nxt_state = S4;
            end
            else if(Q == 1'b0) begin
                nxt_state = S5;
            end
        end
        S4 : begin
            nxt_state = S5;
        end 
        S5 : begin
            nxt_state = S6;
        end
        S6 : begin
            if(counter < 5'b10000) begin
                nxt_state = S3;
            end
            else if(Q == 1'b1 && A_neg ==1'b1) begin
                nxt_state = S8;
            end
            else begin
                nxt_state = S7;
            end
        end
        S7 : begin
            nxt_state = S9;
        end
        S8 : begin
            nxt_state = S9;
        end 
        S9 : begin
            nxt_state = S10;
        end
        S10 : begin
            nxt_state = FIN;
        end
    endcase
    
end

always @(state_reg) begin
    {c0, c1, c2, c3, c4, c5, c6, fin} <= 8'b0;

    case(nxt_state)
        S1 : begin
            c0 <= 1'b1;
        end 
        S2 : begin
            c1 <= 1'b1;
        end
        S4 : begin
            c2 <= 1'b1;
        end
        S5 : begin
            c3 <= 1'b1;
        end
        S8 : begin
            c2 <= 1'b1;
            c4 <= 1'b1;
        end
        S9 : begin
            c5 <= 1'b1;
            c6 <= 1'b1;
        end
        S10 : begin
            c5 <= 1'b1;
            c6 <= 1'b1;
        end
        FIN : begin
            fin <= 1'b1;
        end
    endcase
end


endmodule


//--------------------------------------------------------------------------


module robertsn(
    input clk,
    input rst,
    input bgn,
    input [15:0] inbus_q,
    input [15:0] inbus_m,
    output [31:0] outbus,
    output fin
);

    reg [15:0] A;
    reg [15:0] Q;
    reg [15:0] M;
    reg [4:0] count;
    reg F_reg;
    wire c0,c1,c2,c3,c4,c5,c6;

    wire [15:0] A_temp;
    wire [15:0] A_temp2;
    wire [15:0] Q_temp;
    wire [15:0] M_temp;
    wire [4:0] count_temp;
    wire f_temp;
    wire cout;

    



    a_reg a_reg_i(.clk(clk),.rst(rst),.ld(c2),.shift(c3),.F(F_reg),.Q(Q[0]),.M(inbus_m[15]),.ld_out(c5),.A(A_temp),.out(outbus[31:16]),.a_rez(A_temp2),.f_out(f_temp));

    always @(*) begin
        F_reg = f_temp;
        A = A_temp2;
    end

    m_reg m_reg_i(.clk(clk),.rst(rst),.ld(c0),.neg(c4),.M(inbus_m),.m_rez(M_temp));

    q_reg q_reg_i(.clk(clk),.rst(rst),.ld(c1),.ld_out(c6),.shift(c3),.corector(c4),.a0(A[0]),.Q(inbus_q),.q_in(Q),.q_rez(Q_temp),.out(outbus[15:0]));

    always @(*) begin
        Q = Q_temp;
    end

    

    adder adder_i(.x(A),.y(inbus_m),.c_in(1'b0),.z(A_temp),.c_out(cout));

    counter counter_i(.clk(clk),.rst(rst),.incr(c3),.cnt_in(count),.cnt(count_temp));

    always @(*) begin
        count = count_temp;
        
    end

    control control_i(  .clk(clk),.rst(rst),.bgn(bgn),.counter(count),.Q(Q[0]),.A_neg(A[15]),.fin(fin),
                        .c0(c0),.c1(c1),.c2(c2),.c3(c3),.c4(c4),.c5(c5),.c6(c6));



endmodule
