/*
    *
    * Module: master_tb
    * Description: this module is the testbench for the master module in the spi protocol
    * ==============================================
    * Author: Amir Kedis 
    * Date: 12 - May - 2023 
*/

`include "master.v"

module master_tb;

localparam PERIOD = 10;

////////////////////////////// CLOCK //////////////////////////////
reg clk = 0;
always #(PERIOD / 2) clk = ~clk;

////////////////////////////// SIGNALS //////////////////////////////
reg reset;
reg start;
wire buzy;
wire done;
reg [7:0] data_in;
wire [7:0] data_out;
wire cs;
wire mosi;
reg miso;
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
  .miso(mosi),
  .sclk(sclk)
);

////////////////////////////// TESTBENCH CODE //////////////////////////////
initial begin
  reset = 1;
  start = 0;
  data_in = 8'h00;

  // Wait
  #(5 * PERIOD) reset = 0;

  // Send data
  data_in = 8'b10101010;
  start = 1;
  miso = 0;
  #(2* PERIOD) start = 0;

  // Wait
  #(40 * PERIOD);

  $finish;
end

////////////////////////////// MONITOR //////////////////////////////
always @(mosi) begin
  $monitor("mosi= %b", mosi);
end

endmodule
