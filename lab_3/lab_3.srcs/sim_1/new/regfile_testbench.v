`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/06 00:12:33
// Design Name: 
// Module Name: regfile_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile_testbench;

    // Clock
    reg clk;
    always #5 clk = ~clk;
    
    // Arguments
    
    reg rst;
    reg reg_wen;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] reg_i_data;
    wire [31:0] rs1_val;
    wire [31:0] rs2_val;
    
    RegFile reg_file(
        `RegFile_DBG_Arguments
        .clk(~clk),
        .rst(rst),
        .wen(reg_wen),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .i_data(reg_i_data),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val)
    );
    
    initial begin
        clk = 0;
        rst = 1;
        reg_wen = 0;
        rs1 = 0;
        rs2 = 0;
        reg_i_data = 0;
        rd = 0;        
        #5;
        rst = 0;
        reg_wen = 1;
        rd = 5'd12;
        reg_i_data = 114514;
        #10;
        reg_wen = 1;
        rd = 5'd15;
        reg_i_data = 1919810;
        #10;
        reg_wen = 0;
        rs1 = 12;
        rs2 = 15;
        #10;
        reg_wen = 1;
        rd = 5'd0;
        reg_i_data= 49824982;
        #10;
        reg_wen = 0;
        rs1 = 0; 
        rs2 = 0;
        #10;
        $finish;
    end
    
endmodule
