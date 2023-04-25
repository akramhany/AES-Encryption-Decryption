module sbox (
    input wire [7:0] in_toSub,
    output wire [7:0] out_Subed
);
    
    assign out_Subed = (in_toSub == 8'h00) ? 8'h63 :
                       (in_toSub == 8'h01) ? 8'h7c :
                       (in_toSub == 8'h02) ? 8'h77 :
                       (in_toSub == 8'h03) ? 8'h7b :
                       (in_toSub == 8'h04) ? 8'hf2 :
                       (in_toSub == 8'h05) ? 8'h6b :
                       (in_toSub == 8'h06) ? 8'h6f :
                       (in_toSub == 8'h07) ? 8'hc5 :
                       (in_toSub == 8'h08) ? 8'h30 :
                       (in_toSub == 8'h09) ? 8'h01 :
                       (in_toSub == 8'h0a) ? 8'h67 :
                       (in_toSub == 8'h0b) ? 8'h2b :
                       (in_toSub == 8'h0c) ? 8'hfe :
                       (in_toSub == 8'h0d) ? 8'hd7 :
                       (in_toSub == 8'h0e) ? 8'hab :
                       (in_toSub == 8'h0f) ? 8'h76 :
                       //the first row
                       (in_toSub == 8'h10) ? 8'hca :
                       (in_toSub == 8'h11) ? 8'h82 :
                       (in_toSub == 8'h12) ? 8'hc9 :
                       (in_toSub == 8'h13) ? 8'h7d :
                       (in_toSub == 8'h14) ? 8'hfa :
                       (in_toSub == 8'h15) ? 8'h59 :
                       (in_toSub == 8'h16) ? 8'h47 :
                       (in_toSub == 8'h17) ? 8'hf0 :
                       (in_toSub == 8'h18) ? 8'had :
                       (in_toSub == 8'h19) ? 8'hd4 :
                       (in_toSub == 8'h1a) ? 8'ha2 :
                       (in_toSub == 8'h1b) ? 8'haf :
                       (in_toSub == 8'h1c) ? 8'h9c :
                       (in_toSub == 8'h1d) ? 8'ha4 :
                       (in_toSub == 8'h1e) ? 8'h72 :
                       (in_toSub == 8'h1f) ? 8'hc0 :
                       //the second row
                       (in_toSub == 8'h20) ? 8'hb7 :
                       (in_toSub == 8'h21) ? 8'hfd :
                       (in_toSub == 8'h22) ? 8'h93 :
                       (in_toSub == 8'h23) ? 8'h26 :
                       (in_toSub == 8'h24) ? 8'h36 :
                       (in_toSub == 8'h25) ? 8'h3f :
                       (in_toSub == 8'h26) ? 8'hf7 :
                       (in_toSub == 8'h27) ? 8'hcc :
                       (in_toSub == 8'h28) ? 8'h34 :
                       (in_toSub == 8'h29) ? 8'ha5 :
                       (in_toSub == 8'h2a) ? 8'he5 :
                       (in_toSub == 8'h2b) ? 8'hf1 :
                       (in_toSub == 8'h2c) ? 8'h71 :
                       (in_toSub == 8'h2d) ? 8'hd8 :
                       (in_toSub == 8'h2e) ? 8'h31 :
                       (in_toSub == 8'h2f) ? 8'h15 :
                       //row 3
                       (in_toSub == 8'h30) ? 8'h04 :
                       (in_toSub == 8'h31) ? 8'hc7 :
                       (in_toSub == 8'h32) ? 8'h23 :
                       (in_toSub == 8'h33) ? 8'hc3 :
                       (in_toSub == 8'h34) ? 8'h18 :
                       (in_toSub == 8'h35) ? 8'h96 :
                       (in_toSub == 8'h36) ? 8'h05 :
                       (in_toSub == 8'h37) ? 8'h9a :
                       (in_toSub == 8'h38) ? 8'h07 :
                       (in_toSub == 8'h39) ? 8'h12 :
                       (in_toSub == 8'h3a) ? 8'h80 :
                       (in_toSub == 8'h3b) ? 8'he2 :
                       (in_toSub == 8'h3c) ? 8'heb :
                       (in_toSub == 8'h3d) ? 8'h27 :
                       (in_toSub == 8'h3e) ? 8'hb2 :
                       (in_toSub == 8'h3f) ? 8'h75 :
                       //row 4
                       (in_toSub == 8'h40) ? 8'h09 :
                       (in_toSub == 8'h41) ? 8'h83 :
                       (in_toSub == 8'h42) ? 8'h2c :
                       (in_toSub == 8'h43) ? 8'h1a :
                       (in_toSub == 8'h44) ? 8'h1b :
                       (in_toSub == 8'h45) ? 8'h6e :
                       (in_toSub == 8'h46) ? 8'h5a :
                       (in_toSub == 8'h47) ? 8'ha0 :
                       (in_toSub == 8'h48) ? 8'h52 :
                       (in_toSub == 8'h49) ? 8'h3b :
                       (in_toSub == 8'h4a) ? 8'hd6 :
                       (in_toSub == 8'h4b) ? 8'hb3 :
                       (in_toSub == 8'h4c) ? 8'h29 :
                       (in_toSub == 8'h4d) ? 8'he3 :
                       (in_toSub == 8'h4e) ? 8'h2f :
                       (in_toSub == 8'h4f) ? 8'h84 :
                       //row 5
                       (in_toSub == 8'h50) ? 8'h53 :
                       (in_toSub == 8'h51) ? 8'hd1 :
                       (in_toSub == 8'h52) ? 8'h00 :
                       (in_toSub == 8'h53) ? 8'hed :
                       (in_toSub == 8'h54) ? 8'h20 :
                       (in_toSub == 8'h55) ? 8'hfc :
                       (in_toSub == 8'h56) ? 8'hb1 :
                       (in_toSub == 8'h57) ? 8'h5b :
                       (in_toSub == 8'h58) ? 8'h6a :
                       (in_toSub == 8'h59) ? 8'hcb :
                       (in_toSub == 8'h5a) ? 8'hbe :
                       (in_toSub == 8'h5b) ? 8'h39 :
                       (in_toSub == 8'h5c) ? 8'h4a :
                       (in_toSub == 8'h5d) ? 8'h4c :
                       (in_toSub == 8'h5e) ? 8'h58 :
                       (in_toSub == 8'h5f) ? 8'hcf :
                       //row 6 of index 5
                       (in_toSub == 8'h60) ? 8'hd0 :
                       (in_toSub == 8'h61) ? 8'hef :
                       (in_toSub == 8'h62) ? 8'haa :
                       (in_toSub == 8'h63) ? 8'hfb :
                       (in_toSub == 8'h64) ? 8'h43 :
                       (in_toSub == 8'h65) ? 8'h4d :
                       (in_toSub == 8'h66) ? 8'h33 :
                       (in_toSub == 8'h67) ? 8'h85 :
                       (in_toSub == 8'h68) ? 8'h45 :
                       (in_toSub == 8'h69) ? 8'hf9 :
                       (in_toSub == 8'h6a) ? 8'h02 :
                       (in_toSub == 8'h6b) ? 8'h7f :
                       (in_toSub == 8'h6c) ? 8'h50 :
                       (in_toSub == 8'h6d) ? 8'h3c :
                       (in_toSub == 8'h6e) ? 8'h9f :
                       (in_toSub == 8'h6f) ? 8'ha8 :
                       //row 7 of index 6
                       (in_toSub == 8'h70) ? 8'h51 :
                       (in_toSub == 8'h71) ? 8'ha3 :
                       (in_toSub == 8'h72) ? 8'h40 :
                       (in_toSub == 8'h73) ? 8'h8f :
                       (in_toSub == 8'h74) ? 8'h92 :
                       (in_toSub == 8'h75) ? 8'h9d :
                       (in_toSub == 8'h76) ? 8'h38 :
                       (in_toSub == 8'h77) ? 8'hf5 :
                       (in_toSub == 8'h78) ? 8'hbc :
                       (in_toSub == 8'h79) ? 8'hb6 :
                       (in_toSub == 8'h7a) ? 8'hda :
                       (in_toSub == 8'h7b) ? 8'h21 :
                       (in_toSub == 8'h7c) ? 8'h10 :
                       (in_toSub == 8'h7d) ? 8'hff :
                       (in_toSub == 8'h7e) ? 8'hf3 :
                       (in_toSub == 8'h7f) ? 8'hd2 :
                       //row 8 of index 7
                       (in_toSub == 8'h80) ? 8'hcd :
                       (in_toSub == 8'h81) ? 8'h0c :
                       (in_toSub == 8'h82) ? 8'h13 :
                       (in_toSub == 8'h83) ? 8'hec :
                       (in_toSub == 8'h84) ? 8'h5f :
                       (in_toSub == 8'h85) ? 8'h97 :
                       (in_toSub == 8'h86) ? 8'h44 :
                       (in_toSub == 8'h87) ? 8'h17 :
                       (in_toSub == 8'h88) ? 8'hc4 :
                       (in_toSub == 8'h89) ? 8'ha7 :
                       (in_toSub == 8'h8a) ? 8'h7e :
                       (in_toSub == 8'h8b) ? 8'h3d :
                       (in_toSub == 8'h8c) ? 8'h64 :
                       (in_toSub == 8'h8d) ? 8'h5d :
                       (in_toSub == 8'h8e) ? 8'h19 :
                       (in_toSub == 8'h8f) ? 8'h73 :
                       //row 9 of index 8
                       (in_toSub == 8'h90) ? 8'h60 :
                       (in_toSub == 8'h91) ? 8'h81 :
                       (in_toSub == 8'h92) ? 8'h4f :
                       (in_toSub == 8'h93) ? 8'hdc :
                       (in_toSub == 8'h94) ? 8'h22 :
                       (in_toSub == 8'h95) ? 8'h2a :
                       (in_toSub == 8'h96) ? 8'h90 :
                       (in_toSub == 8'h97) ? 8'h88 :
                       (in_toSub == 8'h98) ? 8'h46 :
                       (in_toSub == 8'h99) ? 8'hee :
                       (in_toSub == 8'h9a) ? 8'hb8 :
                       (in_toSub == 8'h9b) ? 8'h14 :
                       (in_toSub == 8'h9c) ? 8'hde :
                       (in_toSub == 8'h9d) ? 8'h5e :
                       (in_toSub == 8'h9e) ? 8'h0b :
                       (in_toSub == 8'h9f) ? 8'hdb :
                       //row 10 of index 9
                       (in_toSub == 8'ha0) ? 8'he0 :
                       (in_toSub == 8'ha1) ? 8'h32 :
                       (in_toSub == 8'ha2) ? 8'h3a :
                       (in_toSub == 8'ha3) ? 8'h0a :
                       (in_toSub == 8'ha4) ? 8'h49 :
                       (in_toSub == 8'ha5) ? 8'h06 :
                       (in_toSub == 8'ha6) ? 8'h24 :
                       (in_toSub == 8'ha7) ? 8'h5c :
                       (in_toSub == 8'ha8) ? 8'hc2 :
                       (in_toSub == 8'ha9) ? 8'hd3 :
                       (in_toSub == 8'haa) ? 8'hac :
                       (in_toSub == 8'hab) ? 8'h62 :
                       (in_toSub == 8'hac) ? 8'h91 :
                       (in_toSub == 8'had) ? 8'h95 :
                       (in_toSub == 8'hae) ? 8'he4 :
                       (in_toSub == 8'haf) ? 8'h79 :
                       //row 11 of index a
                       (in_toSub == 8'hb0) ? 8'he7 :
                       (in_toSub == 8'hb1) ? 8'hc8 :
                       (in_toSub == 8'hb2) ? 8'h37 :
                       (in_toSub == 8'hb3) ? 8'h6d :
                       (in_toSub == 8'hb4) ? 8'h8d :
                       (in_toSub == 8'hb5) ? 8'hd5 :
                       (in_toSub == 8'hb6) ? 8'h4e :
                       (in_toSub == 8'hb7) ? 8'ha9 :
                       (in_toSub == 8'hb8) ? 8'h6c :
                       (in_toSub == 8'hb9) ? 8'h56 :
                       (in_toSub == 8'hba) ? 8'hf4 :
                       (in_toSub == 8'hbb) ? 8'hea :
                       (in_toSub == 8'hbc) ? 8'h65 :
                       (in_toSub == 8'hbd) ? 8'h7a :
                       (in_toSub == 8'hbe) ? 8'hae :
                       (in_toSub == 8'hbf) ? 8'h08 :
                       //row 12 of index b
                       (in_toSub == 8'hc0) ? 8'hba :
                       (in_toSub == 8'hc1) ? 8'h78 :
                       (in_toSub == 8'hc2) ? 8'h25 :
                       (in_toSub == 8'hc3) ? 8'h2e :
                       (in_toSub == 8'hc4) ? 8'h1c :
                       (in_toSub == 8'hc5) ? 8'ha6 :
                       (in_toSub == 8'hc6) ? 8'hb4 :
                       (in_toSub == 8'hc7) ? 8'hc6 :
                       (in_toSub == 8'hc8) ? 8'he8 :
                       (in_toSub == 8'hc9) ? 8'hdd :
                       (in_toSub == 8'hca) ? 8'h74 :
                       (in_toSub == 8'hcb) ? 8'h1f :
                       (in_toSub == 8'hcc) ? 8'h4b :
                       (in_toSub == 8'hcd) ? 8'hbd :
                       (in_toSub == 8'hce) ? 8'h8b :
                       (in_toSub == 8'hcf) ? 8'h8a :
                       //row 13 of index c
                       (in_toSub == 8'hd0) ? 8'h70 :
                       (in_toSub == 8'hd1) ? 8'h3e :
                       (in_toSub == 8'hd2) ? 8'hb5 :
                       (in_toSub == 8'hd3) ? 8'h66 :
                       (in_toSub == 8'hd4) ? 8'h48 :
                       (in_toSub == 8'hd5) ? 8'h03 :
                       (in_toSub == 8'hd6) ? 8'hf6 :
                       (in_toSub == 8'hd7) ? 8'h0e :
                       (in_toSub == 8'hd8) ? 8'h61 :
                       (in_toSub == 8'hd9) ? 8'h35 :
                       (in_toSub == 8'hda) ? 8'h57 :
                       (in_toSub == 8'hdb) ? 8'hb9 :
                       (in_toSub == 8'hdc) ? 8'h86 :
                       (in_toSub == 8'hdd) ? 8'hc1 :
                       (in_toSub == 8'hde) ? 8'h1d :
                       (in_toSub == 8'hdf) ? 8'h9e :
                       //row 14 of index d
                       (in_toSub == 8'he0) ? 8'he1 :
                       (in_toSub == 8'he1) ? 8'hf8 :
                       (in_toSub == 8'he2) ? 8'h98 :
                       (in_toSub == 8'he3) ? 8'h11 :
                       (in_toSub == 8'he4) ? 8'h69 :
                       (in_toSub == 8'he5) ? 8'hd9 :
                       (in_toSub == 8'he6) ? 8'h8e :
                       (in_toSub == 8'he7) ? 8'h94 :
                       (in_toSub == 8'he8) ? 8'h9b :
                       (in_toSub == 8'he9) ? 8'h1e :
                       (in_toSub == 8'hea) ? 8'h87 :
                       (in_toSub == 8'heb) ? 8'he9 :
                       (in_toSub == 8'hec) ? 8'hce :
                       (in_toSub == 8'hed) ? 8'h55 :
                       (in_toSub == 8'hee) ? 8'h28 :
                       (in_toSub == 8'hef) ? 8'hdf :
                       //row 15 of index e
                       (in_toSub == 8'hf0) ? 8'h8c :
                       (in_toSub == 8'hf1) ? 8'ha1 :
                       (in_toSub == 8'hf2) ? 8'h89 :
                       (in_toSub == 8'hf3) ? 8'h0d :
                       (in_toSub == 8'hf4) ? 8'hbf :
                       (in_toSub == 8'hf5) ? 8'he6 :
                       (in_toSub == 8'hf6) ? 8'h42 :
                       (in_toSub == 8'hf7) ? 8'h68 :
                       (in_toSub == 8'hf8) ? 8'h41 :
                       (in_toSub == 8'hf9) ? 8'h99 :
                       (in_toSub == 8'hfa) ? 8'h2d :
                       (in_toSub == 8'hfb) ? 8'h0f :
                       (in_toSub == 8'hfc) ? 8'hb0 :
                       (in_toSub == 8'hfd) ? 8'h54 :
                       (in_toSub == 8'hfe) ? 8'hbb :
                       (in_toSub == 8'hff) ? 8'h16 :
                       8'bxxxxxxxx;
                       //row 16 of index f
endmodule