`timescale 1ns / 1ps

module CSR_ALU (
    input  [31:0] csr_val,
    input  [31:0] other_val,
    input  [ 1:0] ctrl,
    output [31:0] result
);

  // Ctrl
  // 2'b01: result = csr_val
  // 2'b10: result = ~csr_val & other_val
  // 2'b11: result = csr_val | other_val

  assign result = (ctrl == 2'b01) ? csr_val :
                  (ctrl == 2'b10) ? ~csr_val & other_val :
                  csr_val | other_val;
endmodule
