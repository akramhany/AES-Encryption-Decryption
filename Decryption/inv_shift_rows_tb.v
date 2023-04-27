/*
  *
  * Module: inv_shift_rows_tb
  * Description: Testbench for inv_shift_rows module
  * 
  * Author: Amir Anwar
  * Date: 2023-4-27
  *
*/
`timescale 1ns / 1ps
`include "inv_shift_rows.v"

module inv_shift_rows_tb();

    // Inputs
    reg [127:0] i_state;

    // Outputs
    wire [127:0] o_state;

    // Instantiate the Unit Under Test (UUT)
    inv_shift_rows uut (
        .i_state(i_state), 
        .o_state(o_state)
    );

    integer i;

    initial begin
        // Initialize Inputs
        i_state = 128'h00000000000000000000000000000000;

        // Wait 100 ns
        #100;

        // testcases
        // Testcase 0
        i_state = 128'h54d990a16ba09ab596bbf40ea111702f;
        #10;
        $display("Testcase 0");
        $display("Input:           %h", i_state);
        $display("Expected Output: %h", 128'h5411f4b56bd9700e96a0902fa1bb9aa1);
        $display("Got:             %h", o_state);
        if (o_state != 128'h5411f4b56bd9700e96a0902fa1bb9aa1) begin
          $display("Testcase 0 failed");
        end
        else begin
          $display("Testcase 0 passed");
        end

        $display("=================================================");

        // Testcase 1
        i_state = 128'h3e1c22c0b6fcbf768da85067f6170495;
        #10;
        $display("Testcase 1");
        $display("Input:           %h", i_state);
        $display("Expected Output: %h", 128'h3e175076b61c04678dfc2295f6a8bfc0);
        $display("Got:             %h", o_state);
        if (o_state != 128'h3e175076b61c04678dfc2295f6a8bfc0) begin
          $display("Testcase 1 failed");
        end
        else begin
          $display("Testcase 1 passed");
        end

        #10 $finish;
    end


endmodule