
module alu_tb;
    reg clk = 0;               
    reg rst = 0;               
    reg bgn = 0;               
    reg sh = 0;                
    reg [3:0] control;         
    reg [3:0] pos;             
    reg [15:0] nr1;
    reg [15:0] nr2;            

    wire borrow_next;
    wire carry_next;
    wire [31:0] outbus;
    wire [31:0] neg;

  
    alu uut(
        .clk(clk),
        .rst(rst),
        .bgn(bgn),
        .sh(sh),
        .control(control),
        .pos(pos),
        .nr1(nr1),
        .nr2(nr2),
        .borrow_next(borrow_next),
        .carry_next(carry_next),
        .outbus(outbus),
        .neg(neg)
    );

    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk;
    end
    
    
    initial begin

        rst = 1;
        bgn = 1;
        pos = 0;
        sh = 0;
        #100; 
        rst = 0;
        // $monitor("output=%b\n",outbus);
        rst = 1;
        bgn = 1;
        control = 4'b0011; 
        nr1 = 16'b0000000000001111;
        nr2 = 16'b0000000000000011;
        #100; 
        rst = 0;
        #50;
        bgn = 1'b0;
        #10000;

        rst = 1;
        bgn = 1;
        control = 4'b0010; 
        nr1 = 16'b0000000000111111;
        nr2 = 16'b0000000000010011;
        #100; 
        rst = 0;
        #50;
        bgn = 1'b0;
        #10000;

        rst = 1;
        bgn = 1;
        control = 4'b0001; 
        nr1 = 16'b0000000000001111;
        nr2 = 16'b0000000000000011;
        #100; 
        rst = 0;
        #50;
        bgn = 1'b0;
        #10000;

        rst = 1;
        bgn = 1;
        control = 4'b0000; 
        nr1 = 16'b0000000000001111;
        nr2 = 16'b0000000000000011;
        #100; 
        rst = 0;
        #50;
        bgn = 1'b0;
        #10000;

        rst = 1;
        bgn = 1;
        control = 4'b0100; 
        nr1 = 16'b0000100000001111;
        nr2 = 16'b0000011000000011;
        #100; 
        rst = 0;
        #50;
        bgn = 1'b0;
        #10000;

        rst = 1;
        bgn = 1;
        control = 4'b0101; 
        nr1 = 16'b0000100000001111;
        nr2 = 16'b0000011000000011;
        #100; 
        rst = 0;
        #50;
        bgn = 1'b0;
        #10000;


        rst = 1;
        bgn = 1;
        control = 4'b0110; 
        nr1 = 16'b0000100000001111;
        nr2 = 16'b0000011000000011;
        #100; 
        rst = 0;
        #50;
        bgn = 1'b0;
        #10000;
 
        $finish;
    end


endmodule