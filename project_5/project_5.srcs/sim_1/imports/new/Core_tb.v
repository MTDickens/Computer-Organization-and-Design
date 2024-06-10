`timescale 1ns / 1ps

// module Mem(
// //for IMem
//   input [31:0]i_addr,
//   output [31:0]i_data,
//  //for DMem
//   input clk,
//   input d_wen,
//   input [31:0]d_addr,
//   input [31:0]d_i_data,
//   output [31:0]d_o_data
//     );


module Core_tb ();
  // Declare signals
  reg clk, rst;
  wire [31:0] imem_addr, dmem_addr, dmem_i_data;
  wire dmem_wen_final;
  wire dmem_ren;
  wire [31:0] imem_o_data, dmem_o_data;
  reg sw;

  // Instantiate Core
  Core u1 (
      .clk(clk),
      .rst(rst),
      .imem_addr(imem_addr),
      .imem_o_data(imem_o_data),
      .dmem_addr(dmem_addr),
      .dmem_o_data(dmem_o_data),
      .dmem_i_data(dmem_i_data),
      .dmem_wen_final(dmem_wen_final),
      .dmem_ren(dmem_ren),
      .sw(sw)
  );

  // Instantiate Mem
  Mem u2 (
      .i_addr(imem_addr),
      .i_data(imem_o_data),
      .clk(clk),
      .d_wen(dmem_wen_final),
      .d_addr(dmem_addr),
      .d_i_data(dmem_i_data),
      .d_o_data(dmem_o_data)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #2 clk = ~clk;
  end

  // Reset signal
  initial begin
    sw  = 0;
    rst = 1;
    #10 rst = 0;
    #440 sw = 1;
    #10 sw = 0;
  end

  //   // Testbench logic
  //   initial begin
  //     // Add your test cases here
  //   end
endmodule
