/*
   *
   * Module: cipher
   * Description: This module performs the encryption operation on the input data, provided the key.
   * Parameters:
   *    NK: Number of words in the key
   *    NR: Number of rounds used in encryption
   * Inputs:
   *     i_data: 128-bit input data
   *     i_key: (128||192||256)-bit key
   * Outputs:
   *     o_data: 128-bit output data after encryption
   * Author: Adham Hussin
   * Date: 4/5/2023 
*/

`include "../key_expansion.v"
`include "../add_round_key.v"
`include "sub_bytes.v"
`include "shift_rows.v"
`include "mix_columns.v"

module cipher #(
    parameter NK = 4,
    parameter NR = 10
    ) 
(
    i_key,
    i_data,
    o_data
);
input wire [(32 * NK) - 1 : 0]i_key;
input wire [127:0]i_data;
output wire [127:0]o_data;

wire [(4 * (NR + 1) * 32) - 1 : 0]expanded_key;
key_expansion #(NK, NR) expand(.i_cypher_key(i_key), .o_expanded_key(expanded_key));

//128-bit NR and NR-1 long arrays to organize data transmission between the instantiated objects
wire [127:0]temp_state[0:NR];
wire [127:0]sub_out[0:NR-1];
wire [127:0]shift_out[0:NR-1];
wire [127:0]mix_out[0:NR-1];

add_round_key add(.i_state(i_data), .i_key(expanded_key[(4 * (NR + 1) * 32) - 1 -:128]), .o_state(temp_state[0][127:0]));

genvar i;
generate
    for(i = 1; i< NR ; i = i + 1) begin
        sub_bytes sub(.i_initial_state(temp_state[i-1][127:0]), .o_result_state(sub_out[i-1][127:0]));
        shift_rows shift(.i_state(sub_out[i-1][127:0]), .o_state(shift_out[i-1][127:0]));
        mix_columns mix(.i_state(shift_out[i-1][127:0]), .o_state(mix_out[i-1][127:0]));
        add_round_key add2(.i_state(mix_out[i-1][127:0]), .i_key(expanded_key[(4 * (NR + 1) * 32) - 1 -128*i -:128]), .o_state(temp_state[i][127:0]));
    end

    wire [127:0]sub_out_f;
    wire [127:0]shift_out_f;
    wire [127:0]key_out_f;
    sub_bytes sub(.i_initial_state(temp_state[NR-1]), .o_result_state(sub_out_f));
    shift_rows shift(.i_state(sub_out_f), .o_state(shift_out_f));
    add_round_key add2(.i_state(shift_out_f), .i_key(expanded_key[127:0]), .o_state(key_out_f));

endgenerate

assign o_data = key_out_f;

endmodule
