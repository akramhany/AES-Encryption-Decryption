/*
    *
    * Module: master_salve_send_key_tb
    * Description: this module is the testbench for the master and slave modules in the spi protocol 
    * ==============================================
    * Author: Amir Kedis 
    * Date: 15 - May - 2023 
*/

`timescale 1ns / 1ps

`include "master.v"
`include "slave.v"

module master_slave_key_tb;

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
//       DUT INSTANCES      //
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

localparam SPI_KEY_SIZE = 128;

reg [7:0] SLAVE_RECEIVE_KEY [15:0];

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
    data_in = SPI_KEY[i];
    slave_data_in = 0;
    #(2 * PERIOD)start = 1;
    #(2 * PERIOD) start = 0;

    // Wait for slave to finish
    #(4 * 8 * PERIOD);

    SLAVE_RECEIVE_KEY [i] = slave_data_out;
  end
  
  // Display key
  #10;

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

  $finish;
end

////////////////////////////// MONITOR //////////////////////////////
// always @(mosi) begin
//   $monitor("mosi= %b", mosi);
// end

endmodule
