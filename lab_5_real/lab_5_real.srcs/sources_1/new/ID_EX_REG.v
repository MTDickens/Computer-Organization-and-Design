`timescale 1ns / 1ps

module ID_EX_REG (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,

    input  wire [31:0] pc_id,
    input  wire [31:0] pc_plus_4_id,
    output wire [31:0] pc_ex,
    output wire [31:0] pc_plus_4_ex,

    /**
    * New data in this stage
    */
    input  wire [31:0] immed_id,
    input  wire [ 4:0] rs1_id,
    input  wire [ 4:0] rs2_id,
    input  wire [ 4:0] rd_id,
    input  wire [31:0] rs1_val_id,
    input  wire [31:0] rs2_val_id,
    input  wire [ 2:0] funct3_id,
    input  wire [ 6:0] funct7_id,
    output wire [31:0] immed_ex,
    output wire [ 4:0] rs1_ex,
    output wire [ 4:0] rs2_ex,
    output wire [ 4:0] rd_ex,
    output wire [31:0] rs1_val_ex,
    output wire [31:0] rs2_val_ex,
    output wire [ 2:0] funct3_ex,
    output wire [ 6:0] funct7_ex,

    /**
    * Control signals
    */
    input alu_src_id,
    input [1:0] mem_to_reg_id,
    input reg_write_id,
    input mem_write_id,
    input mem_read_id,
    input branch_id,
    input [1:0] jump_id,
    input [1:0] alu_op_id,
    output alu_src_ex,
    output [1:0] mem_to_reg_ex,
    output reg_write_ex,
    output mem_write_ex,
    output mem_read_ex,
    output branch_ex,
    output [1:0] jump_ex,
    output [1:0] alu_op_ex
);


  // Registers
  reg [31:0] pc_ex_reg;
  reg [31:0] pc_plus_4_ex_reg;
  reg [31:0] immed_ex_reg;
  reg [4:0] rs1_ex_reg;
  reg [4:0] rs2_ex_reg;
  reg [4:0] rd_ex_reg;
  reg [31:0] rs1_val_ex_reg;
  reg [31:0] rs2_val_ex_reg;
  reg [2:0] funct3_ex_reg;
  reg [6:0] funct7_ex_reg;
  reg alu_src_ex_reg;
  reg [1:0] mem_to_reg_ex_reg;
  reg reg_write_ex_reg;
  reg mem_write_ex_reg;
  reg mem_read_ex_reg;
  reg branch_ex_reg;
  reg [1:0] jump_ex_reg;
  reg [1:0] alu_op_ex_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pc_ex_reg <= 32'b0;
      pc_plus_4_ex_reg <= 32'b0;
      immed_ex_reg <= 32'b0;
      rs1_ex_reg <= 5'b0;
      rs2_ex_reg <= 5'b0;
      rd_ex_reg <= 5'b0;
      rs1_val_ex_reg <= 32'b0;
      rs2_val_ex_reg <= 32'b0;
      funct3_ex_reg <= 3'b0;
      funct7_ex_reg <= 7'b0;
      alu_src_ex_reg <= 1'b0;
      mem_to_reg_ex_reg <= 2'b0;
      reg_write_ex_reg <= 1'b0;
      mem_write_ex_reg <= 1'b0;
      mem_read_ex_reg <= 1'b0;
      branch_ex_reg <= 1'b0;
      jump_ex_reg <= 2'b0;
      alu_op_ex_reg <= 2'b0;
    end else if (stall) begin
      // Do nothing
    end else if (flush) begin
      pc_ex_reg <= 32'b0;
      pc_plus_4_ex_reg <= 32'b0;
      immed_ex_reg <= 32'b0;
      rs1_ex_reg <= 5'b0;
      rs2_ex_reg <= 5'b0;
      rd_ex_reg <= 5'b0;
      rs1_val_ex_reg <= 32'b0;
      rs2_val_ex_reg <= 32'b0;
      funct3_ex_reg <= 3'b0;
      funct7_ex_reg <= 7'b0;
      alu_src_ex_reg <= 1'b0;
      mem_to_reg_ex_reg <= 2'b0;
      reg_write_ex_reg <= 1'b0;
      mem_write_ex_reg <= 1'b0;
      mem_read_ex_reg <= 1'b0;
      branch_ex_reg <= 1'b0;
      jump_ex_reg <= 2'b0;
      alu_op_ex_reg <= 2'b0;
    end else begin
      pc_ex_reg <= pc_id;
      pc_plus_4_ex_reg <= pc_plus_4_id;
      immed_ex_reg <= immed_id;
      rs1_ex_reg <= rs1_id;
      rs2_ex_reg <= rs2_id;
      rd_ex_reg <= rd_id;
      rs1_val_ex_reg <= rs1_val_id;
      rs2_val_ex_reg <= rs2_val_id;
      funct3_ex_reg <= funct3_id;
      funct7_ex_reg <= funct7_id;
      alu_src_ex_reg <= alu_src_id;
      mem_to_reg_ex_reg <= mem_to_reg_id;
      reg_write_ex_reg <= reg_write_id;
      mem_write_ex_reg <= mem_write_id;
      mem_read_ex_reg <= mem_read_id;
      branch_ex_reg <= branch_id;
      jump_ex_reg <= jump_id;
      alu_op_ex_reg <= alu_op_id;
    end
  end

  assign pc_ex = pc_ex_reg;
  assign pc_plus_4_ex = pc_plus_4_ex_reg;
  assign immed_ex = immed_ex_reg;
  assign rs1_ex = rs1_ex_reg;
  assign rs2_ex = rs2_ex_reg;
  assign rd_ex = rd_ex_reg;
  assign rs1_val_ex = rs1_val_ex_reg;
  assign rs2_val_ex = rs2_val_ex_reg;
  assign funct3_ex = funct3_ex_reg;
  assign funct7_ex = funct7_ex_reg;
  assign alu_src_ex = alu_src_ex_reg;
  assign mem_to_reg_ex = mem_to_reg_ex_reg;
  assign reg_write_ex = reg_write_ex_reg;
  assign mem_write_ex = mem_write_ex_reg;
  assign mem_read_ex = mem_read_ex_reg;
  assign branch_ex = branch_ex_reg;
  assign jump_ex = jump_ex_reg;
  assign alu_op_ex = alu_op_ex_reg;




endmodule
