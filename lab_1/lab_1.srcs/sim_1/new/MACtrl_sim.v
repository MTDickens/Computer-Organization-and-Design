`timescale 1ns / 1ps

module MACtrl_sim();
  
  // Define parameters
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 32;

  // Define signals
  reg [31:0] i_iaddr;
  wire [31:0] o_idata;
  reg i_dwen;
  reg [31:0] i_daddr;
  reg [31:0] i_d_idata;
  wire [31:0] o_d_odata;
  wire [31:0] o_iaddr;
  reg [31:0] i_idata;
  wire o_dwen;
  wire [31:0] o_daddr;
  wire [31:0] o_d_idata;
  reg [31:0] i_d_odata;
  wire o_drwen;
  wire [31:0] o_dr_idata;
  reg [31:0] i_dr_odata;

  // Instantiate the MACtrl module
  MACtrl MACtrl_inst (
    .i_iaddr(i_iaddr),
    .o_idata(o_idata),
    .i_dwen(i_dwen),
    .i_daddr(i_daddr),
    .i_d_idata(i_d_idata),
    .o_d_odata(o_d_odata),
    .o_iaddr(o_iaddr),
    .i_idata(i_idata),
    .o_dwen(o_dwen),
    .o_daddr(o_daddr),
    .o_d_idata(o_d_idata),
    .i_d_odata(i_d_odata),
    .o_drwen(o_drwen),
    .o_dr_idata(o_dr_idata),
    .i_dr_odata(i_dr_odata)
  );

  // Stimulus generation
  initial begin
    // inst mem

    i_iaddr = 32'h0000_0000;
    i_idata = 32'h4982_4982;

    // data mem & led
    i_d_idata = 32'h0000_0000;
    
    i_dwen = 1'b0;
    i_daddr = 32'h0000_0000;
    i_d_odata = 32'h0191_9810;
    i_dr_odata = 32'h0011_4514;

    #10;

    // change dwen
    i_dwen = 1'b1;

    #10;

    // change address to mapped I/O
    i_daddr = 32'hFE000000;
    
    #10;
    $finish;
  end

endmodule
    