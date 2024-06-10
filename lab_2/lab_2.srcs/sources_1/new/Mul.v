`timescale 1ns / 1ps
module Mul(input clk,
           input rst,
           input [15:0] multiplicand,
           input [15:0] multiplier,
           input start,
           output [31:0] product,
           output ready,
           output finish
//           ,output [1:0] check_bits_out,
//           output [15:0] left_add_out,
//           output [15:0] left_minus_out
);
    
    localparam READY  = 2'b00;
    localparam BUSY   = 2'b01;
    localparam FINISH = 2'b10;
    
    reg [1:0] state;  // State register
    reg [4:0] count; // Count the steps       
    reg [31:-1] product_reg; // Return value - product
    reg [15:0] reg_multiplicand; // Store multiplicand
    
    wire [15:0] left_add;
    wire [15:0] left_minus;
    wire [1:0] check_bits;

    assign check_bits = product_reg[0:-1];
    assign left_add = product_reg[31:16] + reg_multiplicand;
    assign left_minus = product_reg[31:16] - reg_multiplicand;

    assign product = product_reg[31:0];
    assign finish = state == FINISH;
    assign ready = state == READY;
    
    // DEBUG
//    assign check_bits_out = check_bits;
//    assign left_add_out = left_add;
//    assign left_minus_out = left_minus;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= READY;
        end

        else if ((state == READY) && start) begin
            state <= BUSY;
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
            product_reg <= 0;
        end
        else if ((state == READY) && start) begin
            product_reg <= {16'h0000, multiplier, 1'b0};
            reg_multiplicand <= multiplicand;
        end
        else if (state == BUSY && count != 5'b1000_0) begin
            case(check_bits)
                2'b01: begin // Add and signed right shift
                    product_reg <= {left_add[15], left_add, product_reg[15:0]};
                end
                2'b10: begin // Minus and signed right shift
                    product_reg <= {left_minus[15], left_minus, product_reg[15:0]};
                end
                2'b00, 2'b11: begin // Just signed right shift
                    product_reg <= {product_reg[31], product_reg[31:0]};
                end
            endcase
        end
    end
    
endmodule
