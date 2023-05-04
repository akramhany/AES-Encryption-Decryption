/*
   *
   * Module: tb_cipher
   * Description: This module tests the encryption operation on the input data, provided the key.
   * Inputs: N/A
   * Outputs: N/A
   * Author: Adham Hussin
   * Date: 4/5/2023 
*/
`include "cipher.v"
`timescale 1ns/1ps
module tb_cipher();
parameter nk = 8;
parameter nr = 14;

reg [(32 * nk) - 1 : 0] i_key;
reg [127:0] i_data;
wire [127:0] o_data;
reg [127:0] expected_output;

cipher #(nk, nr) enc (
.i_key(i_key),
.i_data(i_data),
.o_data(o_data)
);

initial begin
    i_data = 128'h00112233445566778899aabbccddeeff;
    i_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    expected_output = 128'h8ea2b7ca516745bfeafc49904b496089;
    #10;
end

always @(*) begin
    $display("i_key = %h, i_data = %h, o_data = %h", i_key, i_data, o_data);
end

initial begin
    #20;
    if (o_data == expected_output) begin
        $display("Test Passed!!!");
    end 
    else begin
        $display("Test Failed: Expected output = %h, Actual output = %h", expected_output, o_data);
    end
    $finish;
end
endmodule