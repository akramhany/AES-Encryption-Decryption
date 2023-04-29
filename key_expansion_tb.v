/*
   *
   * Module: key_expansion_tb
   * Description: The module responsible for testing the key_expansion.
   * Author: Akram
   * Date: 29/4/2023 
*/

`include "key_expansion.v"
module key_expansion_tb();

reg [127 : 0] i_cypher_key_1;
wire [1407 : 0] o_expanded_key_1;

reg [255 : 0] i_cypher_key_3;
wire [1919 : 0] o_expanded_key_3;



key_expansion #(.NK(4), .NR(10)) ke1 (
    .i_cypher_key(i_cypher_key_1),
    .o_expanded_key(o_expanded_key_1)
);

key_expansion #(.NK(8), .NR(14)) ke3 (
    .i_cypher_key(i_cypher_key_3),
    .o_expanded_key(o_expanded_key_3)
);



initial begin

    i_cypher_key_1 = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    i_cypher_key_3 = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;

    #100;
    $display("Testcase 0");
    $display("Input:           %h", i_cypher_key_1);
    $display("Expected Output: %h", 1408'h2b7e151628aed2a6abf7158809cf4f3ca0fafe1788542cb123a339392a6c7605f2c295f27a96b9435935807a7359f67f3d80477d4716fe3e1e237e446d7a883bef44a541a8525b7fb671253bdb0bad00d4d1c6f87c839d87caf2b8bc11f915bc6d88a37a110b3efddbf98641ca0093fd4e54f70e5f5fc9f384a64fb24ea6dc4fead27321b58dbad2312bf5607f8d292fac7766f319fadc2128d12941575c006ed014f9a8c9ee2589e13f0cc8b6630ca6);
    $display("Got:             %h", o_expanded_key_1);
    if (o_expanded_key_1 != 1408'h2b7e151628aed2a6abf7158809cf4f3ca0fafe1788542cb123a339392a6c7605f2c295f27a96b9435935807a7359f67f3d80477d4716fe3e1e237e446d7a883bef44a541a8525b7fb671253bdb0bad00d4d1c6f87c839d87caf2b8bc11f915bc6d88a37a110b3efddbf98641ca0093fd4e54f70e5f5fc9f384a64fb24ea6dc4fead27321b58dbad2312bf5607f8d292fac7766f319fadc2128d12941575c006ed014f9a8c9ee2589e13f0cc8b6630ca6) begin
      $display("Testcase 0 failed");
    end
    else begin
      $display("Testcase 0 passed");
    end

    $display("=================================================");

    $display("Testcase 1");
    $display("Input:           %h", i_cypher_key_3);
    $display("Expected Output: %h", 1920'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff49ba354118e6925afa51a8b5f2067fcdea8b09c1a93d194cdbe49846eb75d5b9ad59aecb85bf3c917fee94248de8ebe96b5a9328a2678a647983122292f6c79b3812c81addadf48ba24360af2fab8b46498c5bfc9bebd198e268c3ba709e0421468007bacb2df331696e939e46c518d80c814e20476a9fb8a5025c02d59c58239de1369676ccc5a71fa2563959674ee155886ca5d2e2f31d77e0af1fa27cf73c3749c47ab18501ddae2757e4f7401905acafaaae3e4d59b349adf6acebd10190dfe4890d1e6188d0b046df344706c631e);
    $display("Got:             %h", o_expanded_key_3);
    if (o_expanded_key_3 != 1920'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff49ba354118e6925afa51a8b5f2067fcdea8b09c1a93d194cdbe49846eb75d5b9ad59aecb85bf3c917fee94248de8ebe96b5a9328a2678a647983122292f6c79b3812c81addadf48ba24360af2fab8b46498c5bfc9bebd198e268c3ba709e0421468007bacb2df331696e939e46c518d80c814e20476a9fb8a5025c02d59c58239de1369676ccc5a71fa2563959674ee155886ca5d2e2f31d77e0af1fa27cf73c3749c47ab18501ddae2757e4f7401905acafaaae3e4d59b349adf6acebd10190dfe4890d1e6188d0b046df344706c631e) begin
      $display("Testcase 1 failed");
    end
    else begin
      $display("Testcase 1 passed");
    end

    #10
    $finish;
end


endmodule