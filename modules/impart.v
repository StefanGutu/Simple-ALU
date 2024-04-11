module counter1(
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


module adder1(
    input clk,
    input rst,
    input [16:0] x,
    input [16:0] y,
    input c3,
    input c4,
    output reg [16:0] z
);



always @(posedge clk,posedge rst) begin
    if(rst) begin
        z <= 17'b0;
    end
    else begin

        if(c3 == 1'b1 && c4 == 1'b1) begin
            z <= x - y; 
        end
        else if(c3 == 1'b1 && c4 == 1'b0) begin
            z <= x + y;
        end
    end
    
        
end

endmodule


//------------------------------------------------------------------------------------


module A_reg(
    input clk,
    input rst,
    input c0,
    input c6,
    input c9,
    input q,
    input [16:0] A,

    output reg [16:0] a_rez,
    output reg [15:0] out
);

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            a_rez <= 17'b0;
        end
        else begin
            if(c0) begin
                a_rez <= 17'b0;
            end
            if(c6) begin
                    a_rez <= A << 1;
                    if(q==1) begin
                        a_rez[0] <= 1'b1;
                    end
                    else begin
                        a_rez[0] <= 1'b0;
                    end
            end
            if(c9) begin
                out <= A[15:0];
            end 

        end
    end

endmodule


//------------------------------------------------------------------------------------



module Q_reg(
    input clk,
    input rst,
    input c1,
    input c5,
    input c6,
    input c7,
    input c8,
    input [14:0] inbus,

    output reg q15,
    output reg [15:0] q_rez,
    output reg [15:0] out
); 

    

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            q_rez <= {15'b0,1'bz};
        end
        else begin
            if(c1) begin
                q_rez <= {inbus,1'bz};
            end
            if(c5) begin
                q_rez[0] <= 1'b0;
            end
            if(c7) begin
                q_rez[0] <= 1'b1;
            end
            if(c6) begin
                q15 <= q_rez[15];
                q_rez <= q_rez << 1;
                q_rez[0] <= 1'bz;
            end
            if(c8) begin

                out <= q_rez;
            end
        end 
    end


endmodule


//------------------------------------------------------------------------------------


module M_reg(
    input clk,
    input rst,
    input c2,
    input [15:0] inbus,
    output reg [16:0] m_rez
);

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            m_rez <= 17'b0;
        end 
        else begin
            if(c2) begin
                m_rez <= {1'b0,inbus};
            end 
        end
    end


endmodule


//------------------------------------------------------------------------------------


module control1(
    input clk,
    input rst,
    input bgn,
    input [4:0] counter,
    input sign,
    output reg fin,
    output reg c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,
    output reg [4:0] nxt,state
);

reg [4:0] nxt_state,state_reg;

parameter INIT =    5'b00000;
parameter S0 =      5'b00001;
parameter S1 =      5'b00010;
parameter S2 =      5'b00011;
parameter S3 =      5'b00100;
parameter S4 =      5'b00101;
parameter S5 =      5'b00110;
parameter S6 =      5'b00111;
parameter S7 =      5'b01000;
parameter S8 =      5'b01001;
parameter S9 =      5'b01010;
parameter S10 =     5'b01011;
parameter S11 =     5'b01100;
parameter S12 =     5'b01101;
parameter S13 =     5'b01111;
parameter S14 =     5'b10000;
parameter FIN =     5'b11111;


always @(posedge clk,posedge rst) begin

    if(rst) begin
        state_reg <= INIT;
        {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, fin} <= 12'b0;
    end
    else begin
        state_reg <= nxt_state;
    end
end


always @(*) begin
    nxt_state = state_reg;
    case(state_reg)
        INIT : begin
            if(bgn == 1'b0) begin
                nxt_state = INIT;
            end
            else begin
                nxt_state = S0;
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
            if(sign == 1'b1) begin
                nxt_state = S4;
            end
            else  begin
                nxt_state = S5;
            end

        end
        S4, S5 : begin
            nxt_state = S6;
        end
        S6 : begin
            if(counter <= 5'b01111) begin
                nxt_state = S7;
            end
            else begin
                nxt_state = S10;
            end
        end
        S7 : begin
            if(sign == 1'b1) begin
                nxt_state = S8;
            end
            else begin
                nxt_state = S9;
            end
        end
        S8 : begin
            nxt_state = S3;
        end
        S9 : begin
            nxt_state = S3;
        end
        S10 : begin
            if(sign == 1'b1) begin
                nxt_state = S11;
            end
            else begin
                nxt_state = S13;
            end
        end
        S11 : begin
            nxt_state = S12;
        end
        S12 : begin
            nxt_state = S13;
        end
        S13 : begin
            nxt_state = FIN;
        end
        

    endcase 
end

always @(posedge clk,posedge rst) begin

    {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9,c10 ,fin} <= 12'b0;

    case(nxt_state)
        S0 : begin
            c1 <= 1'b1;
            c0 <= 1'b1;
        end
        S1 : begin
            c2 <= 1'b1;
        end
        S2 : begin
            c3 <= 1'b1;
            c4 <= 1'b1;
        end
        S4 : begin
            c5 <= 1'b1;
        end
        S5 : begin
            c7 <= 1'b1;
        end
        S6 : begin
            c6 <= 1'b1;
        end
        S7 : begin
            c10 <= 1'b1;        
        end
        S8 : begin
            c3 <= 1'b1;
        end 
        S9 : begin
            c3 <= 1'b1;
            c4 <= 1'b1;
        end
        S10 : begin
        end 
        S11 : begin
            c3 <= 1'b1;
        end
        S12 : begin     
            
        end
        S13 : begin
            c9 <= 1'b1;
            c8 <= 1'b1;
            
        end
        FIN : begin
            fin <= 1'b1;
            
        end
    endcase 
    nxt <= nxt_state;
    state <= state_reg;

end

endmodule


//---------------------------------------------------------------------------------------------------------------------------------------


module impart(
    input clk,
    input rst,
    input bgn,
    input [14:0] inbus_q,
    input [15:0] inbus_m,
    output [15:0] out_intreg,
    output [15:0] out_rest,
    output reg fin
);

    reg [16:0] A;
    reg [16:0] M;
    reg [4:0] count;
    reg Q15_reg;

    wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9;

    wire [16:0] A_temp;
    wire [16:0] A_temp2;
    wire [15:0] Q_temp;
    wire [16:0] M_temp;
    wire [4:0] count_temp;
    wire Q15_temp;
    wire fin_temp;

    wire [4:0] nxt_temp,state_temp;
    

    
    Q_reg Q_reg_i(.clk(clk),.rst(rst),.c1(c1),.c5(c5),.c6(c10),.c7(c7),.c8(c8),.inbus(inbus_q),.q15(Q15_temp),.q_rez(Q_temp),.out(out_intreg));

    always @(*) begin
        Q15_reg = Q15_temp;
    end

    M_reg M_reg_i(.clk(clk),.rst(rst),.c2(c2),.inbus(inbus_m),.m_rez(M_temp));

    A_reg A_reg_i(.clk(clk),.rst(rst),.c0(c0),.c6(c10),.c9(c9),.q(Q15_reg),.A(A),.a_rez(A_temp),.out(out_rest));
    

    always @(*) begin
        M = M_temp;
       
    end

    adder1 adder_i(.clk(clk),.rst(rst),.x(A_temp),.y(M),.c3(c3),.c4(c4),.z(A_temp2));

    always @(*) begin
        A = A_temp2;
    end


    counter1 counter1_i(.clk(clk),.rst(rst),.incr(c6),.cnt_in(count),.cnt(count_temp));

    always @(*) begin
        count = count_temp;
    end

    control1 control_i(  .clk(clk),.rst(rst),.bgn(bgn),.counter(count),.sign(A[16]),.fin(fin_temp),.c0(c0),.c1(c1),
                        .c2(c2),.c3(c3),.c4(c4),.c5(c5),.c6(c6),.c7(c7),.c8(c8),.c9(c9),.c10(c10),.nxt(nxt_temp),.state(state_temp));

    always @(*) begin
        fin = fin_temp;
    end
    


endmodule