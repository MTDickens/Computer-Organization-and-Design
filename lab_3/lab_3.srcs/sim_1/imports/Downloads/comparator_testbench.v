`timescale 1ns / 1ps
`include "Defines.vh"

module comparator_testbench;

    // Inputs
    reg [31:0] a_val;
    reg [31:0] b_val;
    reg [2:0] ctrl;

    // Outputs
    wire result;

    // Instantiate the comparator module
    Comparator comparator_inst (
        .a_val(a_val),
        .b_val(b_val),
        .ctrl(ctrl),
        .result(result)
    );

    // Testbench code
    initial begin
        // Test case 1: a_val equals b_val
        a_val = 10;
        b_val = 10;
        ctrl = `CMP_EQ;
        #1 

        b_val = 5;
        #1;

        // Test case 2: a_val not equals b_val
        a_val = 5;
        b_val = 10;
        ctrl = `CMP_NE;
        #1 

        b_val = 5;
        #1;

        // Test case 3: a_val less than b_val (signed)
        a_val = -5;
        b_val = 10;
        ctrl = `CMP_LT;
        #1 

        b_val = -7;
        #1;
        
        a_val = 32'h12341234;
        b_val = -32'h12341234;
        #1;
        
        a_val = 32'h79807890;
        b_val = -32'h79807890;
        #1;

        // Test case 4: a_val less than b_val (unsigned)
        a_val = 5;
        b_val = 10;
        ctrl = `CMP_LTU;
        #1 

        a_val = -2;
        #1;

        b_val = -1;
        #1;

        // Test case 5: a_val greater than or equal to b_val (signed)
        a_val = 10;
        b_val = 5;
        ctrl = `CMP_GE;
        #1 

        a_val = -2;
        #1;

        // Test case 6: a_val greater than or equal to b_val (unsigned)
        a_val = 10;
        b_val = 5;
        ctrl = `CMP_GEU;
        #1 

        b_val = -2;
        #1

        // Add more test cases here if needed

        // End simulation
        #1 $finish;
    end

endmodule
