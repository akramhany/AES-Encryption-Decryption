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

// genvar i;
// generate
// 	for (i = 15; i > -1; i = i - 1) begin : loop_mix//traversing on each byte 
//         assign o_state[(i*8 + 7) : i*8] =   (i%4 == 3) ?  i_state[i/4 *32 + 7: i/4 *32] ^ i_state[i/4 *32 +15: i/4 *32 + 8] ^ by3(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ by2(i_state[i/4 *32 +31: i/4 *32 + 24]): //if i in 1st row
//                                             (i%4 == 2) ?  i_state[i/4 *32 + 7: i/4 *32] ^ by3(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ by2(i_state[i/4 *32 +23: i/4 *32 + 16]) ^ i_state[i/4 *32 +31: i/4 *32 + 24]: //        2nd row
//                                             (i%4 == 1) ?  by3(i_state[i/4 *32 + 7: i/4 *32]) ^ by2(i_state[i/4 *32 +15: i/4 *32 + 8]) ^ i_state[i/4 *32 +23: i/4 *32 + 16] ^ i_state[i/4 *32 +31: i/4 *32 + 24]: //        3rd row
//                                                           by2(i_state[i/4 *32 + 7: i/4 *32]) ^ i_state[i/4 *32 +15: i/4 *32 + 8] ^ i_state[i/4 *32 +23: i/4 *32 + 16] ^ by3(i_state[i/4 *32 +31: i/4 *32 + 24]); //        4th row			  
// 	end
// endgenerate
assign o_state[(15*8 + 7) : 15*8] = i_state[15/4 *32 + 7: 15/4 *32] ^ i_state[15/4 *32 +15: 15/4 *32 + 8] ^ by3(i_state[15/4 *32 +23: 15/4 *32 + 16]) ^ by2(i_state[15/4 *32 +31: 15/4 *32 + 24]);
assign o_state[(14*8 + 7) : 14*8] = i_state[14/4 *32 + 7: 14/4 *32] ^ by3(i_state[14/4 *32 +15: 14/4 *32 + 8]) ^ by2(i_state[14/4 *32 +23: 14/4 *32 + 16]) ^ i_state[14/4 *32 +31: 14/4 *32 + 24];
assign o_state[(13*8 + 7) : 13*8] = by3(i_state[13/4 *32 + 7: 13/4 *32]) ^ by2(i_state[13/4 *32 +15: 13/4 *32 + 8]) ^ i_state[13/4 *32 +23: 13/4 *32 + 16] ^ i_state[13/4 *32 +31: 13/4 *32 + 24];
assign o_state[(12*8 + 7) : 12*8] = by2(i_state[12/4 *32 + 7: 12/4 *32]) ^ i_state[12/4 *32 +15: 12/4 *32 + 8] ^ i_state[12/4 *32 +23: 12/4 *32 + 16] ^ by3(i_state[12/4 *32 +31: 12/4 *32 + 24]);

assign o_state[(11*8 + 7) : 11*8] = i_state[11/4 *32 + 7: 11/4 *32] ^ i_state[11/4 *32 +15: 11/4 *32 + 8] ^ by3(i_state[11/4 *32 +23: 11/4 *32 + 16]) ^ by2(i_state[11/4 *32 +31: 11/4 *32 + 24]);
assign o_state[(10*8 + 7) : 10*8] = i_state[10/4 *32 + 7: 10/4 *32] ^ by3(i_state[10/4 *32 +15: 10/4 *32 + 8]) ^ by2(i_state[10/4 *32 +23: 10/4 *32 + 16]) ^ i_state[10/4 *32 +31: 10/4 *32 + 24];
assign o_state[(9*8 + 7) : 9*8] = by3(i_state[9/4 *32 + 7: 9/4 *32]) ^ by2(i_state[9/4 *32 +15: 9/4 *32 + 8]) ^ i_state[9/4 *32 +23: 9/4 *32 + 16] ^ i_state[9/4 *32 +31: 9/4 *32 + 24];
assign o_state[(8*8 + 7) : 8*8] = by2(i_state[8/4 *32 + 7: 8/4 *32]) ^ i_state[8/4 *32 +15: 8/4 *32 + 8] ^ i_state[8/4 *32 +23: 8/4 *32 + 16] ^ by3(i_state[8/4 *32 +31: 8/4 *32 + 24]);

assign o_state[(7*8 + 7) : 7*8] = i_state[7/4 *32 + 7: 7/4 *32] ^ i_state[7/4 *32 +15: 7/4 *32 + 8] ^ by3(i_state[7/4 *32 +23: 7/4 *32 + 16]) ^ by2(i_state[7/4 *32 +31: 7/4 *32 + 24]);
assign o_state[(6*8 + 7) : 6*8] = i_state[6/4 *32 + 7: 6/4 *32] ^ by3(i_state[6/4 *32 +15: 6/4 *32 + 8]) ^ by2(i_state[6/4 *32 +23: 6/4 *32 + 16]) ^ i_state[6/4 *32 +31: 6/4 *32 + 24];
assign o_state[(5*8 + 7) : 5*8] = by3(i_state[5/4 *32 + 7: 5/4 *32]) ^ by2(i_state[5/4 *32 +15: 5/4 *32 + 8]) ^ i_state[5/4 *32 +23: 5/4 *32 + 16] ^ i_state[5/4 *32 +31: 5/4 *32 + 24];
assign o_state[(4*8 + 7) : 4*8] = by2(i_state[4/4 *32 + 7: 4/4 *32]) ^ i_state[4/4 *32 +15: 4/4 *32 + 8] ^ i_state[4/4 *32 +23: 4/4 *32 + 16] ^ by3(i_state[4/4 *32 +31: 4/4 *32 + 24]);

assign o_state[(3*8 + 7) : 3*8] = i_state[3/4 *32 + 7: 3/4 *32] ^ i_state[3/4 *32 +15: 3/4 *32 + 8] ^ by3(i_state[3/4 *32 +23: 3/4 *32 + 16]) ^ by2(i_state[3/4 *32 +31: 3/4 *32 + 24]);
assign o_state[(2*8 + 7) : 2*8] = i_state[2/4 *32 + 7: 2/4 *32] ^ by3(i_state[2/4 *32 +15: 2/4 *32 + 8]) ^ by2(i_state[2/4 *32 +23: 2/4 *32 + 16]) ^ i_state[2/4 *32 +31: 2/4 *32 + 24];
assign o_state[(1*8 + 7) : 1*8] = by3(i_state[1/4 *32 + 7: 1/4 *32]) ^ by2(i_state[1/4 *32 +15: 1/4 *32 + 8]) ^ i_state[1/4 *32 +23: 1/4 *32 + 16] ^ i_state[1/4 *32 +31: 1/4 *32 + 24];
assign o_state[(0*8 + 7) : 0*8] = by2(i_state[0/4 *32 + 7: 0/4 *32]) ^ i_state[0/4 *32 +15: 0/4 *32 + 8] ^ i_state[0/4 *32 +23: 0/4 *32 + 16] ^ by3(i_state[0/4 *32 +31: 0/4 *32 + 24]);

endmodule