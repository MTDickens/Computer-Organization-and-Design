`include "Defines.vh"

module CtrlUnit (
    input [6:0] opcode,
    output alu_src,  // EX
    output [1:0] mem_to_reg,  // WB
    output reg_write,  // WB
    output mem_write,  // MEM
    output mem_read,  // WB
    output branch,  // EX
    output [1:0] jump,  // EX
    output [1:0] alu_op,  // EX
    output reg_rs1_read,  // ID
    output reg_rs2_read  // ID
);

  assign alu_src = (opcode == `R_TYPE || opcode == `SB_TYPE) ? 1'b0 : 1'b1;
  assign mem_to_reg = (opcode == `R_TYPE || opcode == `I_TYPE_ARITH || opcode == `U_TYPE_LUI) ? 2'b00 :
                      (opcode == `I_TYPE_LOAD) ? 2'b01 :
                      (opcode == `I_TYPE_JALR || opcode == `UJ_TYPE) ? 2'b10 :
                      2'b11; // auipc, PC + immed
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

  // R, I, S, SB types
  assign reg_rs1_read = opcode == `R_TYPE ||
                        opcode == `I_TYPE_LOAD ||
                        opcode == `I_TYPE_JALR ||
                        opcode == `I_TYPE_ARITH ||
                        opcode == `S_TYPE ||
                        opcode == `SB_TYPE;
  // R, S, SB types
  assign reg_rs2_read = opcode == `R_TYPE || opcode == `S_TYPE || opcode == `SB_TYPE;

endmodule
