/*
   *
   * Module: rot_word
   * Description: This module performs the rotate word operation on a word from the key.
   * Inputs:
   *     i_word: 32-bit input word
   * Outputs:
   *     o_word: 32-bit output word after rotation
   * Author: Adham Hussin
   * Date: 28/4/2003 
*/
module rot_word
(
    input wire [31:0]i_word,
    output wire [31:0]o_word
);
assign o_word = {i_word[23:0],i_word[31:24]};

endmodule