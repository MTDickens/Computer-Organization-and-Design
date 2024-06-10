`timescale 1ns / 1ps

module MACtrl (
    // face CPU
    input [31:0] i_iaddr,
    output [31:0] o_idata,
    input i_dwen,
    input [31:0] i_daddr,
    input [31:0] i_d_idata,
    output [31:0] o_d_odata,
    // face IMEM
    output [31:0] o_iaddr,
    input [31:0] i_idata,
    // face DMEM
    output o_dwen,
    output [31:0] o_daddr,
    output [31:0] o_d_idata,
    input [31:0] i_d_odata,
    // face DispNum
    output o_drwen,
    output [31:0] o_dr_idata,
    input [31:0] i_dr_odata
);

  // Dmem & IO wen
  assign is_mem = (i_daddr != 32'hFE000000);

  // Imem
  assign o_iaddr = i_iaddr;

  // Dmem
  assign o_d_idata = i_d_idata;
  assign o_daddr = i_daddr;
  assign o_dwen = i_dwen & is_mem;
  // IO
  assign o_dr_idata = i_d_idata;
  assign o_drwen = i_dwen & !is_mem;

  // CPU
  assign o_idata = i_idata;
  assign o_d_odata = is_mem ? i_d_odata : i_dr_odata;

endmodule
