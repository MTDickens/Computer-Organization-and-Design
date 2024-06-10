`timescale 1ns / 1ps

module PredictionUnit (
    input wire [31:0] pc_plus_4_ex,
    input wire branch_mux_choose,
    input wire [1:0] jump_ex,
    input wire [31:0] jump_mux_out,  // target pc
    output wire flush
);

  // Predict the next PC
  wire jump_or_branch;
  assign jump_or_branch = branch_mux_choose || (jump_ex[1] || jump_ex[0]);

  // If the branch is taken and the next PC is not the same as the target PC, flush the pipeline
  assign flush = jump_or_branch;
endmodule
