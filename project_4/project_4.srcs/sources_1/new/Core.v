`include "Defines.vh"
`timescale 1ns / 1ps

module Core (
    `Core_DBG_Definitions
    `Arith_DBG_Definitions
    input clk,
    input rst,
    output [31:0] imem_addr,
    input [31:0] imem_o_data,
    output [31:0] dmem_addr,
    input [31:0] dmem_o_data,
    output [31:0] dmem_i_data,
    output dmem_wen,
    input sw
);

  // Program Counter
  reg  [31:0] pc;
  wire [31:0] pc_plus_4;
  wire [31:0] pc_immed;
  //// Assignment is placed at the END OF THE MODULE

  // Instruction
  wire [31:0] inst;
  assign inst = imem_o_data;

  // Decomposition of Instruction
  wire [ 4:0] rs1;
  wire [ 4:0] rs2;
  wire [ 4:0] rd;
  wire [ 2:0] funct3;
  wire [ 6:0] funct7;
  wire [ 6:0] opcode;
  wire [31:7] non_opcode;

  assign rs1 = inst[19:15];
  assign rs2 = inst[24:20];
  assign rd = inst[11:7];
  assign funct3 = inst[14:12];
  assign funct7 = inst[31:25];
  assign opcode = inst[6:0];
  assign non_opcode = inst[31:7];

  // Control Signals
  wire alu_src;
  wire [1:0] mem_to_reg;
  wire reg_write;
  wire mem_write;
  wire branch;
  wire [1:0] jump;
  wire [1:0] alu_op;

  // Controls
  CtrlUnit ctrl1 (
      .opcode(opcode),
      .alu_src(alu_src),
      .mem_to_reg(mem_to_reg),
      .reg_write(reg_write),
      .mem_write(mem_write),
      .branch(branch),
      .jump(jump),
      .alu_op(alu_op)
  );

  wire [3:0] alu_ctrl;

  ALUCtrl ctrl2 (
      .alu_op(alu_op), .funct3(funct3), .funct7(funct7), .alu_ctrl(alu_ctrl)
  );

  // ImmedGen
  wire [31:0] immed;
  ImmedGen immed1(
      .opcode(opcode), .non_opcode(non_opcode), .immed(immed)
  );

  // ALU
  wire [31:0] a_val;
  wire [31:0] b_val;
  wire [31:0] alu_result;

  //// ALU assignment is right below Register Files

  // Register Files
  wire [31:0] reg_file_mux_out;
  assign reg_file_mux_out = (mem_to_reg == 2'b00) ? alu_result:
                            (mem_to_reg == 2'b01) ? dmem_o_data:
                            (mem_to_reg == 2'b10) ? pc_plus_4:
                            pc_immed;
  wire [31:0] rs1_val;
  wire [31:0] rs2_val;

  RegFile reg1 (
      `RegFile_DBG_Arguments
      .clk(clk),
      .rst(rst),
      .wen(reg_write),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .i_data(reg_file_mux_out),
      .rs1_val(rs1_val),
      .rs2_val(rs2_val)
  );


  // ALU assign
  assign a_val = rs1_val;

  // ALU mux
  assign b_val = (alu_src) ? immed : rs2_val;

  Alu alu1(
      .a_val(a_val), .b_val(b_val), .ctrl(alu_ctrl), .result(alu_result)
  );


  // Comparator

  wire compare_result;
  wire branch_mux_choose;

  Comparator comp1(
      .a_val(a_val), .b_val(b_val), .ctrl(alu_ctrl[2:0]), .result(compare_result)
  );

  assign branch_mux_choose = compare_result & branch;

  // Branch mux
  wire [31:0] branch_mux_out;
  assign branch_mux_out = (branch_mux_choose ? pc_immed : pc_plus_4);

  // Jump mux
  wire [31:0] jump_mux_out;
  assign jump_mux_out = (jump == 2'b00) ? branch_mux_out : (jump == 2'b01) ? pc_immed : alu_result;

  // Assign Outputs
  assign imem_addr = pc;
  assign dmem_addr = alu_result;
  assign dmem_i_data = rs2_val;
  assign dmem_wen = mem_write;

  // Assignment pc
  assign pc_plus_4 = pc + 4;
  assign pc_immed = pc + immed;

  // Updating PC
  always @(posedge clk) begin
    if (rst) begin
      pc <= 0;
    end else begin
      pc <= (sw) ? pc_plus_4 : jump_mux_out;
    end
  end

  // DEBUG
  `Arith_DBG_Assignments
  `Core_DBG_Assignment

endmodule
