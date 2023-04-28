/*
   *
   * Module: mix_columns
   * Description: This module performs the mix columns operation on the input state of AES encryption.
   * Inputs:
   *     i_state: 128-bit input state
   * Outputs:
   *     o_state: 128-bit output state after mixing columns
   * Author: Adham Hussin
   * Date: 27/4/2003 
*/
module mix_columns
(
    input wire [127:0]i_state,
    output wire [127:0]o_state
);

function [7:0] by2(input [7:0] x);
    if (x[7] == 1) begin //checks for overflow
        by2 = ((x << 1) ^ 8'h1b); //if so, it shifts one bit to the left (multiply by 2) and xor with 1b
    end 
    else begin
        by2 = x << 1;
    end
endfunction

function [7:0] by3(input [7:0] x);
    by3 = by2(x) ^ x;
endfunction

genvar i;
generate
	for (i = 15; i > -1; i = i - 1) begin //traversing on each byte 
        assign o_state[(i*8 + 7) : i*8] =   (i%4 == 3) ?  i_state[i/4 *32 + 7: i/4 *32] ^ i_state[i/4 *32 +15: i/4 *32 + 8] ^ by3(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ by2(i_state[i/4 *32 +31: i/4 *32 + 24]): //if i in 1st row
                                            (i%4 == 2) ?  i_state[i/4 *32 + 7: i/4 *32] ^ by3(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ by2(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ i_state[i/4 *32 +31: i/4 *32 + 24]: //        2nd row
                                            (i%4 == 1) ?  by3(i_state[i/4 *32 + 7: i/4 *32]) ^ by2(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ i_state[i/4 *32 +23: i/4 *32 + 16] ^ i_state[i/4 *32 +31: i/4 *32 + 24]: //        3rd row
                                                          by2(i_state[i/4 *32 + 7: i/4 *32]) ^ i_state[i/4 *32 +15: i/4 *32 + 8] ^ i_state[i/4 *32 +23: i/4 *32 + 16] ^ by3(i_state[i/4 *32 +31: i/4 *32 + 24]); //        4th row			  
	end
endgenerate
endmodule