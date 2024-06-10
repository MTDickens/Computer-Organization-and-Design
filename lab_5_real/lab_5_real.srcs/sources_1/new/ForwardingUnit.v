`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/04 23:53:26
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit (
    input wire [4:0] rs1_id,
    input wire [4:0] rs2_id,
    input wire [4:0] rd_ex,
    input wire [4:0] rd_mem,
    input wire reg_write_ex,
    input wire reg_write_mem,
    output wire [1:0] forward_rs1_mux,
    output wire [1:0] forward_rs2_mux
);

  /**
    * 写入条件（以 rs1 和 rd_ex 为例）：
    * 1. 首先，rs1 = rd_ex，且均不等于 x0
    * 2. 其次，reg_write_ex 为真
    */

  /**
    * 不 forward: 00
    * 从 ex forward: 01
    * 从 mem forward: 10
    */

  // Forwarding rs1
  assign is_rs1_ex = rs1_id == rd_ex && rs1_id != 5'b00000 && reg_write_ex;
  assign is_rs1_mem = rs1_id == rd_mem && rs1_id != 5'b00000 && reg_write_mem;
  assign forward_rs1_mux = is_rs1_ex ? 2'b01 : (is_rs1_mem ? 2'b10 : 2'b00);

  // Forwarding rs2
  assign is_rs2_ex = rs2_id == rd_ex && rs2_id != 5'b00000 && reg_write_ex;
  assign is_rs2_mem = rs2_id == rd_mem && rs2_id != 5'b00000 && reg_write_mem;
  assign forward_rs2_mux = is_rs2_ex ? 2'b01 : (is_rs2_mem ? 2'b10 : 2'b00);

endmodule
