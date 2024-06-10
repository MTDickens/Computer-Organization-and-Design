`timescale 1ns / 1ps

module ImmedGen (
    input  [ 6:0] opcode,
    input  [31:7] non_opcode,
    output [31:0] immed
);

  // Commands:
  // lw, sw
  // beq, bne bge, bgeu, blt, bltu
  // addi, slti, sltiu, xori, ori, andi, slli, srli, srai
  // add, sub, sll, slt, sltu, xor, srl, sra, or, and
  // lui, auipc, jal, jalr
  //
  // R-type: 0110011 ($arith$)
  // I-type: 0000011 (lw), 0010011 ($arith-immed$), 1100111 (jalr)
  // S-type: 0100011 (sw)
  // SB-type: 1100011 (b*)
  // U-type: 0110111 (lui), 0010111 (auipc)
  // UJ-type: 1101111 (jal)

  assign immed = (opcode == 7'b0000011 || opcode == 7'b0010011 || opcode == 7'b1100111) ? {{20{non_opcode[31]}}, non_opcode[31:20]} // I-type
      : (opcode == 7'b0100011) ? {{20{non_opcode[31]}}, non_opcode[31:25], non_opcode[11:7]} // S-type
      : (opcode == 7'b1100011) ? {{19{non_opcode[31]}}, non_opcode[31], non_opcode[7], non_opcode[30:25], non_opcode[11:8], 1'b0} // SB-type
      : (opcode == 7'b0110111 || opcode == 7'b0010111) ? {non_opcode[31:12], 12'b0000_0000_0000} // U-type 
      : (opcode == 7'b1101111) ? {{11{non_opcode[31]}}, non_opcode[31], non_opcode[19:12], non_opcode[20], non_opcode[30:21], 1'b0} // UJ-type
      : 32'b0;

endmodule

