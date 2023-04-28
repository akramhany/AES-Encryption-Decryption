`include "rot_word.v"
`include "../Encryption/sub_word.v"
module key_expansion #(
    parameter NK = 4,
    parameter NR = 10
    ) 
(
    i_cypher_key,
    o_expanded_key
);

input wire [(32 * NK) - 1 : 0] i_cypher_key;
output wire [(4 * (NR + 1) * 32) - 1 : 0] o_expanded_key;     

function automatic [31:0] rcon (
    input [3:0]  i_round_number
);
begin
    rcon = 32'd0;
    rcon [31:24] = (i_round_number == 4'd1 ) ? 8'h01:
                   (i_round_number == 4'd2 ) ? 8'h02:
                   (i_round_number == 4'd3 ) ? 8'h04:
                   (i_round_number == 4'd4 ) ? 8'h08:
                   (i_round_number == 4'd5 ) ? 8'h10:
                   (i_round_number == 4'd6 ) ? 8'h20:
                   (i_round_number == 4'd7 ) ? 8'h40:
                   (i_round_number == 4'd8 ) ? 8'h80:
                   (i_round_number == 4'd9 ) ? 8'h1b:
                   (i_round_number == 4'd10) ? 8'h36:
                   8'bxxxxxxxx;
end
endfunction

genvar i;


generate
    for (i = 0; i < NK; i = i + 1) begin
        assign o_expanded_key[((i + 1) * 32) - 1 : (i * 32)] = i_cypher_key[((i + 1) * 32) - 1 : (i * 32)];
    end
endgenerate

wire [31:0] temp1, temp2, temp3, temp4, temp5, temp6;

generate
    for (i = NK; i < 4 * (NR + 1); i = i + 1) begin
        assign temp1 = o_expanded_key[((i) * 32) - 1 : ((i-1) * 32)];
        assign temp5 = temp1;
        if (i % NK == 0) begin
            rot_word rw (
                .i_word(temp1),
                .o_word(temp2)
            );
            sub_word sw (
                .i_word(temp2),
                .o_word(temp3)
            );
            assign temp4 = rcon(i / NK);
            assign temp5 = temp3 ^ temp4;
        end 
        else if (NK > 6 && i % NK == 4) begin 
            sub_word sww (
                .i_word(temp1),
                .o_word(temp5)
            );
        end
        assign temp6 = o_expanded_key[(((i - NK) + 1) * 32) - 1 : ((i - NK) * 32)];
        assign o_expanded_key[((i + 1) * 32) - 1 : (i * 32)] = temp5 ^ temp6;
    end
endgenerate


endmodule