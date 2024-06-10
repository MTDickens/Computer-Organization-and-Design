`include "Defines.vh"

module CtrlUnit (
    input [6:0] opcode,
    input [2:0] funct3,
    output alu_src,
    output [2:0] mem_to_reg,
    output reg_write,
    output mem_write,
    output mem_read,
    output branch,
    output [1:0] jump,
    output [1:0] alu_op,
    // CSR
    output csr_wen,
    output csr_arith_source
);

  assign alu_src = (opcode == `R_TYPE || opcode == `SB_TYPE) ? 1'b0 : 1'b1;
  assign mem_to_reg = (opcode == `R_TYPE || opcode == `I_TYPE_ARITH || opcode == `U_TYPE_LUI) ? 3'b000 :
                      (opcode == `I_TYPE_LOAD) ? 3'b001 :
                      (opcode == `I_TYPE_JALR || opcode == `UJ_TYPE) ? 3'b010 :
                      (opcode == `U_TYPE_AUIPC) ? 3'b011 :
                        3'b100;  // Privileged instructions
  assign reg_write = (opcode == `S_TYPE || opcode == `SB_TYPE) ? 1'b0 : 1'b1;
  assign mem_write = (opcode == `S_TYPE) ? 1'b1 : 1'b0;
  assign mem_read = (opcode == `I_TYPE_LOAD) ? 1'b1 : 1'b0;  // lw
  assign branch = (opcode == `SB_TYPE) ? 1'b1 : 1'b0;
  assign jump = (opcode == `I_TYPE_JALR) ? 2'b10 :
                (opcode == `UJ_TYPE) ? 2'b01 :
                2'b00;  // auipc, PC + immed

  assign alu_op = (opcode == `I_TYPE_JALR) ? 2'b00 :  // jalr
      (opcode == `SB_TYPE) ? 2'b01 :  // SB-type
      (opcode == `R_TYPE || opcode == `I_TYPE_ARITH || opcode == `U_TYPE_LUI) ? 2'b10 :  // R-type, I-type arith and lui
      2'b11;  // lw and sw

  // CSR
  assign csr_wen = (opcode == `I_PRIV & funct3 != 3'b000) ? 1'b1 : 1'b0;
  assign csr_arith_source = funct3[2];
endmodule
