`timescale 1ns / 1ps


module Exception_ctrl (
    input io_int,
    input is_unalign,
    input bj_unalign,
    input illegal_op,
    input is_ecall,
    input [31:0] inst,
    input [31:0] dmem_addr,
    input [31:0] bj_unalign_mtval,
    output except,
    output [31:0] error_info,
    output [31:0] error_id
);
  assign except = io_int | is_unalign | bj_unalign | illegal_op | is_ecall;
  assign error_info = illegal_op ? inst :
                      is_unalign ? dmem_addr :
                      bj_unalign ? bj_unalign_mtval :
                      is_ecall ? 32'h0 :
                      io_int ? 32'h0 : 32'h0;
  wire is_load;
  assign is_load = (inst[6:0] == `I_TYPE_LOAD) ? 1'b1 : 1'b0;
  assign error_id = io_int ? `CSR_CAUSE_M_EXTERNAL_INT :
                     is_unalign ? (is_load ? `CSR_CAUSE_LOAD_ADDR_MISALIGN : `CSR_CAUSE_STORE_ADDR_MISALIGN) :
                     bj_unalign ? `CSR_CAUSE_INST_ADDR_MISALIGN :
                     illegal_op ? `CSR_CAUSE_ILLEGAL_INST :
                     is_ecall ? `CSR_CAUSE_ECALL_FROM_M :
                     32'h0;
endmodule
