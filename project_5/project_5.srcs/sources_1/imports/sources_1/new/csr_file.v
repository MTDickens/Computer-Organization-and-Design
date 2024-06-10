`timescale 1ns / 1ps
`include "Defines.vh"

module CSRFile (
    input clk,
    input rst,
    input wen,
    input except,
    input is_mret,
    input [11:0] csr,
    input [31:0] i_data,
    input [31:0] pc,
    input [31:0] error_info,
    input [31:0] error_id,
    output except_final,
    output reg [31:0] csr_val,
    output [31:0] write_pc
);

  reg [31:0] mstatus;
  reg [31:0] mepc;
  reg [31:0] mcause;
  reg [31:0] mtval;
  reg [31:0] mtvec;

  // Output
  wire mie;
  wire mpie;
  assign mie = mstatus[3];
  assign mpie = mstatus[7];
  assign except_final = except & mie;
  assign write_pc = except_final ? mtvec : mepc;

  always @(*) begin
    case (csr)
      `CSR_MSTATUS: csr_val = mstatus;
      `CSR_MEPC: csr_val = mepc;
      `CSR_MCAUSE: csr_val = mcause;
      `CSR_MTVAL: csr_val = mtval;
      `CSR_MTVEC: csr_val = mtvec;
      default: csr_val = 0;
    endcase
  end

  always @(posedge clk) begin
    if (rst) begin
      // Clear all active CSRs
      mstatus <= 0;
      mepc <= 0;
      mcause <= 0;
      mtval <= 0;
      mtvec <= 0;
    end else if (except_final) begin
      // Save exception information
      mepc <= pc;
      mtval <= error_info;
      mcause <= error_id;
      // Prepare for exception
      mstatus[7] <= mie;
      mstatus[3] <= 0;
    end else if (is_mret) begin
      // Restore previous state
      mstatus[3] <= mpie;
    end else if (wen) begin
      // Write i_data to regs[rd]
      case (csr)
        `CSR_MSTATUS: mstatus <= i_data;
        `CSR_MEPC: mepc <= i_data;
        `CSR_MCAUSE: mcause <= i_data;
        `CSR_MTVAL: mtval <= i_data;
        `CSR_MTVEC: mtvec <= i_data;
      endcase
    end
  end

endmodule

