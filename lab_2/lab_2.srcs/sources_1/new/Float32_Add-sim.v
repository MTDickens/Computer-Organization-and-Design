`timescale 1ns / 1ps
module Float32_Add_Test;

    reg clk;
    reg rst;
    reg [31:0] add1;
    reg [31:0] add2;
    reg start;
    wire [31:0] result;
    wire ready;
    wire finish;

    reg [24:0] test;
    reg test_bit;
    reg [24:0] ans2;
    reg [24:0] ans1;
    reg [24:0] ans3;


    // DEBUG BEGIN
    // wire [24:0] debug_num;
    // wire debug_dosub;
    // wire [24:0] debug_num1; 
    // wire [24:0] debug_num2;
    // wire [7:0] debug_exp1;
    // wire [7:0] debug_exp2;
    // wire [24:0] debug_general;
    // DEBUG END

    Float32_Add u1 (
        .clk(clk),
        .rst(rst),
        .add_a(add1),
        .add_b(add2),
        .start(start),
        .result(result),
        .ready(ready),
        .finish(finish)
        // DEBUG
        // ,.debug_num(debug_num),
        // .debug_dosub(debug_dosub),
        // .debug_num1(debug_num1),
        // .debug_num2(debug_num2),
        // .debug_exp1(debug_exp1),
        // .debug_exp2(debug_exp2),
        // .debug_general(debug_general)
    );

    initial begin
        // test = 25'h800000;
        // test_bit = 1;
        // ans1 = (test) ^ {25{test_bit}};
        // ans2 = ans1 + test_bit;
        // ans3 = ((test) ^ {25{test_bit}}) + test_bit;
        // #10; $finish;

        clk = 0;
        rst = 1;
        add1 = 0;
        add2 = 0;
        start = 0;
        #10 rst = 0;
        #10 start = 1;


        // ?????????
        add1 = 32'h3F800000; // 1.0 in float
        add2 = 32'h40000000; // 2.0 in float
        #20 start = 0;
        #50;
        start = 1;

        // ?????????
        add1 = 32'h3F800000; // 1.0 in float
        add2 = 32'hC0000000; // -2.0 in float
        #20 start = 0;
        #50;
        start = 1;

        // ?????????
        add1 = 32'hC0000000; // -2.0 in float
        add2 = 32'h3F800000; // 1.0 in float
        #20 start = 0;
        #50;
        start = 1;

        // // ?????????
        add1 = 32'hC0000000; // -2.0 in float
        add2 = 32'hC0400000; // -3.0 in float
        #20 start = 0;
        #50;
        start = 1;

        // ???????????????
        add1 = 32'h7F800000; // positive infinity
        add2 = 32'h3F800000; // 1.0 in float
        #20 start = 0;
        #50;
        start = 1;

        // ?????????????? 0
        add1 = 32'hC0000000; // -2.0 in float
        add2 = 32'h40000000; // 2.0 in float
        #20 start = 0;
        #50;
        start = 1;

        // ?????????????
        add1 = 32'h3F800000; // 1.0 in float
        add2 = 32'h3F800000; // 1.0 in float
        #20 start = 0;
        #50;
        start = 1;

        // ???????????? -3.25 + 3.375
        add1 = 32'hC0800000; // -3.25 in float
        add2 = 32'h40460000; // 3.375 in float
        #20 start = 0;
        #50;
        start = 1;

        #20 $stop;
    end

    always #2 clk = ~clk;

endmodule
