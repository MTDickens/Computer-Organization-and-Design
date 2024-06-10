`timescale 1ns / 1ps
`include "Defines.vh"

module Alu (
    input [31:0] a_val,
    input [31:0] b_val,
    input [3:0] ctrl,
    output reg [31:0] result
);
  wire [31:0] right_shift_logical;
  assign right_shift_logical = a_val >> b_val;

  wire [31:0] temp1;
  assign temp1 = ((32'h0001 << b_val) - 32'h0001);
  wire [31:0] temp2;
  assign temp2 = temp1 << (32'd32 - b_val);

  always @(*) begin
    case (ctrl)
      // ALU operation: ADD
      `ALU_ADD: result = a_val + b_val;

      // ALU operation: SUBTRACT
      `ALU_SUB: result = a_val - b_val;

      // ALU operation: SHIFT LEFT LOGICAL
      `ALU_SLL: result = a_val << b_val;

      // ALU operation: SET LESS THAN
      `ALU_SLT: result = ($signed(a_val) < $signed(b_val)) ? 1 : 0;

      // ALU operation: SET LESS THAN UNSIGNED
      `ALU_SLTU: result = ($unsigned(a_val) < $unsigned(b_val)) ? 1 : 0;

      // ALU operation: XOR
      `ALU_XOR: result = a_val ^ b_val;

      // ALU operation: SHIFT RIGHT LOGICAL
      `ALU_SRL: result = right_shift_logical;

      // ALU operation: SHIFT RIGHT ARITHMETIC
      //  (111) << (width-3) = (1 << 3 - 1) << (width - 3)
      // `ALU_SRA: result = right_shift_logical | (a_val[31] ? temp2 : 0 );
      `ALU_SRA: result = $signed(a_val) >>> $signed(b_val[4:0]);  // Correct

      // ALU operation: OR
      `ALU_OR: result = a_val | b_val;

      // ALU operation: AND
      `ALU_AND: result = a_val & b_val;
    endcase
  end

endmodule
