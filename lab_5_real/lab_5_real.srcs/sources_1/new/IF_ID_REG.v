`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/04 19:29:33
// Design Name: 
// Module Name: EX_MEM_REG
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/**
    * Store pc and inst from IF stage.
*/
module IF_ID_REG (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,

    /*
    * New data in this stage
    */
    input  wire [31:0] pc_plus_4_if,
    input  wire [31:0] pc_if,
    input  wire [31:0] inst_if,
    output wire [31:0] pc_plus_4_id,
    output wire [31:0] pc_id,
    output wire [31:0] inst_id
);

  // Registers
  reg [31:0] pc_plus_4_id_reg;
  reg [31:0] pc_id_reg;
  reg [31:0] inst_id_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pc_plus_4_id_reg <= 32'b0;
      pc_id_reg <= 32'b0;
      inst_id_reg <= 32'b0;
    end else if (stall) begin
      // Do nothing
    end else if (flush) begin
      pc_plus_4_id_reg <= 32'b0;
      pc_id_reg <= 32'b0;
      inst_id_reg <= 32'b0;
    end else begin
      pc_plus_4_id_reg <= pc_plus_4_if;
      pc_id_reg <= pc_if;
      inst_id_reg <= inst_if;
    end
  end

  assign pc_plus_4_id = pc_plus_4_id_reg;
  assign pc_id = pc_id_reg;
  assign inst_id = inst_id_reg;
endmodule
