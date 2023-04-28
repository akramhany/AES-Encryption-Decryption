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
module sub_word(
  input [31:0] i_word,
  output [31:0] o_word
);

  // Instantiate the S-Box module 4 times

  // 1st byte substitution
  s_box s_box_inst(
    .i_byte(i_word[7:0]),
    .o_byte(o_word[7:0])
  );

  // 2nd byte substitution
  s_box s_box_inst1(
    .i_byte(i_word[15:8]),
    .o_byte(o_word[15:8])
  );

  // 3rd byte substitution
  s_box s_box_inst2(
    .i_byte(i_word[23:16]),
    .o_byte(o_word[23:16])
  );
  
  // 4th byte substitution
  s_box s_box_inst3(
    .i_byte(i_word[31:24]),
    .o_byte(o_word[31:24])
  );

endmodule
