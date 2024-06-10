`include "Defines.vh"
`timescale 1ns / 1ps

module RegFile(
        `Core_DBG_Definitions
        input clk,
        input rst,
        input wen,
        input [4:0] rs1,
        input [4:0] rs2,
        input [4:0] rd,
        input [31:0] i_data,
        output [31:0] rs1_val,
        output [31:0] rs2_val
    );

    reg [31:0] regs [31:0];
    `RegFile_DBG_Assignment
    assign rs1_val = regs[rs1];
    assign rs2_val = regs[rs2];
    always @(posedge clk) begin
        if (rst) begin
            // Clear all register files
            regs[0] <= 0;
            regs[1] <= 0;
            regs[2] <= 0;
            regs[3] <= 0;
            regs[4] <= 0;
            regs[5] <= 0;
            regs[6] <= 0;
            regs[7] <= 0;
            regs[8] <= 0;
            regs[9] <= 0;
            regs[10] <= 0;
            regs[11] <= 0;
            regs[12] <= 0;
            regs[13] <= 0;
            regs[14] <= 0;
            regs[15] <= 0;
            regs[16] <= 0;
            regs[17] <= 0;
            regs[18] <= 0;
            regs[19] <= 0;
            regs[20] <= 0;
            regs[21] <= 0;
            regs[22] <= 0;
            regs[23] <= 0;
            regs[24] <= 0;
            regs[25] <= 0;
            regs[26] <= 0;
            regs[27] <= 0;
            regs[28] <= 0;
            regs[29] <= 0;
            regs[30] <= 0;
            regs[31] <= 0;
        end else begin
            if (wen) begin
                // Write i_data to regs[rd]
                if (rd != 0) regs[rd] <= i_data;
            end
        end
    end

endmodule
