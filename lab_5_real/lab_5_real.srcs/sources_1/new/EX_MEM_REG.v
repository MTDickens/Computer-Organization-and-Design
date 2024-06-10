`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/04 19:29:33
// Design Name: 
// Module Name: EX_MEM_REG
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


module EX_MEM_REG (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,

    input  wire [ 4:0] rd_ex,
    input  wire [31:0] pc_plus_4_ex,
    output wire [ 4:0] rd_mem,
    output wire [31:0] pc_plus_4_mem,

    /**
    * new data in this stage
    */
    input  wire [31:0] alu_result_ex,
    input  wire [31:0] pc_immed_ex,
    output wire [31:0] alu_result_mem,
    output wire [31:0] pc_immed_mem,

    input  wire [31:0] rs2_val_ex,
    output wire [31:0] rs2_val_mem,

    /**
    * Control signals
    */
    input [1:0] mem_to_reg_ex,
    input reg_write_ex,
    input mem_write_ex,
    input mem_read_ex,
    output [1:0] mem_to_reg_mem,
    output reg_write_mem,
    output mem_write_mem,
    output mem_read_mem
);

  // Registers
  reg [4:0] rd_mem_reg;
  reg [31:0] pc_plus_4_mem_reg;
  reg [31:0] alu_result_mem_reg;
  reg [31:0] pc_immed_mem_reg;
  reg [31:0] rs2_val_mem_reg;
  reg [1:0] mem_to_reg_mem_reg;
  reg reg_write_mem_reg;
  reg mem_write_mem_reg;
  reg mem_read_mem_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      rd_mem_reg <= 5'b0;
      pc_plus_4_mem_reg <= 32'b0;
      alu_result_mem_reg <= 32'b0;
      pc_immed_mem_reg <= 32'b0;
      rs2_val_mem_reg <= 32'b0;
      mem_to_reg_mem_reg <= 2'b0;
      reg_write_mem_reg <= 1'b0;
      mem_write_mem_reg <= 1'b0;
      mem_read_mem_reg <= 1'b0;
    end else if (stall) begin
      // Do nothing
    end else if (flush) begin
      rd_mem_reg <= 5'b0;
      pc_plus_4_mem_reg <= 32'b0;
      alu_result_mem_reg <= 32'b0;
      pc_immed_mem_reg <= 32'b0;
      rs2_val_mem_reg <= 32'b0;
      mem_to_reg_mem_reg <= 2'b0;
      reg_write_mem_reg <= 1'b0;
      mem_write_mem_reg <= 1'b0;
      mem_read_mem_reg <= 1'b0;
    end else begin
      rd_mem_reg <= rd_ex;
      pc_plus_4_mem_reg <= pc_plus_4_ex;
      alu_result_mem_reg <= alu_result_ex;
      pc_immed_mem_reg <= pc_immed_ex;
      rs2_val_mem_reg <= rs2_val_ex;
      mem_to_reg_mem_reg <= mem_to_reg_ex;
      reg_write_mem_reg <= reg_write_ex;
      mem_write_mem_reg <= mem_write_ex;
      mem_read_mem_reg <= mem_read_ex;
    end
  end

  assign rd_mem = rd_mem_reg;
  assign pc_plus_4_mem = pc_plus_4_mem_reg;
  assign alu_result_mem = alu_result_mem_reg;
  assign pc_immed_mem = pc_immed_mem_reg;
  assign rs2_val_mem = rs2_val_mem_reg;
  assign mem_to_reg_mem = mem_to_reg_mem_reg;
  assign reg_write_mem = reg_write_mem_reg;
  assign mem_write_mem = mem_write_mem_reg;
  assign mem_read_mem = mem_read_mem_reg;

endmodule
