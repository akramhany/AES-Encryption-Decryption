/*
    *
    * Module: system_basic_tb 
    * Description: this module is the testbench for the whole system running with delays
    * ==============================================
    * Author: Amir Kedis 
    * Date: 15 - May - 2023 
*/

`timescale 1ns / 1ps

`include "master.v"
`include "slave.v"
`include "Encryption/cipher.v"
`include "Decryption/inv_cipher.v"


module system_basic_tb;

localparam PERIOD = 10;

////////////////////////////// CLOCK //////////////////////////////
reg clk = 0;
always #(PERIOD / 2) clk = ~clk;

////////////////////////////// SIGNALS //////////////////////////////
// master
reg reset;
reg start;
wire buzy;
wire done;
wire slave_done;
reg [7:0] data_in;
wire [7:0] data_out;
wire cs;
wire mosi;
wire miso;
wire sclk;

reg [127:0] key_to_cipher;
reg [127:0] word_to_cipher;
wire [127:0] ciphered_word;
wire [127:0] deciphered_word;
reg [127:0] deciphered_word_recived;

////////////////////////////// DUT //////////////////////////////
master dut (
  .reset(reset),
  .clk(clk),
  .start(start),
  .buzy(buzy),
  .done(done),
  .data_in(data_in),
  .data_out(data_out),
  .cs(cs),
  .mosi(mosi),
  .miso(miso),
  .sclk(sclk)
);



reg [7:0] slave_data_in;
wire [7:0] slave_data_out;

//////////////////////////////
//       DUT SLAVES         //
//////////////////////////////
slave slave_dut (
  .reset(reset),
  .clk(clk),
  .cs(cs),
  .mosi(mosi),
  .miso(miso),
  .sclk(sclk),
  .data_in(slave_data_in),
  .data_out(slave_data_out),
  .done(slave_done)
);



cipher #(
  4,
  10
) cipher_dut (
  .i_data(word_to_cipher),
  .i_key(key_to_cipher),
  .o_data(ciphered_word)
);

inv_cipher #(
  4,
  10
) inv_cipher_dut (
  .i_data(ciphered_word),
  .i_key(key_to_cipher),
  .o_data(deciphered_word)
);

////////////////////////////// TESTBENCH CODE //////////////////////////////

wire [7:0] SPI_KEY [15:0];
assign SPI_KEY [0] = 8'h2b;
assign SPI_KEY [1] = 8'h7e;
assign SPI_KEY [2] = 8'h15;
assign SPI_KEY [3] = 8'h16;
assign SPI_KEY [4] = 8'h28;
assign SPI_KEY [5] = 8'hae;
assign SPI_KEY [6] = 8'hd2;
assign SPI_KEY [7] = 8'ha6;
assign SPI_KEY [8] = 8'hab;
assign SPI_KEY [9] = 8'hf7;
assign SPI_KEY [10] = 8'h15;
assign SPI_KEY [11] = 8'h88;
assign SPI_KEY [12] = 8'h09;
assign SPI_KEY [13] = 8'hcf;
assign SPI_KEY [14] = 8'h4f;
assign SPI_KEY [15] = 8'h3c;

wire [7:0] SPI_WORD [15:0];
assign SPI_WORD [0] = 8'h00;
assign SPI_WORD [1] = 8'h11;
assign SPI_WORD [2] = 8'h22;
assign SPI_WORD [3] = 8'h33;
assign SPI_WORD [4] = 8'h44;
assign SPI_WORD [5] = 8'h55;
assign SPI_WORD [6] = 8'h66;
assign SPI_WORD [7] = 8'h77;
assign SPI_WORD [8] = 8'h88;
assign SPI_WORD [9] = 8'h99;
assign SPI_WORD [10] = 8'haa;
assign SPI_WORD [11] = 8'hbb;
assign SPI_WORD [12] = 8'hcc;
assign SPI_WORD [13] = 8'hdd;
assign SPI_WORD [14] = 8'hee;
assign SPI_WORD [15] = 8'hff;


localparam SPI_KEY_SIZE = 128;

reg [7:0] SLAVE_RECEIVE_KEY [15:0];
reg [7:0] SLAVE_RECEIVE_WORD [15:0];
reg [7:0] MASTER_RECEIVE_WORD [15:0];
reg [7:0] CIPHERED_WORD [15:0];
reg [7:0] DECIPHERED_WORD [15:0];
reg [7:0] RECEIVED_DECIPHERED_WORD [15:0];


// transform to array of 128 bits


integer i;

reg isCorrect = 1;

initial begin
  reset = 1;
  start = 0;
  data_in = 8'h00;
  slave_data_in = 8'h00;

  // Wait
  #(5 * PERIOD) reset = 0;

  // Send key
  
  for (i = 0; i < SPI_KEY_SIZE / 8 ; i = i + 1) begin
    data_in = 0;
    slave_data_in = SPI_KEY[i];
    #(2 * PERIOD)start = 1;
    #(2 * PERIOD) start = 0;

    // Wait for slave to finish
    #(4 * 8 * PERIOD);

    SLAVE_RECEIVE_KEY [i] = data_out;
  end
  
  // Display key
  #10;

  $display("===========================================");
  $display("      DECRYPT: from master to slave2");
  $display("===========================================");

  $display("SENT Key:");

  for (i = 0; i < 15; i = i + 1) begin
    $write("%h", SPI_KEY[i]);
  end

  $display("");

  $display("RECE Key:");

  for (i = 0; i < 15; i = i + 1) begin
    $write("%h", SLAVE_RECEIVE_KEY[i]);
  end

  $display("");

  // check if the key is correct
  for (i = 0; i < 15; i = i + 1) begin
    if (SLAVE_RECEIVE_KEY[i] != SPI_KEY[i]) begin
      isCorrect = 0;
    end
  end

  if (isCorrect) begin
    $display("The key is correct");
  end else begin
    $display("The key is not correct");
  end

  // Send word
  for (i = 0; i < SPI_KEY_SIZE / 8 ; i = i + 1) begin
    data_in = 0;
    slave_data_in = SPI_WORD[i];
    #(2 * PERIOD)start = 1;
    #(2 * PERIOD) start = 0;

    // Wait for slave to finish
    #(4 * 8 * PERIOD);

    SLAVE_RECEIVE_WORD [i] = data_out;
  end

  // Display word
  #10;
  $display("SENT Word:");
  for (i = 0; i < 15; i = i + 1) begin
    $write("%h", SPI_WORD[i]);
  end

  $display("");

  $display("RECE Word:");
  for (i = 0; i < 15; i = i + 1) begin
    $write("%h", SLAVE_RECEIVE_WORD[i]);
  end

  $display("");

  word_to_cipher = {SLAVE_RECEIVE_WORD[0], SLAVE_RECEIVE_WORD[1], SLAVE_RECEIVE_WORD[2], SLAVE_RECEIVE_WORD[3], SLAVE_RECEIVE_WORD[4], SLAVE_RECEIVE_WORD[5], SLAVE_RECEIVE_WORD[6], SLAVE_RECEIVE_WORD[7], SLAVE_RECEIVE_WORD[8], SLAVE_RECEIVE_WORD[9], SLAVE_RECEIVE_WORD[10], SLAVE_RECEIVE_WORD[11], SLAVE_RECEIVE_WORD[12], SLAVE_RECEIVE_WORD[13], SLAVE_RECEIVE_WORD[14], SLAVE_RECEIVE_WORD[15]};
  key_to_cipher = {SLAVE_RECEIVE_KEY[0], SLAVE_RECEIVE_KEY[1], SLAVE_RECEIVE_KEY[2], SLAVE_RECEIVE_KEY[3], SLAVE_RECEIVE_KEY[4], SLAVE_RECEIVE_KEY[5], SLAVE_RECEIVE_KEY[6], SLAVE_RECEIVE_KEY[7], SLAVE_RECEIVE_KEY[8], SLAVE_RECEIVE_KEY[9], SLAVE_RECEIVE_KEY[10], SLAVE_RECEIVE_KEY[11], SLAVE_RECEIVE_KEY[12], SLAVE_RECEIVE_KEY[13], SLAVE_RECEIVE_KEY[14], SLAVE_RECEIVE_KEY[15]};

  
  $display("===========================================");
  $display("      ENCRYPT: from slave1 to master");
  $display("===========================================");

  $display("key sent to cipher: %h", key_to_cipher);
  $display("word sent to cipher: %h", word_to_cipher);

  // ciphered word is done send it to the master

  #(PERIOD * 5);

  $display("ciphered word: %h", ciphered_word);

  CIPHERED_WORD[0] = ciphered_word[127:120];
  CIPHERED_WORD[1] = ciphered_word[119:112];
  CIPHERED_WORD[2] = ciphered_word[111:104];
  CIPHERED_WORD[3] = ciphered_word[103:96];
  CIPHERED_WORD[4] = ciphered_word[95:88];
  CIPHERED_WORD[5] = ciphered_word[87:80];
  CIPHERED_WORD[6] = ciphered_word[79:72];
  CIPHERED_WORD[7] = ciphered_word[71:64];
  CIPHERED_WORD[8] = ciphered_word[63:56];
  CIPHERED_WORD[9] = ciphered_word[55:48];
  CIPHERED_WORD[10] = ciphered_word[47:40];
  CIPHERED_WORD[11] = ciphered_word[39:32];
  CIPHERED_WORD[12] = ciphered_word[31:24];
  CIPHERED_WORD[13] = ciphered_word[23:16];
  CIPHERED_WORD[14] = ciphered_word[15:8];
  CIPHERED_WORD[15] = ciphered_word[7:0];
  

  // send back to master
  for (i = 0; i < SPI_KEY_SIZE / 8 ; i = i + 1) begin
    data_in = 0;
    slave_data_in = CIPHERED_WORD[i];

    #(2 * PERIOD) start = 1;
    #(2 * PERIOD) start = 0;

    // Wait for slave to finish
    #(4 * 8 * PERIOD);

    MASTER_RECEIVE_WORD[i] = data_out;
  end

  $display("CIPHERED DATA RECEIVED AT MASTER: %h", ciphered_word);

  $display("===========================================");
  $display("      DECRYPT: from master to slave2");
  $display("===========================================");

  // send cihpered word to decrypt module from master
  for (i = 0; i < SPI_KEY_SIZE / 8 ; i = i + 1) begin
    data_in = 0;
    slave_data_in = CIPHERED_WORD[i];

    #(2 * PERIOD) start = 1;
    #(2 * PERIOD) start = 0;

    // Wait for slave to finish
    #(4 * 8 * PERIOD);

    SLAVE_RECEIVE_WORD[i] = data_out;
  end

  // Display ciphered word
  #10;

  $display("Ciphered Word RECEIVED AT DECRYPT:");
  for (i = 0; i < 16; i = i + 1) begin
    $write("%h", MASTER_RECEIVE_WORD[i]);
  end

  $display("");

  #(PERIOD * 5);

  // put deciphered word in vector
  DECIPHERED_WORD[0] = deciphered_word[127:120];
  DECIPHERED_WORD[1] = deciphered_word[119:112];
  DECIPHERED_WORD[2] = deciphered_word[111:104];
  DECIPHERED_WORD[3] = deciphered_word[103:96];
  DECIPHERED_WORD[4] = deciphered_word[95:88];
  DECIPHERED_WORD[5] = deciphered_word[87:80];
  DECIPHERED_WORD[6] = deciphered_word[79:72];
  DECIPHERED_WORD[7] = deciphered_word[71:64];
  DECIPHERED_WORD[8] = deciphered_word[63:56];
  DECIPHERED_WORD[9] = deciphered_word[55:48];
  DECIPHERED_WORD[10] = deciphered_word[47:40];
  DECIPHERED_WORD[11] = deciphered_word[39:32];
  DECIPHERED_WORD[12] = deciphered_word[31:24];
  DECIPHERED_WORD[13] = deciphered_word[23:16];
  DECIPHERED_WORD[14] = deciphered_word[15:8];
  DECIPHERED_WORD[15] = deciphered_word[7:0];

  $display("DECIPERED Word: %h", deciphered_word);

  $display("===========================================");
  $display("      DECRYPT: from slave2 to master");
  $display("===========================================");

  // send deciphered word to master
  for (i = 0; i < SPI_KEY_SIZE / 8 ; i = i + 1) begin
    data_in = 0;
    slave_data_in = DECIPHERED_WORD[i];

    #(2 * PERIOD) start = 1;
    #(2 * PERIOD) start = 0;

    // Wait for slave to finish
    #(4 * 8 * PERIOD);

    RECEIVED_DECIPHERED_WORD[i] = data_out;
  end

  deciphered_word_recived = {RECEIVED_DECIPHERED_WORD[0], RECEIVED_DECIPHERED_WORD[1], RECEIVED_DECIPHERED_WORD[2], RECEIVED_DECIPHERED_WORD[3], RECEIVED_DECIPHERED_WORD[4], RECEIVED_DECIPHERED_WORD[5], RECEIVED_DECIPHERED_WORD[6], RECEIVED_DECIPHERED_WORD[7], RECEIVED_DECIPHERED_WORD[8], RECEIVED_DECIPHERED_WORD[9], RECEIVED_DECIPHERED_WORD[10], RECEIVED_DECIPHERED_WORD[11], RECEIVED_DECIPHERED_WORD[12], RECEIVED_DECIPHERED_WORD[13], RECEIVED_DECIPHERED_WORD[14], RECEIVED_DECIPHERED_WORD[15]};

  $display("DECIPHERED DATA RECEIVED AT MASTER: %h", deciphered_word_recived);


  #(PERIOD * 5);
  

  $finish;
end

////////////////////////////// MONITOR //////////////////////////////
// always @(mosi) begin
//   $monitor("mosi= %b", mosi);
// end

endmodule
