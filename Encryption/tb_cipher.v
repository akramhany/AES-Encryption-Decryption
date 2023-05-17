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
reg clk;
reg [3:0]nr ;

reg [1919:0] i_key;
reg [127:0] i_data;
wire [127:0] o_data;
reg sync;
reg [127:0] expected_output;

cipher enc (
.expanded_key(i_key),
.NR(nr),
.sync(sync),
.clk(clk),
.i_data(i_data),
.o_data(o_data)
);

initial begin
    clk =0;
    nr = 4'd14;
    i_data = 128'h00112233445566778899aabbccddeeff;
    i_key = 1920'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1fa573c29fa176c498a97fce93a572c09c1651a8cd0244beda1a5da4c10640badeae87dff00ff11b68a68ed5fb03fc15676de1f1486fa54f9275f8eb5373b8518dc656827fc9a799176f294cec6cd5598b3de23a75524775e727bf9eb45407cf390bdc905fc27b0948ad5245a4c1871c2f45f5a66017b2d387300d4d33640a820a7ccff71cbeb4fe5413e6bbf0d261a7dff01afafee7a82979d7a5644ab3afe6402541fe719bf500258813bbd55a721c0a4e5a6699a9f24fe07e572baacdf8cdea24fc79ccbf0979e9371ac23c6d68de36;
    #10 sync = 1;
    #10 sync = 0;
    expected_output = 128'h8ea2b7ca516745bfeafc49904b496089;
    #10;
end
always #5 clk = ~clk;



initial begin
    #1100;
    if (o_data == expected_output) begin
        $display("Test Passed!!!");
    end 
    else begin
        $display("Test Failed: Expected output = %h, Actual output = %h", expected_output, o_data);
    end
    $display("i_key = %h, i_data = %h, o_data = %h", i_key, i_data, o_data);
    $finish;
end
endmodule