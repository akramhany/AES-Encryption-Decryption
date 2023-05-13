/*
    * Module: slave_tb
    * Description: this module is the testbench for the slave module in the spi protocol
    * ==============================================
    * Author: Amir Kedis 
    * Date: 11 - May - 2023 
*/
`timescale 1ns / 1ps

`include "slave.v"

module slave_tb;

//////////////////////////////
//       INPUT SIGNALS      //
//////////////////////////////
reg reset;
reg sclk;
reg MOSI;
reg CS;
reg [7:0] miso_data;

//////////////////////////////
//      OUTPUT SIGNALS      //
//////////////////////////////
wire MISO;
wire [7:0] mosi_data;

//////////////////////////////
//       DUT INSTANCES      //
//////////////////////////////
slave dut (
  .reset(reset),
  .sclk(sclk),
  .MOSI(MISO),
  .CS(CS),
  .miso_data(miso_data),
  .MISO(MISO),
  .mosi_data(mosi_data)
);

//////////////////////////////
//       TESTBENCH CODE     //
//////////////////////////////

always begin
  #5 sclk = ~sclk;
end

initial begin
  reset = 1;
  sclk = 0;
  MOSI = 0;
  CS = 1;
  miso_data = 8'b1010_0101;

  #10 reset = 0;
  #10 CS = 0;

  #80;
  $display("DATA_SENT: %b => DATA_RECIEVED: %b", mosi_data, miso_data);
  CS = 1;

  #10
  CS = 0;
  miso_data = 8'b1110_1111;
  #80
  $display("DATA_SENT: %b => DATA_RECIEVED: %b", mosi_data, miso_data);
  CS = 1;

  #10
  CS = 0;
  miso_data = 8'b0010_1000;
  #80
  $display("DATA_SENT: %b => DATA_RECIEVED: %b", mosi_data, miso_data);
  CS = 1;

  #15

  $finish;
end



endmodule