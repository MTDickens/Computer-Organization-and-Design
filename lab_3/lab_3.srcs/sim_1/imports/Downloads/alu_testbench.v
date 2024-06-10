`timescale 1ns / 1ps

module alu_testbench;

    // 定义仿真时钟
    reg clk;
    always #5 clk = ~clk;

    // 定义仿真输入信号
    reg [31:0] a_val;
    reg [31:0] b_val;
    reg [3:0] ctrl;

    // 定义仿真输出信号
    wire [31:0] result;
    
        // 定义 ALU 操作码
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

    // 实例化 ALU 模块
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

        // 第一个操作：-10 + 5
        #1;
        a_val = -10;
        b_val = 5;
        ctrl = 4'b0000; // ALU_ADD

        // 第二个操作：10 - (-2)
        #1;
        a_val = 10;
        b_val = -2;
        ctrl = 4'b0001; // ALU_SUB

        // 第三个操作：10 << 2
        #1;
        a_val = 10;
        b_val = 2;
        ctrl = 4'b0010; // ALU_SLL

        // 第四个操作：signed(-2) < signed(5)
        #1;
        a_val = -2;
        b_val = 5;
        ctrl = 4'b0011; // ALU_SLT

        // 第五个操作：unsigned(-2) < unsigned(5)
        #1;
        a_val = -2;
        b_val = 5;
        ctrl = 4'b0100; // ALU_SLTU

        // 第六个操作：unsigned(10) < unsigned(15)
        #1;
        a_val = 10;
        b_val = 15;
        ctrl = 4'b0100; // ALU_SLTU

        // 第七个操作：10 ^ 5
        #1;
        a_val = 10;
        b_val = 5;
        ctrl = 4'b0101; // ALU_XOR

        // 第八个操作：10 >> 2
        #1;
        a_val = 10;
        b_val = 2;
        ctrl = 4'b0110; // ALU_SRL

        // 第九个操作：0xFE000000 >>> 4
        #1;
        a_val = 32'hFE000000;
        b_val = 4;
        ctrl = 4'b0111; // ALU_SRA
        
        // 第 10 个操作：-97 >>> 5, result == -4
        #1;
        a_val = -97;
        b_val = 5;
        ctrl = 4'b0111; // ALU_SRA
        
        // 第 11 个操作：97 >>> 5, result == 3
        #1;
        a_val = 97;
        b_val = 5;
        ctrl = 4'b0111; // ALU_SRA 
        
        // 第 12 个操作：53 >>> 0, result == 53
        // 测试 >>> 0 的时候，是否会出错
        #1;
        a_val = 53;
        b_val = 0;
        ctrl = 4'b0111; // ALU_SRA
        
        // 第 13个操作：5 or 8
        #1;
        a_val = 5;
        b_val = 8;
        ctrl = 4'b1000; // ALU_OR

        // 第 14 个操作：7 and 6
        #1;
        a_val = 7;
        b_val = 6;
        ctrl = 4'b1001; // ALU_AND

        // 完成测试
        #1;
        $finish;
    end

endmodule