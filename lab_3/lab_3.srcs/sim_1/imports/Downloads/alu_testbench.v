`timescale 1ns / 1ps

module alu_testbench;

    // �������ʱ��
    reg clk;
    always #5 clk = ~clk;

    // ������������ź�
    reg [31:0] a_val;
    reg [31:0] b_val;
    reg [3:0] ctrl;

    // �����������ź�
    wire [31:0] result;
    
        // ���� ALU ������
    `define ALU_ADD 4'b0000
    `define ALU_SUB 4'b0001
    `define ALU_SLL 4'b0010
    `define ALU_SLT 4'b0011
    `define ALU_SLTU 4'b0100
    `define ALU_XOR 4'b0101
    `define ALU_SRL 4'b0110
    `define ALU_SRA 4'b0111
    `define ALU_OR 4'b1000
    `define ALU_AND 4'b1001

    // ʵ���� ALU ģ��
    Alu alu_inst(
        .a_val(a_val),
        .b_val(b_val),
        .ctrl(ctrl),
        .result(result)
    );


    initial begin
        clk = 0;
        a_val = 0;
        b_val = 0;
        ctrl = 0;

        // ��һ��������-10 + 5
        #1;
        a_val = -10;
        b_val = 5;
        ctrl = 4'b0000; // ALU_ADD

        // �ڶ���������10 - (-2)
        #1;
        a_val = 10;
        b_val = -2;
        ctrl = 4'b0001; // ALU_SUB

        // ������������10 << 2
        #1;
        a_val = 10;
        b_val = 2;
        ctrl = 4'b0010; // ALU_SLL

        // ���ĸ�������signed(-2) < signed(5)
        #1;
        a_val = -2;
        b_val = 5;
        ctrl = 4'b0011; // ALU_SLT

        // �����������unsigned(-2) < unsigned(5)
        #1;
        a_val = -2;
        b_val = 5;
        ctrl = 4'b0100; // ALU_SLTU

        // ������������unsigned(10) < unsigned(15)
        #1;
        a_val = 10;
        b_val = 15;
        ctrl = 4'b0100; // ALU_SLTU

        // ���߸�������10 ^ 5
        #1;
        a_val = 10;
        b_val = 5;
        ctrl = 4'b0101; // ALU_XOR

        // �ڰ˸�������10 >> 2
        #1;
        a_val = 10;
        b_val = 2;
        ctrl = 4'b0110; // ALU_SRL

        // �ھŸ�������0xFE000000 >>> 4
        #1;
        a_val = 32'hFE000000;
        b_val = 4;
        ctrl = 4'b0111; // ALU_SRA
        
        // �� 10 ��������-97 >>> 5, result == -4
        #1;
        a_val = -97;
        b_val = 5;
        ctrl = 4'b0111; // ALU_SRA
        
        // �� 11 ��������97 >>> 5, result == 3
        #1;
        a_val = 97;
        b_val = 5;
        ctrl = 4'b0111; // ALU_SRA 
        
        // �� 12 ��������53 >>> 0, result == 53
        // ���� >>> 0 ��ʱ���Ƿ�����
        #1;
        a_val = 53;
        b_val = 0;
        ctrl = 4'b0111; // ALU_SRA
        
        // �� 13��������5 or 8
        #1;
        a_val = 5;
        b_val = 8;
        ctrl = 4'b1000; // ALU_OR

        // �� 14 ��������7 and 6
        #1;
        a_val = 7;
        b_val = 6;
        ctrl = 4'b1001; // ALU_AND

        // ��ɲ���
        #1;
        $finish;
    end

endmodule