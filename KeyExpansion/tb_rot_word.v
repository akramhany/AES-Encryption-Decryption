/*
   *
   * Module: tb_rot_word
   * Description: This module tests the rotate word operation on a word from the key.
   * Inputs: N/A
   * Outputs: N/A
   * Author: Adham Hussin
   * Date: 27/4/2003 
*/
`include "rot_word.v"
module tb_rot_word;


reg [31:0]i_word;
wire [31:0]o_word;


rot_word rotator(.i_word(i_word), .o_word(o_word));


initial begin
 
    i_word = 32'h09cf4f3c;
    #10 i_word = 32'h2a6c7605;
  
    #10 $finish;
end




always @(o_word) begin
  
  $display("Time = %t, i_word = %h, o_word = %h", $time, i_word, o_word);
end

endmodule