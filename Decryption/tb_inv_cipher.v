`include "inv_cipher.v"

module tb_inv_cipher;

reg [127:0] tb_state_0, tb_state_1, tb_state_2, tb_cipher_key_0;
reg [191:0] tb_cipher_key_1;
reg [255:0] tb_cipher_key_2;
wire [127:0] result_0, result_1, result_2;

inv_cipher #(4, 10) cipher_0 (
    .i_data(tb_state_0),
    .i_key(tb_cipher_key_0),
    .o_data(result_0)
);

inv_cipher #(6, 12) cipher_1 (
    .i_data(tb_state_1),
    .i_key(tb_cipher_key_1),
    .o_data(result_1)
);

inv_cipher #(8, 14) cipher_2 (
    .i_data(tb_state_2),
    .i_key(tb_cipher_key_2),
    .o_data(result_2)
);

initial begin
    tb_state_0 = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    tb_cipher_key_0 = 128'h000102030405060708090a0b0c0d0e0f;

    tb_state_1 = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
    tb_cipher_key_1 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;

    tb_state_2 = 128'h8ea2b7ca516745bfeafc49904b496089;
    tb_cipher_key_2 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

    #10;
    $display("Testcase 0");
    $display("Input text:           %h", tb_state_0);
    $display("Input key :           %h", tb_cipher_key_0);
    $display("Expected Output: %h", 128'h00112233445566778899aabbccddeeff);
    $display("Got:             %h", result_0);
    if (result_0 != 128'h00112233445566778899aabbccddeeff) begin
      $display("Testcase 0 FAILED");
    end
    else begin
      $display("Testcase 0 PASSED");
    end

    $display("=================================================");

    $display("Testcase 1");
    $display("Input text:           %h", tb_state_1);
    $display("Input key :           %h", tb_cipher_key_1);
    $display("Expected Output: %h", 128'h00112233445566778899aabbccddeeff);
    $display("Got:             %h", result_1);
    if (result_1 != 128'h00112233445566778899aabbccddeeff) begin
      $display("Testcase 1 FAILED");
    end
    else begin
      $display("Testcase 1 PASSED");
    end

    $display("=================================================");

    
    $display("Testcase 2");
    $display("Input text:           %h", tb_state_2);
    $display("Input key :           %h", tb_cipher_key_2);
    $display("Expected Output: %h", 128'h00112233445566778899aabbccddeeff);
    $display("Got:             %h", result_2);
    if (result_2 != 128'h00112233445566778899aabbccddeeff) begin
      $display("Testcase 2 FAILED");
    end
    else begin
      $display("Testcase 2 PASSED");
    end

    $display("=================================================");

    #10;
end

initial begin
  #30;
  $finish;
end

endmodule
