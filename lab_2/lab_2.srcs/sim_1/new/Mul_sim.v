`timescale 1ns / 1ps

module Mul_sim;

    // ʱ�Ӻ͸�λ�ź�
    reg clk;
    reg rst;

    // �����ź�
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg start;

    // ����ź�
    wire [31:0] product;
    wire ready;
    wire finish;
    
    // DEBUG
//    wire [1:0] check_bits_out;
//    wire [15:0] left_add_out;
//    wire [15:0] left_minus_out;

    // ʵ���������Եĳ˷���ģ��
    Mul uut (
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .start(start),
        .product(product),
        .ready(ready),
        .finish(finish)
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
        multiplicand = 16'h1234;
        multiplier = 16'h5678;
        start = 0;
        #15 start = 1;
        #10 start = 0;
        #200 
        multiplicand = -16'h666;
        multiplier = -16'h777;
        #15 start = 1;
        #10 start = 0;
        #200;       
        multiplicand = 16'h888;
        multiplier = -16'h999;
        #15 start = 1;
        #10 start = 0;
        #200;   
        multiplicand = -16'h222;
        multiplier = 16'h333;
        #15 start = 1;
        #10 start = 0;
        #220;  
        $finish; // �������
    end

    // ��ӡ����ź�
    always @(posedge clk) begin
        $display("Time=%t, Product=%h, Ready=%b, Finish=%b", $time, product, ready, finish);
    end

endmodule
