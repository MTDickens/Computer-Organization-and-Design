`timescale 1ns / 1ps

module Div_sim;

   // ʱ�Ӻ͸�λ�ź�
    reg clk;
    reg rst;

    // �����ź�
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg start;

    // ����ź�
    wire [15:0] quotient;
    wire [15:0] remainder;
    wire ready;
    wire finish;
    wire div_by_0;
    
//    wire [4:0] count_out; // DEBUG
//    wire [31:0] quo_rem_reg_out; // DEBUG
//    wire [15:0] divisor_reg_out; // DEBUG
    

    // ʵ���������Եĳ˷���ģ��
    Div uut (
        .clk(clk),
        .rst(rst),
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .quotient(quotient),
        .remainder(remainder),
        .ready(ready),
        .finish(finish),
        .div_by_0(div_by_0)
//        ,.quo_rem_reg_out(quo_rem_reg_out) // DEBUG 
//        ,.count_out(count_out) // DEBUG
//        ,.divisor_reg_out(divisor_reg_out) // DEBUG
//        ,.check_bits_out(check_bits_out),
//        .left_add_out(left_add_out),
//        .left_minus_out(left_minus_out)
    );

    // ����ʱ��
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ��ʼ����λ�ź�
    initial begin
        rst = 1;
        #10 rst = 0;
    end

    // ��ʼ�������ź�
    initial begin
        dividend = 12345;
        divisor = 333;
        start = 0;
        #15 start = 1;
        #10 start = 0;
        #200;
        
        dividend = 99793;
        divisor = -132;
        start = 0;
        #15 start = 1;
        #10 start = 0;
        #200;
        
        dividend = -1919;
        divisor = 810;
        start = 0;
        #15 start = 1;
        #10 start = 0;
        #200;
        
        dividend = -19198;
        divisor = -10;
        start = 0;
        #15 start = 1;
        #10 start = 0;
        #200;
        
        dividend = 4982;
        divisor = 0;
        start = 0;
        #15 start = 1;
        #10 start = 0;
        #200;
        $finish;
    end

endmodule
