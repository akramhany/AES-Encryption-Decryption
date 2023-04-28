`include "InvSBox.v"

module inv_sub_bytes (
    input wire [127:0] i_initial_state,
    output reg [127:0] o_result_state
);

/*
    this module takes every byte in the i_initial_state
    and substitue it using the inv_sbox
*/
    
//these wires are going to be inputs to the InvSBox objects
wire [7:0] byte_0, byte_1, byte_2, byte_3, byte_4, byte_5, byte_6, byte_7, byte_8;
wire [7:0] byte_9, byte_10, byte_11, byte_12, byte_13, byte_14, byte_15;

// here I instantiated an object for every byte
InvSBox byte_0_sub  (.in_toSub(i_initial_state [127:120]) , .out_Subed(byte_0 ) );
InvSBox byte_1_sub  (.in_toSub(i_initial_state [119:112]) , .out_Subed(byte_1 ) );
InvSBox byte_2_sub  (.in_toSub(i_initial_state [111:104]) , .out_Subed(byte_2 ) );
InvSBox byte_3_sub  (.in_toSub(i_initial_state [103:96] ) , .out_Subed(byte_3 ) );
InvSBox byte_4_sub  (.in_toSub(i_initial_state [95:88]  ) , .out_Subed(byte_4 ) );
InvSBox byte_5_sub  (.in_toSub(i_initial_state [87:80]  ) , .out_Subed(byte_5 ) );
InvSBox byte_6_sub  (.in_toSub(i_initial_state [79:72]  ) , .out_Subed(byte_6 ) );
InvSBox byte_7_sub  (.in_toSub(i_initial_state [71:64]  ) , .out_Subed(byte_7 ) );
InvSBox byte_8_sub  (.in_toSub(i_initial_state [63:56]  ) , .out_Subed(byte_8 ) );
InvSBox byte_9_sub  (.in_toSub(i_initial_state [55:48]  ) , .out_Subed(byte_9 ) );
InvSBox byte_10_sub (.in_toSub(i_initial_state [47:40]  ) , .out_Subed(byte_10) );
InvSBox byte_11_sub (.in_toSub(i_initial_state [39:32]  ) , .out_Subed(byte_11) );
InvSBox byte_12_sub (.in_toSub(i_initial_state [31:24]  ) , .out_Subed(byte_12) );
InvSBox byte_13_sub (.in_toSub(i_initial_state [23:16]  ) , .out_Subed(byte_13) );
InvSBox byte_14_sub (.in_toSub(i_initial_state [15:8]   ) , .out_Subed(byte_14) );
InvSBox byte_15_sub (.in_toSub(i_initial_state [7:0]    ) , .out_Subed(byte_15) );

always @* begin
    o_result_state [127:120] = byte_0  ;
    o_result_state [119:112] = byte_1  ;
    o_result_state [111:104] = byte_2  ;
    o_result_state [103:96]  = byte_3  ;
    o_result_state [95:88]   = byte_4  ;
    o_result_state [87:80]   = byte_5  ;
    o_result_state [79:72]   = byte_6  ;
    o_result_state [71:64]   = byte_7  ;
    o_result_state [63:56]   = byte_8  ;
    o_result_state [55:48]   = byte_9  ;
    o_result_state [47:40]   = byte_10 ;
    o_result_state [39:32]   = byte_11 ;
    o_result_state [31:24]   = byte_12 ;
    o_result_state [23:16]   = byte_13 ;
    o_result_state [15:8]    = byte_14 ;
    o_result_state [7:0]     = byte_15 ;
end

endmodule