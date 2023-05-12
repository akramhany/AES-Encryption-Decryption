/*
    *
    * Module: master_salve_basic_tb
    * Description: this module is the testbench for the master module in the spi protocol
    * ==============================================
    * Author: Amir Kedis 
    * Date: 12 - May - 2023 
*/

`timescale 1ns / 1ps

`include "master.v"
`include "slave.v"

module master_slave_basic_tb;

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



reg [7:0] miso_data;
wire [7:0] mosi_data;

//////////////////////////////
//       DUT INSTANCES      //
//////////////////////////////
slave dut2 (
  .reset(reset),
  .sclk(sclk),
  .MOSI(mosi),
  .CS(cs),
  .miso_data(miso_data),
  .MISO(miso),
  .mosi_data(mosi_data)
);

////////////////////////////// TESTBENCH CODE //////////////////////////////
initial begin
  reset = 1;
  start = 0;
  data_in = 8'h00;
  miso_data = 8'h00;

  // Wait
  #(5 * PERIOD) reset = 0;

  // Send data
  start = 1;
  data_in = 8'b10101010;
  miso_data = 8'b10101010;
  #(2* PERIOD) start = 0;

  // Wait for done
  @(done);

  #(10 * PERIOD);

  $finish;
end

////////////////////////////// MONITOR //////////////////////////////
// always @(mosi) begin
//   $monitor("mosi= %b", mosi);
// end

endmodule
