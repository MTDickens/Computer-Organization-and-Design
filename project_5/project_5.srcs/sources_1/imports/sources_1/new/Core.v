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
    output dmem_wen_final,
    output dmem_ren, // Don't need to output, for now
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
  wire [2:0] mem_to_reg;
  wire reg_write;
  wire mem_write;
  wire mem_read;
  wire branch;
  wire [1:0] jump;
  wire [1:0] alu_op;

  // Controls
  CtrlUnit ctrl1 (
      .opcode(opcode),
      .funct3(funct3),
      .alu_src(alu_src),
      .mem_to_reg(mem_to_reg),
      .reg_write(reg_write),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .branch(branch),
      .jump(jump),
      .alu_op(alu_op),
      // CSR
      .csr_wen(csr_wen),
      .csr_arith_source(csr_arith_source)
  );

  wire [3:0] alu_ctrl;
  wire [1:0] csr_alu_ctrl; // CSR

  ALUCtrl ctrl2 (
      .alu_op(alu_op),
      .funct3(funct3),
      .funct7(funct7),
      .alu_ctrl(alu_ctrl),
      .csr_alu_ctrl(csr_alu_ctrl)
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
  assign reg_file_mux_out = (mem_to_reg == 3'b000) ? alu_result:
                            (mem_to_reg == 3'b001) ? dmem_o_data:
                            (mem_to_reg == 3'b010) ? pc_plus_4:
                            (mem_to_reg == 3'b011) ? pc_immed:
                            (mem_to_reg == 3'b100) ? csr_val :
                            32'b0;
  wire [31:0] rs1_val;
  wire [31:0] rs2_val;

  wire reg_wen_final;
  assign reg_wen_final = reg_write & ~except_final;

  RegFile reg1 (
      `RegFile_DBG_Arguments
      .clk(clk),
      .rst(rst),
      .wen(reg_wen_final),
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
  wire dmem_wen;
  wire dmem_wen_final;

  assign imem_addr = pc;
  assign dmem_addr = alu_result;
  assign dmem_i_data = rs2_val;
  assign dmem_wen = mem_write;
  assign dmem_wen_final = dmem_wen & ~except_final;
  assign dmem_ren = mem_read;

  // Assignment pc
  assign pc_plus_4 = pc + 4;
  assign pc_immed = pc + immed;

  // Updating PC
  wire mret_or_except_final;
  assign mret_or_except_final = is_mret | except_final;
  always @(posedge clk) begin
    if (rst) begin
      pc <= 0;
    end else begin
      pc <= (mret_or_except_final) ? write_pc : jump_mux_out;
    end
  end

  // DEBUG
  `Arith_DBG_Assignments
  `Core_DBG_Assignment

  ////
  //// CSR
  ////
  wire is_mret;
  assign is_mret = (inst == `MRET_INST);

  /// CSR muxes
  wire [31:0] csr_arith_result;
  wire [31:0] csr_alu_result;
  wire csr_arith_source;

  assign csr_arith_result = (csr_arith_source) ? immed : rs1_val;

  // Except_gen
  wire io_int;
  wire is_unalign;
  wire bj_unalign;
  wire illegal_op;
  wire is_ecall;
  wire except;
  wire except_final;

  assign io_int = sw;
  assign is_unalign = (|dmem_addr[1:0]) & (dmem_wen | dmem_ren);
  assign bj_unalign = (|alu_result[1:0] & (|jump)) | ((|pc_immed[1:0]) & branch) ;
  assign illegal_op = (inst == 32'h0xffffffff);
  assign is_ecall = (inst == `ECALL_INST);
  Exception_ctrl exception_ctrl (
      .io_int(io_int),
      .is_unalign(is_unalign),
      .bj_unalign(bj_unalign),
      .illegal_op(illegal_op),
      .is_ecall(is_ecall),
      .inst(inst),
      .dmem_addr(dmem_addr),
      .bj_unalign_mtval(branch ? pc_immed : alu_result),
      .except(except),
      .error_info(error_info),
      .error_id(error_id)
  );

  // Control and Status Register (CSR) Files
  // The opcode of all CSR instructions is "111 0011"
  wire [31:0] csr_val;
  wire csr_wen;
  wire [31:0] write_pc;
  wire [11:0] csr;
  wire [31:0] csr_i_data;
  wire [31:0] error_id;
  wire [31:0] error_info;

  assign csr = inst[31:20];
  assign csr_i_data = csr_arith_result;

  CSRFile csr1 (
      .clk(clk),
      .rst(rst),
      .wen(csr_wen),
      .except(except),
      .is_mret(is_mret),
      .csr(csr),
      .i_data(csr_i_data),
      .pc(pc),
      .error_info(error_info),
      .error_id(error_id),
      .except_final(except_final),
      .csr_val(csr_val),
      .write_pc(write_pc)
  );

  // CSR_ALU

  CSR_ALU  csr_alu1 (
      .csr_val(csr_val),
      .other_val(csr_arith_result),
      .ctrl(csr_alu_ctrl),
      .result(csr_alu_result)
  );

endmodule
