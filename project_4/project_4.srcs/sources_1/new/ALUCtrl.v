`include "Defines.vh"

module ALUCtrl (
    input  [1:0] alu_op,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output [3:0] alu_ctrl
);
  // alu_op
  //
  // `define ALU_ADD  4'd0
  // `define ALU_SUB  4'd1
  // `define ALU_SLL  4'd2
  // `define ALU_SLT  4'd3
  // `define ALU_SLTU 4'd4
  // `define ALU_XOR  4'd5
  // `define ALU_SRL  4'd6
  // `define ALU_SRA  4'd7
  // `define ALU_OR   4'd8
  // `define ALU_AND  4'd9


  // `define CMP_EQ  3'd0
  // `define CMP_NE  3'd1
  // `define CMP_LT  3'd2
  // `define CMP_LTU 3'd3
  // `define CMP_GE  3'd4
  // `define CMP_GEU 3'd5

  wire [3:0] op3_00;
  wire [3:0] op3_00_7_all_zero;
  wire [3:0] op3_00_7_0100000;
  wire [3:0] op3_01;
  wire [3:0] op3_10;
  wire [3:0] op3_10_7_all_zero;
  wire [3:0] op3_10_7_0100000;
  wire [3:0] op3_11;

  // I-type (00): addi, slti, sltiu, xori, ori, andi, slli, srli, srai
  assign op3_00_7_all_zero = (funct3 == 3'b000) ? `ALU_ADD
    : (funct3 == 3'b001) ? `ALU_SLL
    : (funct3 == 3'b010) ? `ALU_SLT
    : (funct3 == 3'b011) ? `ALU_SLTU
    : (funct3 == 3'b100) ? `ALU_XOR
    : (funct3 == 3'b101) ? `ALU_SRL
    : (funct3 == 3'b110) ? `ALU_OR
    : (funct3 == 3'b111) ? `ALU_AND
    : 4'b0;

  assign op3_00_7_0100000 = (funct3 == 3'b101) ? `ALU_SRA : 4'b0;
  assign op3_00 = (funct7 == 7'b0000000) ? op3_00_7_all_zero
    : (funct7 == 7'b0100000) ? op3_00_7_0100000
    : 4'b0;

  // SB-type (01): beq, bne, bge, bgeu, blt, bltu
  assign op3_01 = (funct3 == 3'b000) ? `CMP_EQ
    : (funct3 == 3'b001) ? `CMP_NE
    : (funct3 == 3'b100) ? `CMP_LT
    : (funct3 == 3'b101) ? `CMP_GE
    : (funct3 == 3'b110) ? `CMP_LTU
    : (funct3 == 3'b111) ? `CMP_GEU
    : 4'b0;

  // R-type (10): add, sub, sll, slt, sltu, xor, srl, sra, or, and
  // U-type (10): lui
  assign op3_10_7_all_zero = (funct3 == 3'b000) ?
    `ALU_ADD
    : (funct3 == 3'b001) ?
    `ALU_SLL
    : (funct3 == 3'b010) ?
    `ALU_SLT
    : (funct3 == 3'b011) ?
    `ALU_SLTU
    : (funct3 == 3'b100) ?
    `ALU_XOR
    : (funct3 == 3'b101) ?
    `ALU_SRL
    : (funct3 == 3'b110) ?
    `ALU_OR
    : (funct3 == 3'b111) ?
    `ALU_AND
    : 4'b0;
  assign op3_10_7_0100000 = (funct3 == 3'b000) ? `ALU_SUB
    : (funct3 == 3'b101) ? `ALU_SRA : 4'b0;
  assign op3_10 = (funct7 == 7'b0000000) ? op3_10_7_all_zero
    : (funct7 == 7'b0100000) ? op3_10_7_0100000
    : 4'b0;

  // S-type (11): sw and lw
  assign op3_11 = (funct3 == 3'b010) ? `ALU_ADD : 4'b0;

  assign alu_ctrl = (alu_op == 2'b00) ? op3_00
    : (alu_op == 2'b01) ? op3_01
    : (alu_op == 2'b10) ? op3_10
    : (alu_op == 2'b11) ? op3_11
    : 4'b0;

endmodule
