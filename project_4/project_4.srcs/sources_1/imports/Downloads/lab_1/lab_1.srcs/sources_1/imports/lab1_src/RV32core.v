`include "Defines.vh"
`timescale 1ns / 1ps


module  RV32core(
        input debug_en,  // debug enable
        input debug_step,  // debug step clock
        input [6:0] debug_addr,  // debug address
        output[31:0] debug_data,  // debug data
        input clk,  // main clock
        input rst,  // synchronous reset
        input led_clk,

        input sw, // interrupt signal

        output [6:0] seg_ca,
        output [7:0] AN,
        output[31:0] pc,
        output[31:0] inst,
        output[31:0] mem_addr,
        output[31:0] mem_data
    );

    wire debug_clk;

    debug_clk clock(.clk(clk),.debug_en(debug_en),.debug_step(debug_step),.debug_clk(debug_clk));

    // CPU 
    wire [31:0] imem_addr;
    wire [31:0] imem_o_data;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_o_data;
    wire [31:0] dmem_i_data;
    wire [31:0] dmem_wen;

    // IO
    wire dr_wen;
    wire [31:0] dr_i_data;
    wire [31:0] dr_o_data;

    // Mem

    // Imem
    wire [31:0] i_addr;
    wire [31:0] i_data;
    // Dmem
    wire d_wen;
    wire [31:0] d_addr;
    wire [31:0] d_i_data;
    wire [31:0] d_o_data;

    `RegFile_DBG_Declaration
    `Core_DBG_Declarations



    Core core(
        `Core_DBG_Arguments
        .clk(debug_clk),
        .rst(rst),
        .imem_addr(imem_addr),
        .imem_o_data(imem_o_data),
        .dmem_addr(dmem_addr),
        .dmem_o_data(dmem_o_data),
        .dmem_i_data(dmem_i_data),
        .dmem_wen(dmem_wen)
    );

    Mem mem(
        .i_addr(i_addr),
        .i_data(i_data),
        .clk(~debug_clk),
        .d_wen(d_wen),
        .d_addr(d_addr),
        .d_i_data(d_i_data),
        .d_o_data(d_o_data)
    );

    

    MACtrl memacc(
        //facing core
        .i_iaddr(imem_addr),
        .o_idata(imem_o_data),
        .i_dwen(dmem_wen),
        .i_daddr(dmem_addr),
        .i_d_idata(dmem_i_data),
        .o_d_odata(dmem_o_data),
        //facing IMem
        .o_iaddr(i_addr),
        .i_idata(i_data),
        //facing DMem
        .o_dwen(d_wen),
        .o_daddr(d_addr),
        .o_d_idata(d_i_data),
        .i_d_odata(d_o_data),
        //facing DR
        .o_drwen(dr_wen),
        .o_dr_idata(dr_i_data),
        .i_dr_odata(dr_o_data)
    );

    DispNum dr(
        .clk(led_clk),
        .rst(rst),
        .wen(dr_wen),
        .i_data(dr_i_data),
        .o_data(dr_o_data),
        .Segments(seg_ca),
        .AN(AN)
    );

    `RV32core_DBG_Assignments

endmodule
