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
        input [6:0] seg_ca,
        input [7:0] AN,
        output[31:0] pc,
        output[31:0] inst,
        output[31:0] mem_addr,
        output[31:0] mem_data
	);

	wire debug_clk;

	debug_clk clock(.clk(clk),.debug_en(debug_en),.debug_step(debug_step),.debug_clk(debug_clk));

    wire [31:0] imem_addr;
    wire [31:0] imem_o_data;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_o_data;
    wire [31:0] dmem_i_data;
    wire [31:0] dmem_wen;

    wire dr_wen;
    wire [31:0] dr_i_data;
    wire [31:0] dr_o_data;

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
        .i_addr(imem_addr),
        .i_data(imem_o_data),
        .clk(~debug_clk),
        .d_wen(dmem_wen),
        .d_addr(dmem_addr),
        .d_i_data(dmem_i_data),
        .d_o_data(dmem_o_data)
    );

    

    // MACtrl memacc(
    //     //facing core
    //     .i_iaddr(),
    //     .o_idata(),
    //     .i_dwen(),
    //     .i_daddr(),
    //     .i_d_idata(),
    //     .o_d_odata(),
    //     //facing IMem
    //     .o_iaddr(),
    //     .i_idata(),
    //     //facing DMem
    //     .o_dwen(),
    //     .o_daddr(),
    //     .o_d_idata(),
    //     .i_d_odata(),
    //     //facing DR
    //     .o_drwen(),
    //     .o_dr_idata(),
    //     .i_dr_odata()
    // );

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