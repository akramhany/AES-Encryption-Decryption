/*
  *
  * Module: add_round_key_tb
  * Description: a test bench for add round key 
  * Author: Akram
  * Date: 28/4/2023
*/

`include "add_round_key.v"
module add_round_key_tb();

//Inputs
reg [127:0] i_state, i_key;

//Outputs
wire [127:0] o_state;

//an instance of add_round_key
add_round_key ark (
    .i_key(i_key),
    .i_state(i_state),
    .o_state(o_state)
);

initial begin

    //initialize the key and state with 0's
    i_key = 128'h00000000000000000000000000000000;
    i_state = 128'h00000000000000000000000000000000;

    #50;
    //set a value for the state and key
    i_state = 128'h3243f6a8885a308d313198a2e0370734;
    i_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;

    #10
    $display("Input           = 3243f6a8885a308d313198a2e0370734");
    $display("Key             = 2b7e151628aed2a6abf7158809cf4f3c");
    $display("Output          = %h", o_state);
    $display("Expected output = 193de3bea0f4e22b9ac68d2ae9f84808");

    //check if the output state is equal to the expected output state
    if (o_state == 128'h193de3bea0f4e22b9ac68d2ae9f84808) begin
        $display("Success !!");
    end
    else begin
        $display("Failed !!");
    end

    #10 $finish;
end

endmodule