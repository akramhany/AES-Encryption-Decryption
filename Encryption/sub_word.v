/*
  *
  * Module: sub_word
  * Description: Substitutes each byte of the input word with a byte from the S-Box
  * 
  * Inputs:
  *  i_word[31:0] - The input word
  * Outputs:
  *  o_word[31:0] - The output word with each byte substituted
  *
  * Author: Amir Anwar
  * Date: 2023-4-28
  *
*/
`include "sbox.v"

module sub_word(
  input [31:0] i_word,
  output [31:0] o_word
);

  // Instantiate the S-Box module 4 times

  // 1st byte substitution
  SBox sbox_inst(
    .in_toSub(i_word[7:0]),
    .out_Subed(o_word[7:0])
  );

  // 2nd byte substitution
  SBox sbox_inst1(
    .in_toSub(i_word[15:8]),
    .out_Subed(o_word[15:8])
  );

  // 3rd byte substitution
  SBox sbox_inst2(
    .in_toSub(i_word[23:16]),
    .out_Subed(o_word[23:16])
  );

  // 4th byte substitution
  SBox sbox_inst3(
    .in_toSub(i_word[31:24]),
    .out_Subed(o_word[31:24])
  );

endmodule
