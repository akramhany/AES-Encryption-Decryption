


module inv_cipher #(
    parameter NK = 4,
    parameter NR = 10
    ) 
(
    i_data,
    i_key,
    o_data
);
input wire [(32 * NK) - 1 : 0]i_key;
input wire [127:0]i_data;
output wire [127:0]o_data;

wire [(4 * (NR + 1) * 32) - 1 : 0] expanded_key;
key_expansion #(NK, NR) expand(.i_cypher_key(i_key), .o_expanded_key(expanded_key));

//128-bit NR and NR-1 long arrays to organize data transmission between the instantiated objects
wire [127:0]temp_state[0:NR];
wire [127:0]sub_out[0:NR-1];
wire [127:0]shift_out[0:NR-1];
wire [127:0]round_out[0:NR-1];

add_round_key add(.i_state(i_data), .i_key(expanded_key[127 :0]), .o_state(temp_state[0][127:0]));

genvar i;
generate
    for(i = 1; i < NR ; i = i + 1) begin : loop_inv_cipher
        inv_shift_rows shift(.i_state(temp_state[i-1][127:0]), .o_state(shift_out[i-1][127:0]));
        inv_sub_bytes sub(.i_initial_state(shift_out[i-1][127:0]), .o_result_state(sub_out[i-1][127:0]));
        add_round_key add2(.i_state(sub_out[i-1][127:0]), .i_key(expanded_key[(4 * (NR + 1) * 32) - 1 -128*(NR - i) -:128]), .o_state(round_out[i-1][127:0]));
        inv_mix_columns mix(.i_state(round_out[i-1][127:0]), .o_state(temp_state[i][127:0]));
    end

    wire [127:0]sub_out_f;
    wire [127:0]shift_out_f;
    wire [127:0]key_out_f;
    inv_shift_rows shift(.i_state(temp_state[NR-1]), .o_state(shift_out_f));
    inv_sub_bytes sub(.i_initial_state(shift_out_f), .o_result_state(sub_out_f));
    add_round_key add2(.i_state(sub_out_f), .i_key(expanded_key[(4 * (NR + 1) * 32) - 1 -:128]), .o_state(key_out_f));

endgenerate

assign o_data = key_out_f;

endmodule
