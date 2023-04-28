/*
   *
   * Module: inv_mix_columns
   * Description: This module performs the inverse of mix columns operation on the input state of AES encryption.
   * Inputs:
   *     i_state: 128-bit input state
   * Outputs:
   *     o_state: 128-bit output state after mixing columns
   * Author: Adham Hussin
   * Date: 27/4/2003 
*/
module inv_mix_columns
(
    input wire [127:0]i_state,
    output wire [127:0]o_state
);

function [7:0] by2(input [7:0] x);
    if (x[7] == 1) begin
        by2 = ((x << 1) ^ 8'h1b); // checks for overflow
    end 
    else begin
        by2 = x << 1;
    end
endfunction

function [7:0] byE(input [7:0] x);
        byE = by2(by2(by2(x))) ^ by2(by2(x)) ^ by2(x); // x*2*2*2 + x*2*2 + x*2 = 14x (ex)
endfunction

function [7:0] byB(input [7:0] x);
        byB = by2(by2(by2(x))) ^ by2(x) ^ x; // x*2*2*2 + x*2 + x = 11x (bx)
endfunction

function [7:0] byD(input [7:0] x);
        byD = by2(by2(by2(x))) ^ by2(by2(x)) ^ x; // x*2*2*2 + x*2*2 + x = 13x (dx)
endfunction

function [7:0] by9(input [7:0] x);
        by9 = by2(by2(by2(x))) ^ x; // x*2*2*2 + x = 9x
endfunction

genvar i;
generate
	for (i = 15; i > -1; i = i - 1) begin //traversing on each byte 
        assign o_state[(i*8 + 7) : i*8] =   (i%4 == 3) ?  by9(i_state[i/4 *32 + 7: i/4 *32]) ^ byD(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ byB(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ byE(i_state[i/4 *32 +31: i/4 *32 + 24]): //if i in 1st row
                                            (i%4 == 2) ?  byD(i_state[i/4 *32 + 7: i/4 *32]) ^ byB(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ byE(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ by9(i_state[i/4 *32 +31: i/4 *32 + 24]): //        2nd row
                                            (i%4 == 1) ?  byB(i_state[i/4 *32 + 7: i/4 *32]) ^ byE(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ by9(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ byD(i_state[i/4 *32 +31: i/4 *32 + 24]): //        3rd row
                                                          byE(i_state[i/4 *32 + 7: i/4 *32]) ^ by9(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ byD(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ byB(i_state[i/4 *32 +31: i/4 *32 + 24]); //        4th row			  
	end
endgenerate
endmodule