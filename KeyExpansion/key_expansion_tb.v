`include "key_expansion.v"
module key_expansion_tb();

reg [127:0] i_cypher_key;
wire [1407:0] o_expanded_key;

key_expansion ke(
    .i_cypher_key(i_cypher_key),
    .o_expanded_key(o_expanded_key)
);

initial begin
    i_cypher_key = 128'b00101011011111100001010100010110001010001010111011010010101001101010101111110111000101011000100000001001110011110100111100111100;
    #100
    $display("out: ", o_expanded_key[200:100]);
    #10
    $finish;
end


endmodule