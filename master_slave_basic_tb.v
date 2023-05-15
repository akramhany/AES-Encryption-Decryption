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
initial begin
  reset = 1;
  start = 0;
  data_in = 8'h00;
  slave_data_in = 8'h00;

  // Wait
  #(5 * PERIOD) reset = 0;

  // Send data
  start = 1;
  data_in       = 8'b1111_1111;
  slave_data_in = 8'b1010_1101;
  #(2* PERIOD) start = 0;

  // Wait for done
  /////////////////////////////////////
  // REAL_IMPORTANT_NOTE:
  // 1. @(slave_done) is a blocking statement
  // slave done comes before master done
  // when waiting for master done slave recived data will be shifted by one
  // we should act on slave done not master done
  // or we should change how master done reacts
  ////////////////////////////////////
  @(slave_done);

  // Wait
  #(5 * PERIOD);

  // Check data
  $display("data sent from master to slave: %b", data_in);
  $display("data Received at slave:         %b", slave_data_out);
  if (data_in == slave_data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  $display("data sent from slave to master: %b", slave_data_in);
  $display("data Received at master:        %b", data_out);
  if (slave_data_in == data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  // Wait
  data_in       = 8'hab;
  slave_data_in = 8'hcd;
  #(2 * PERIOD) start = 1;
  #(2 * PERIOD) start = 0;

  // Wait for done
  @(slave_done);

  // Check data
  $display("data sent from master to slave: %b", data_in);
  $display("data Received at slave:         %b", slave_data_out);
  if (data_in == slave_data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  $display("data sent from slave to master: %b", slave_data_in);
  $display("data Received at master:        %b", data_out);
  if (slave_data_in == data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  // Wait
  data_in       = 8'h00;
  slave_data_in = 8'hcd;
  #(2 * PERIOD) start = 1;
  #(2 * PERIOD) start = 0;

  // Wait for done
  @(slave_done);

  // Wait
  #(5 * PERIOD);

  // Check data
  $display("data sent from master to slave: %b", data_in);
  $display("data Received at slave:         %b", slave_data_out);
  if (data_in == slave_data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  $display("data sent from slave to master: %b", slave_data_in);
  $display("data Received at master:        %b", data_out);
  if (slave_data_in == data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  // Wait
  data_in       = 8'h11;
  slave_data_in = 8'h11;
  #(2 * PERIOD) start = 1;
  #(2 * PERIOD) start = 0;

  @(slave_done);

  // Check data
  $display("data sent from master to slave: %b", data_in);
  $display("data Received at slave:         %b", slave_data_out);
  if (data_in == slave_data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  $display("data sent from slave to master: %b", slave_data_in);
  $display("data Received at master:        %b", data_out);
  if (slave_data_in == data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  // Wait
  data_in       = 8'h7e;
  slave_data_in = 8'h00;
  #(2 * PERIOD) start = 1;
  #(2 * PERIOD) start = 0;

  @(slave_done);

  // Check data
  $display("data sent from master to slave: %b", data_in);
  $display("data Received at slave:         %b", slave_data_out);
  if (data_in == slave_data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  $display("data sent from slave to master: %b", slave_data_in);
  $display("data Received at master:        %b", data_out);
  if (slave_data_in == data_out) begin
    $display("Test passed");
  end else begin
    $display("Test failed");
  end

  #(10 * PERIOD);

  $finish;
end

////////////////////////////// MONITOR //////////////////////////////
// always @(mosi) begin
//   $monitor("mosi= %b", mosi);
// end

endmodule
