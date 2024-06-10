`timescale 1ns / 1ps
module Div(
        input clk,
        input rst,
        input start,
        input [15:0] dividend,
        input [15:0] divisor,
        output finish,
        output ready,
        output [15:0] quotient,
        output [15:0] remainder,
//        output [31:0] quo_rem_reg_out, //DEBUG
        output div_by_0
//        output [4:0] count_out //DEBUG
//        ,output [15:0] divisor_reg_out //DEBUG
    );
    
    localparam READY  = 2'b00;
    localparam BUSY   = 2'b01;
    localparam FINISH = 2'b10;
    
    reg [1:0] state;  // State register
    reg [4:0] count; // Count the steps    

    reg [31:0] quo_rem_reg; // Return value - quotient and remainder
    reg [15:0] divisor_reg; // Store divisor
    reg neg; // Store the sign of the output

    wire [15:0] abs_dividend;
    wire [15:0] abs_divisor;

    assign div_by_0 = (divisor == 0);    
    assign finish = state == FINISH;
    assign ready = state == READY;
    assign abs_dividend = dividend[15] ? -dividend : dividend;
    assign abs_divisor = divisor[15] ? -divisor : divisor;
    assign remainder = dividend[15] ? -(quo_rem_reg[31:16] >> 1): (quo_rem_reg[31:16] >> 1);          // The sign of remainder is decided by the sign of the remainder
    assign quotient = neg? -quo_rem_reg[15:0] : quo_rem_reg[15:0]; // The sign of quotient is decided by the sign of the two
    
    // DEBUG
//    assign quo_rem_reg_out = quo_rem_reg; 
//    assign count_out = count;
//    assign divisor_reg_out = divisor_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= READY;
        end

        else if ((state == READY) && start) begin
            state <= divisor == 0 ? READY : BUSY;
            count <= 5'b0000_0;
        end

        else if ((state == BUSY) && (count == 5'b1000_0)) begin
            state <= FINISH;
        end
        
        else if (state == BUSY && count != 5'b1000_0) begin
            count <= count + 1;
        end

        else if (state == FINISH) begin
            state <= READY;
        end
    end
        
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            quo_rem_reg <= 0;
        end
        else if ((state == READY) && start) begin
            // Do the preparation work
            neg <= dividend[15] ^ divisor[15];
            quo_rem_reg <= {16'b000_0000_0000_0000, abs_dividend} << 1;
            divisor_reg <= abs_divisor;
        end
        else if (state == BUSY && count != 5'b1000_0) begin
            if (quo_rem_reg[31:16] >= divisor_reg) begin
                quo_rem_reg <= ({quo_rem_reg[31:16] - divisor_reg, quo_rem_reg[15:0]} << 1) + 1;
            end
            else begin
                quo_rem_reg <= quo_rem_reg << 1;
            end
        end
    end
    
endmodule
