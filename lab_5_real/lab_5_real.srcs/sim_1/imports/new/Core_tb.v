`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/05 16:54:26
// Design Name: 
// Module Name: Core_tb
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

// module Core (
//     `Core_DBG_Definitions
//     input clk,
//     input rst,
//     output [31:0] imem_addr,
//     input [31:0] imem_o_data,
//     output [31:0] dmem_addr,
//     input [31:0] dmem_o_data,
//     output [31:0] dmem_i_data,
//     output dmem_wen,
//     input sw
// );

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
  wire dmem_wen;
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
      .dmem_wen(dmem_wen),
      .sw(sw)
  );

  // Instantiate Mem
  Mem u2 (
      .i_addr(imem_addr),
      .i_data(imem_o_data),
      .clk(clk),
      .d_wen(dmem_wen & (dmem_addr != 32'hFE00_0000)),
      .d_addr(dmem_addr),
      .d_i_data(dmem_i_data),
      .d_o_data(dmem_o_data)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset signal
  initial begin
    sw  = 0;
    rst = 1;
    #10 rst = 0;
  end

  //   // Testbench logic
  //   initial begin
  //     // Add your test cases here
  //   end
endmodule
