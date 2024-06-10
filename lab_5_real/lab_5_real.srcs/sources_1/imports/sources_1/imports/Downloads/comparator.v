`timescale 1ns / 1ps
`include "Defines.vh"

module Comparator(
    input [31:0] a_val,
    input [31:0] b_val,
    input [2:0] ctrl,
    output result
);

    reg result;

//    wire [31:0] diff;
//    assign diff = a_val - b_val;
//    wire is_pos_a, is_pos_b, is_pos_diff, is_less_than_unsigned, is_less_than_signed;
//    assign is_pos_a = ~a_val[31];
//    assign is_pos_b = ~b_val[31];
//    assign is_pos_diff = ~diff[31];
//    assign is_less_than_unsigned = (is_pos_a & (~is_pos_b)) | (((is_pos_a & is_pos_b) | (~is_pos_a & ~is_pos_b)) & ~is_pos_diff);
//    assign is_less_than_signed = ((~is_pos_a) & is_pos_b) | (((is_pos_a & is_pos_b) | (~is_pos_a & ~is_pos_b)) & ~is_pos_diff);

    always @(*)
        case (ctrl) 
             `CMP_EQ: result = (a_val == b_val);
             `CMP_NE: result = (a_val != b_val);
             `CMP_LT: result = ($signed(a_val) < $signed(b_val));
             `CMP_LTU: result = ($unsigned(a_val) < $unsigned(b_val));
             `CMP_GE: result = ($signed(a_val) >= $signed(b_val));
             `CMP_GEU: result = ($unsigned(a_val) >= $unsigned(b_val));
            // `CMP_EQ: result = ~(|diff);
            // `CMP_NE: result = |diff;
            // `CMP_LT: result = is_less_than_signed;
            // `CMP_LTU: result = is_less_than_unsigned;
            // `CMP_GE: result = ~is_less_than_signed;
            // `CMP_GEU: result = ~is_less_than_unsigned;
            default: result = 1'b0; // Default
        endcase
endmodule
