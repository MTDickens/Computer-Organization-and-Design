`timescale 1ns / 1ps

module MEM_WB_REG (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,

    input  wire [ 4:0] rd_mem,
    input  wire [31:0] pc_immed_mem,
    input  wire [31:0] pc_plus_4_mem,
    output wire [ 4:0] rd_wb,
    output wire [31:0] pc_immed_wb,
    output wire [31:0] pc_plus_4_wb,

    /**
    * New data in this stage
    */
    input  wire [31:0] alu_result_mem,
    input  wire [31:0] dmem_o_data_mem,
    output wire [31:0] alu_result_wb,
    output wire [31:0] dmem_o_data_wb,

    /**
    * Control signals
    */
    input [1:0] mem_to_reg_mem,
    input reg_write_mem,
    input mem_write_mem,
    input mem_read_mem,
    output [1:0] mem_to_reg_wb,
    output reg_write_wb,
    output mem_write_wb,
    output mem_read_wb
);

  // Registers
  reg [4:0] rd_wb_reg;
  reg [31:0] pc_immed_wb_reg;
  reg [31:0] pc_plus_4_wb_reg;
  reg [31:0] alu_result_wb_reg;
  reg [31:0] dmem_o_data_wb_reg;
  reg [1:0] mem_to_reg_wb_reg;
  reg reg_write_wb_reg;
  reg mem_write_wb_reg;
  reg mem_read_wb_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      rd_wb_reg <= 5'b0;
      pc_immed_wb_reg <= 32'b0;
      pc_plus_4_wb_reg <= 32'b0;
      alu_result_wb_reg <= 32'b0;
      dmem_o_data_wb_reg <= 32'b0;
      mem_to_reg_wb_reg <= 2'b0;
      reg_write_wb_reg <= 1'b0;
      mem_write_wb_reg <= 1'b0;
      mem_read_wb_reg <= 1'b0;
    end else if (stall) begin
      // Do nothing
    end else if (flush) begin
      rd_wb_reg <= 5'b0;
      pc_immed_wb_reg <= 32'b0;
      pc_plus_4_wb_reg <= 32'b0;
      alu_result_wb_reg <= 32'b0;
      dmem_o_data_wb_reg <= 32'b0;
      mem_to_reg_wb_reg <= 2'b0;
      reg_write_wb_reg <= 1'b0;
      mem_write_wb_reg <= 1'b0;
      mem_read_wb_reg <= 1'b0;
    end else begin
      rd_wb_reg <= rd_mem;
      pc_immed_wb_reg <= pc_immed_mem;
      pc_plus_4_wb_reg <= pc_plus_4_mem;
      alu_result_wb_reg <= alu_result_mem;
      dmem_o_data_wb_reg <= dmem_o_data_mem;
      mem_to_reg_wb_reg <= mem_to_reg_mem;
      reg_write_wb_reg <= reg_write_mem;
      mem_write_wb_reg <= mem_write_mem;
      mem_read_wb_reg <= mem_read_mem;
    end
  end

  assign rd_wb = rd_wb_reg;
  assign pc_immed_wb = pc_immed_wb_reg;
  assign pc_plus_4_wb = pc_plus_4_wb_reg;
  assign alu_result_wb = alu_result_wb_reg;
  assign dmem_o_data_wb = dmem_o_data_wb_reg;
  assign mem_to_reg_wb = mem_to_reg_wb_reg;
  assign reg_write_wb = reg_write_wb_reg;
  assign mem_write_wb = mem_write_wb_reg;
  assign mem_read_wb = mem_read_wb_reg;

endmodule
