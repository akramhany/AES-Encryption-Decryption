/*
  *
  * Module: shift_rows_tb
  * Description: Testbench for shift_rows module
  * 
  * Author: Amir Anwar
  * Date: 2023-4-27
  *
*/
`timescale 1ns / 1ps
`include "shift_rows.v"

module shift_rows_tb();

    // Inputs
    reg [127:0] i_state;

    // Outputs
    wire [127:0] o_state;

    // Instantiate the Unit Under Test (UUT)
    shift_rows uut (
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
        i_state = 128'h63cab7040953d051cd60e0e7ba70e18c;
        #10;
        $display("Testcase 0");
        $display("Input:           %h", i_state);
        $display("Expected Output: %h", 128'h6353e08c0960e104cd70b751bacad0e7);
        $display("Got:             %h", o_state);
        if (o_state != 128'h6353e08c0960e104cd70b751bacad0e7) begin
          $display("Testcase 0 failed");
        end
        else begin
          $display("Testcase 0 passed");
        end

        $display("=================================================");

        // Testcase 1
        i_state = 128'ha761ca9b97be8b45d8ad1a611fc97369;
        #10;
        $display("Testcase 1");
        $display("Input:           %h", i_state);
        $display("Expected Output: %h", 128'ha7be1a6997ad739bd8c9ca451f618b61);
        $display("Got:             %h", o_state);
        if (o_state != 128'ha7be1a6997ad739bd8c9ca451f618b61) begin
          $display("Testcase 1 failed");
        end
        else begin
          $display("Testcase 1 passed");
        end

        #10 $finish;
    end

endmodule