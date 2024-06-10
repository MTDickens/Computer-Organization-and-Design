`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/05 00:15:56
// Design Name: 
// Module Name: StallController
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
 * Check for data hazards that can't be resolved by pure forwarding
*/
module StallController (
    input wire reg_rs1_read,
    input wire reg_rs2_read,
    input wire mem_read_ex,  // Load
    input wire reg_write_ex,  // Load
    input wire [4:0] rs1_id,
    input wire [4:0] rs2_id,
    input wire [4:0] rd_ex,
    output wire stall_if,
    output wire stall_id
);
  wire rs1_hazard;
  wire rs2_hazard;
  wire is_hazard;
  assign rs1_hazard = reg_rs1_read && (rs1_id == rd_ex) && (rs1_id != 5'b00000);
  assign rs2_hazard = reg_rs2_read && (rs2_id == rd_ex) && (rs2_id != 5'b00000);
  assign is_hazard  = rs1_hazard || rs2_hazard;
  // Stall and flush if there is a data hazard
  assign stall_if   = is_hazard && mem_read_ex && reg_write_ex;
  assign stall_id   = stall_if;
endmodule
