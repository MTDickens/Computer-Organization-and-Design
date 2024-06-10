`timescale 1ns / 1ps
module Float32_Add
          (input clk,
           input rst,
           input [31:0] add_a,
           input [31:0] add_b,
           input start,
           output [31:0] result,
           output ready,
           output finish,
           output [24:0] debug_num, // Assigned at the end of the file,
           output debug_dosub,
           output [24:0] debug_num1, 
           output [24:0] debug_num2,
           output [7:0] debug_exp1,
           output [7:0] debug_exp2,
           output [24:0] debug_general
);

    
    localparam READY  = 2'b00;
    localparam BUSY   = 2'b01;
    localparam FINISH = 2'b10;
    
    reg [1:0] state;  // State register
    reg [31:0] op_a, op_b; // Store operands
    reg [31:0] sum; // Store sum

    reg [1:0] stage; // The stage of floating point addition

    assign ready = (state == READY);
    assign finish = (state == FINISH);

    // sign1,sign2,exp1,exp2,num1,num2;
    // Note: Single-precision floating point representation is (sign[31], exp[30:23], num[22:0])

    // Operand registers
    reg sign1, sign2;
    reg [7:0] exp1, exp2;
    reg [24:0] num1, num2; // There are 2'b01 in front of the numbers

    // Operand non-registers
    wire op_a_sign, op_b_sign;
    wire [7:0] op_a_exp, op_b_exp;
    wire [22:0] op_a_num, op_b_num;

    assign op_a_sign = op_a[31];
    assign op_b_sign = op_b[31];
    assign op_a_exp = op_a[30:23];
    assign op_b_exp = op_b[30:23];
    assign op_a_num = op_a[22:0];
    assign op_b_num = op_b[22:0];

    // Result registers
    reg sign;
    reg [7:0] exp;
    reg [24:0] num; // Set width to 25 to fit num1 and num2

    // Result non-register(s)
    wire dosub;
    assign dosub = op_a_sign ^ op_b_sign;
    // return {sign,exp,num[22:0]};
    assign result = {sign, exp, num[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= READY;
        end
        else begin
            case (state)
                READY: begin
                    if (start) begin
                        op_a <= add_a;
                        op_b <= add_b;
                        state <= BUSY;
                        stage <= 2'b00;
                    end
                end
                BUSY: begin
                    case (stage)
                    
                        2'b00: begin
                            if (op_a_exp > op_b_exp || (op_a_exp == op_b_exp && op_a_num > op_b_num)) begin 
                                // let op1 be the bigger value, and op2 be the smaller one
                                sign1 <= op_a_sign;
                                exp1 <= op_a_exp;
                                num1 <= {2'b01, op_a_num};
                                // Assuming sign2, exp2, num2 are defined somewhere else
                                sign2 <= op_b_sign;
                                exp2 <= op_b_exp;
                                num2 <= {2'b01, op_b_num};
                            end
                            else begin
                                sign2 <= op_a_sign;
                                exp2 <= op_a_exp;
                                num2 <= {2'b01, op_a_num};
                                sign1 <= op_b_sign;
                                exp1 <= op_b_exp;
                                num1 <= {2'b01, op_b_num};
                            end

                            // ++stage
                            stage <= stage + 1;
                        end
                        2'b01: begin
                            sign <= sign1;
                            exp <= exp1;
                            num <= num1 + ((num2 >> (exp1 - exp2)) ^ {25{dosub}}) + dosub; // num = (signed and considers exponent) (num1 + num2)
                            // ++stage
                            stage <= stage + 1;
                        end
                        2'b10: begin
                            if (exp == 255) begin // Overflow
                                num <= 0;
                                state <= FINISH; // break;
                            end
                            else if (num[24]) begin // Carry
                                exp <= exp + 1;
                                num <= num >> 1;
                            end
                            else if (num == 0) begin // Num is zero, so all is zero
                                exp <= 0;
                                state <= FINISH; // break;
                            end
                            else if (exp == 0) begin
                                num <= 0;
                                state <= FINISH; // break;
                            end
                            else if (num[24:23] == 2'b01) begin
                                state <= FINISH; // break;
                            end
                            else begin
                                exp <= exp - 1;
                                num <= num << 1;
                            end
                        end
                    endcase
                end
                FINISH: begin
                    state <= READY;
                end
            endcase
        end
    end


    
    // DEBUG BEGIN
    assign debug_general = num1 + ((num2 >> (exp1 - exp2)) ^ {25{dosub}}) + dosub;
    assign debug_num = 25'h17fffff + 1'b1; // (num2 >> (exp1 - exp2)) ^ {25{dosub}} + dosub;
    assign debug_dosub = dosub;
    assign debug_num1 = num1;
    assign debug_num2 = num2;
    assign debug_exp1 = exp1;
    assign debug_exp2 = exp2;
    // DEBUG END
endmodule


