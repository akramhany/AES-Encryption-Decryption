/*
  *
  * Module: sub_word_tb
  * Description: Testbench for sub_word module
  * 
  * Author: Amir Anwar
  * Date: 2023-4-28
  *
*/
`timescale 1ns / 1ps
`include "sub_word.v"

module sub_word_tb();

    // Inputs
    reg [31:0] i_word;

    // Outputs
    wire [31:0] o_word;

    // Instantiate the Unit Under Test (UUT)
    sub_word uut (
        .i_word(i_word), 
        .o_word(o_word)
    );

    integer i;

    initial begin
        // Initialize Inputs
        i_word = 32'h00000000;

        // Wait 100 ns
        #100;

        // testcases

        // - Testcase 0
        i_word = 32'hcf4f3c09;
        #10;
        $display("Testcase 0");
        $display("Input:           %h", i_word);
        $display("Expected Output: %h", 32'h8a84eb01);
        $display("Got:             %h", o_word);
        if (o_word != 32'h8a84eb01) begin
          $display("Testcase 0 failed");
        end
        else begin
          $display("Testcase 0 passed");
        end

        $display("=================================================");

        // - Testcase 1
        i_word = 32'h2c6b7b52;
        #10;
        $display("Testcase 1");
        $display("Input:           %h", i_word);
        $display("Expected Output: %h", 32'h717f2100);
        $display("Got:             %h", o_word);
        if (o_word != 32'h717f2100) begin
          $display("Testcase 1 failed");
        end
        else begin
          $display("Testcase 1 passed");
        end

        $display("=================================================");

        // - Testcase 2
        i_word = 32'h5d5b9ab7;
        #10;
        $display("Testcase 2");
        $display("Input:           %h", i_word);
        $display("Expected Output: %h", 32'h4c39b8a9);
        $display("Got:             %h", o_word);
        if (o_word != 32'h4c39b8a9) begin
          $display("Testcase 2 failed");
        end
        else begin
          $display("Testcase 2 passed");
        end

        $display("=================================================");

        #10 $finish;
    end

endmodule