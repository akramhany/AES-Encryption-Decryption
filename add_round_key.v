/*
  *
  * Module: add_round_key
  * Description: it takes a state and a key each 128 bits and xor's them
  * 
  * Inputs:
  *   i_state: state
  *   i_key: key
  * Outputs:
  *   o_state: state
  *
  * Author: Akram
  * Date: 28/4/2023
*/

module add_round_key (
    i_state,
    i_key,
    o_state
);

input wire [127:0] i_state, i_key;
output wire [127:0] o_state;

assign o_state = i_state ^ i_key;

endmodule