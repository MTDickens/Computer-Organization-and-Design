`include "Defines.vh"
`timescale 1ns / 1ps

/**
* ???????????????????
*/

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

  /**
  * Begin of Pipeline Registers Wires
  */

  // ID WIRE
  wire [31:0] pc_id;
  wire [31:0] inst_id;
  wire [31:0] pc_plus_4_id;

  // EX WIRE
  wire [31:0] pc_ex;
  wire [31:0] pc_plus_4_ex;
  wire [31:0] immed_ex;
  wire [4:0] rs1_ex;
  wire [4:0] rs2_ex;
  wire [4:0] rd_ex;
  wire [31:0] rs1_val_ex;
  wire [31:0] rs2_val_ex;
  wire alu_src_ex;
  wire [1:0] mem_to_reg_ex;
  wire reg_write_ex;
  wire mem_write_ex;
  wire branch_ex;
  wire [1:0] jump_ex;
  wire [1:0] alu_op_ex;
  wire [2:0] funct3_ex;
  wire [6:0] funct7_ex;

  // MEM WIRE
  wire [4:0] rd_mem;
  wire [31:0] alu_result_mem;
  wire [31:0] pc_immed_mem;
  wire [31:0] pc_plus_4_mem;
  wire [31:0] rs2_val_mem;
  wire [1:0] mem_to_reg_mem;
  wire reg_write_mem;
  wire mem_write_mem;
  wire mem_read_mem;

  // WB WIRE
  wire [4:0] rd_wb;
  wire [31:0] alu_result_wb;
  wire [31:0] pc_immed_wb;
  wire [31:0] pc_plus_4_wb;
  wire [31:0] dmem_o_data_wb;
  wire [1:0] mem_to_reg_wb;
  wire reg_write_wb;

  /**
  * End of Pipeline Registers Wires
  */

  /**
  * Begin of Pipeline Registers
  */
  IF_ID_REG if_id1 (
      .clk(clk),
      .rst(rst),
      .stall(stall_id),
      .flush(flush_id),

      .pc_if(pc),
      .pc_plus_4_if(pc_plus_4),
      .inst_if(imem_o_data),
      .pc_id(pc_id),
      .inst_id(inst_id),
      .pc_plus_4_id(pc_plus_4_id)
  );

  ID_EX_REG id_ex1 (
      .clk(clk),
      .rst(rst),
      .stall(1'b0),
      .flush(flush_ex),

      .pc_id(pc_id),
      .pc_plus_4_id(pc_plus_4_id),
      .pc_ex(pc_ex),
      .pc_plus_4_ex(pc_plus_4_ex),

      .immed_id(immed),
      .rs1_id(rs1),
      .rs2_id(rs2),
      .rd_id(rd),
      .rs1_val_id(rs1_val_forwarded),
      .rs2_val_id(rs2_val_forwarded),
      .funct3_id(funct3),
      .funct7_id(funct7),
      .alu_src_id(alu_src),
      .mem_to_reg_id(mem_to_reg),
      .reg_write_id(reg_write),
      .mem_write_id(mem_write),
      .mem_read_id(mem_read),
      .branch_id(branch),
      .jump_id(jump),
      .alu_op_id(alu_op),

      .immed_ex(immed_ex),
      .rs1_ex(rs1_ex),
      .rs2_ex(rs2_ex),
      .rd_ex(rd_ex),
      .rs1_val_ex(rs1_val_ex), // Note: maybe need to be changed after adding forwarding
      .rs2_val_ex(rs2_val_ex), // Note: maybe need to be changed after adding forwarding
      .funct3_ex(funct3_ex),
      .funct7_ex(funct7_ex),
      .alu_src_ex(alu_src_ex),
      .mem_to_reg_ex(mem_to_reg_ex),
      .reg_write_ex(reg_write_ex),
      .mem_write_ex(mem_write_ex),
      .mem_read_ex(mem_read_ex),
      .branch_ex(branch_ex),
      .jump_ex(jump_ex),
      .alu_op_ex(alu_op_ex)
  );

  EX_MEM_REG ex_mem1 (
      .clk(clk),
      .rst(rst),
      .stall(1'b0),
      .flush(1'b0),

      .rd_ex(rd_ex),
      .alu_result_ex(alu_result),
      .pc_immed_ex(pc_immed),
      .pc_plus_4_ex(pc_plus_4_ex),
      .rd_mem(rd_mem),
      .alu_result_mem(alu_result_mem),
      .pc_immed_mem(pc_immed_mem),
      .pc_plus_4_mem(pc_plus_4_mem),

      .rs2_val_ex(rs2_val_ex), // Note: this change is due to forwarding
      .rs2_val_mem(rs2_val_mem),

      .mem_to_reg_ex(mem_to_reg_ex),
      .reg_write_ex(reg_write_ex),
      .mem_write_ex(mem_write_ex),
      .mem_read_ex(mem_read_ex),
      .mem_to_reg_mem(mem_to_reg_mem),
      .reg_write_mem(reg_write_mem),
      .mem_write_mem(mem_write_mem),
      .mem_read_mem(mem_read_mem)
  );

  MEM_WB_REG mem_wb1 (
      .clk(clk),
      .rst(rst),
      .stall(1'b0),
      .flush(1'b0),

      .rd_mem(rd_mem),
      .pc_immed_mem(pc_immed_mem),
      .pc_plus_4_mem(pc_plus_4_mem),
      .rd_wb(rd_wb),
      .pc_immed_wb(pc_immed_wb),
      .pc_plus_4_wb(pc_plus_4_wb),

      .alu_result_mem(alu_result_mem),
      .dmem_o_data_mem(dmem_o_data),
      .alu_result_wb(alu_result_wb),
      .dmem_o_data_wb(dmem_o_data_wb),

      .mem_to_reg_mem(mem_to_reg_mem),
      .reg_write_mem(reg_write_mem),
      .mem_read_mem(mem_read_mem),
      .mem_to_reg_wb(mem_to_reg_wb),
      .reg_write_wb(reg_write_wb),
      .mem_read_wb(mem_read_wb)
  );
  /**
  * End of Pipeline Registers
  */



  // Program Counter
  reg  [31:0] pc;
  wire [31:0] pc_plus_4;
  wire [31:0] pc_immed;
  //// Assignment is placed at the END OF THE MODULE

  // Instruction
  wire [31:0] inst;

  // Decomposition of Instruction
  wire [ 4:0] rs1;
  wire [ 4:0] rs2;
  wire [ 4:0] rd;
  wire [ 2:0] funct3;
  wire [ 6:0] funct7;
  wire [ 6:0] opcode;
  wire [31:7] non_opcode;

  assign inst = inst_id;
  assign rs1 = inst_id[19:15];
  assign rs2 = inst_id[24:20];
  assign rd = inst_id[11:7];
  assign funct3 = inst_id[14:12];
  assign funct7 = inst_id[31:25];
  assign opcode = inst_id[6:0];
  assign non_opcode = inst_id[31:7];

  // Control Signals
  wire alu_src;
  wire [1:0] mem_to_reg;
  wire reg_write;
  wire mem_write;
  wire branch;
  wire [1:0] jump;
  wire [1:0] alu_op;
  wire reg_rs1_read;
  wire reg_rs2_read;

  // Controls
  CtrlUnit ctrl1 (
      .opcode(opcode),
      .alu_src(alu_src),
      .mem_to_reg(mem_to_reg),
      .reg_write(reg_write),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .branch(branch),
      .jump(jump),
      .alu_op(alu_op),
      .reg_rs1_read(reg_rs1_read),
      .reg_rs2_read(reg_rs2_read)
  );

  wire [3:0] alu_ctrl;

  ALUCtrl ctrl2 (
      .alu_op(alu_op_ex), .funct3(funct3_ex), .funct7(funct7_ex), .alu_ctrl(alu_ctrl)
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

  wire [31:0] rs1_val;
  wire [31:0] rs2_val;

  RegFile reg1 (
      `RegFile_DBG_Arguments
      .clk(clk),
      .rst(rst),
      .wen(reg_write_wb),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd_wb),
      .i_data(reg_file_mux_out_wb),
      .rs1_val(rs1_val),
      .rs2_val(rs2_val)
  );

  /**
  *
  *
  * Begin Forwarding Module
  *
  *
   */

  // Forwarding Unit
  wire [1:0] forward_rs1_mux;
  wire [1:0] forward_rs2_mux;
  ForwardingUnit forward1 (
      .rs1_id(rs1),
      .rs2_id(rs2),
      .rd_ex(rd_ex),
      .rd_mem(rd_mem),
      .reg_write_ex(reg_write_ex),
      .reg_write_mem(reg_write_mem),
      .forward_rs1_mux(forward_rs1_mux),
      .forward_rs2_mux(forward_rs2_mux)
  );

  // Forwarding Mux

  wire [31:0] rs1_val_forwarded;
  wire [31:0] rs2_val_forwarded;

  /**
    * ? forward: 00
    * ? ex forward: 01
    * ? mem forward: 10
    */
  wire [31:0] reg_file_mux_out_ex;
  assign reg_file_mux_out_ex = (mem_to_reg_ex == 2'b00) ? alu_result:
                            (mem_to_reg_ex == 2'b01) ? 32'h01919810: // This shouldn't occur and should be dealt with by stalling
                            (mem_to_reg_ex == 2'b10) ? pc_plus_4_ex:
                            pc_immed;
  wire [31:0] reg_file_mux_out_mem;
  assign reg_file_mux_out_mem = (mem_to_reg_mem == 2'b00) ? alu_result_mem:
                            (mem_to_reg_mem == 2'b01) ? dmem_o_data: // dmem_o_data := dmem_o_data_mem
                            (mem_to_reg_mem == 2'b10) ? pc_plus_4_mem:
                            pc_immed_mem;
  assign rs1_val_forwarded = (forward_rs1_mux == 2'b01) ? reg_file_mux_out_ex:
                            (forward_rs1_mux == 2'b10) ? reg_file_mux_out_mem:
                            rs1_val;
  assign rs2_val_forwarded = (forward_rs2_mux == 2'b01) ? reg_file_mux_out_ex:
                            (forward_rs2_mux == 2'b10) ? reg_file_mux_out_mem:
                            rs2_val;
  wire [31:0] reg_file_mux_out_wb;
    assign reg_file_mux_out_wb = (mem_to_reg_wb == 2'b00) ? alu_result_wb:
                                (mem_to_reg_wb == 2'b01) ? dmem_o_data_wb: // dmem_o_data := dmem_o_data_mem
                                (mem_to_reg_wb == 2'b10) ? pc_plus_4_wb:
                                pc_immed_wb;

  /**
  *
  *
  * End Forwarding Module
  *
  *
   */

  /**
  *
  *
  * Begin Stall Controller
  *
  *
   */

  wire stall_if;
  wire stall_id;
  wire flush_ex;
  StallController stall1 (
      .reg_rs1_read(reg_rs1_read),
      .reg_rs2_read(reg_rs2_read),
      .mem_read_ex(mem_read_ex),
      .reg_write_ex(reg_write_ex),
      .rs1_id(rs1),
      .rs2_id(rs2),
      .rd_ex(rd_ex),
      .stall_if(stall_if),
      .stall_id(stall_id)
  );


  /**
  *
  *
  * End Stall Controller
  *
  *
   */

  /**
  *
  *
  * Begin Predict Not Taken
  *
  *
   */

  wire flush_by_prediction;
  wire flush_id;
  PredictionUnit pred1 (
      .pc_plus_4_ex(pc_plus_4_ex),
      .branch_mux_choose(branch_mux_choose),
      .jump_ex(jump_ex),
      .jump_mux_out(jump_mux_out),
      .flush(flush_by_prediction)
  );

  assign flush_ex = stall_id || flush_by_prediction;
  assign flush_id = flush_by_prediction;

  /**
  *
  *
  * End Predict Not Taken
  *
  *
   */

  // ALU assign
  assign a_val = rs1_val_ex;

  // ALU mux
  assign b_val = (alu_src_ex) ? immed_ex : rs2_val_ex;

  Alu alu1(
      .a_val(a_val), .b_val(b_val), .ctrl(alu_ctrl), .result(alu_result)
  );


  // Comparator

  wire compare_result;
  wire branch_mux_choose;

  Comparator comp1(
      .a_val(a_val), .b_val(b_val), .ctrl(alu_ctrl[2:0]), .result(compare_result)
  );

  assign branch_mux_choose = compare_result & branch_ex;

  // Branch mux
  wire [31:0] branch_mux_out;
  assign branch_mux_out = (branch_mux_choose ? pc_immed : pc_plus_4_ex);

  // Jump mux
  wire [31:0] jump_mux_out;
  assign jump_mux_out = (jump_ex == 2'b00) ? branch_mux_out : (jump_ex == 2'b01) ? pc_immed : alu_result;

  // Assign Outputs
  assign imem_addr = pc;
  assign dmem_addr = alu_result_mem;
  assign dmem_i_data = rs2_val_mem;
  assign dmem_wen = mem_write_mem;

  // Assignment pc
  assign pc_plus_4 = pc + 4; 
  assign pc_immed = pc_ex + immed_ex; // PC adder

  // Updating PC
  always @(posedge clk) begin
    if (rst) begin
      pc <= 0;
    end else if (stall_if) begin // If stall, pc remains the same
      // Do nothing
    end else begin
      pc <= flush_by_prediction ? jump_mux_out : pc_plus_4;
    end
  end

  // DEBUG
  `Arith_DBG_Assignments
  `Core_DBG_Assignment

endmodule
