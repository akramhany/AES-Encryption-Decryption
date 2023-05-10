/*
    *
    * Module: master slave testbench
    * Description: 
    * ==============================================
    * Author: Amir Kedis 
    * Date: 10 - May - 2023 
*/
`timescale 1ns / 1ps

`include "master.v"


module master_slave_tb;

  ////////////////////////////
  //       parameters       //
  ////////////////////////////
  parameter CLK_PERIOD = 10;

  //////////////////////////////
  //          Inputs          //
  //////////////////////////////
  reg reset;
  reg sclk;
  reg MISO;
  reg CS;
  reg [7:0] MDS;

  //////////////////////////////
  //          Outputs         //
  //////////////////////////////
  wire [7:0] MDO;
  wire MOSI;

  //////////////////////////////
  //          Clock           //
  //////////////////////////////
  always begin
    #(CLK_PERIOD / 2) sclk = ~sclk;
  end

  //////////////////////////////////////////
  //  Instantiate Unit Under Test (UUT)   //
  //////////////////////////////////////////
  master uut (
    .reset(reset), 
    .sclk(sclk), 
    .MISO(MISO), 
    .CS(CS), 
    .MDS(MDS), 
    .MDO(MDO), 
    .MOSI(MOSI)
  );

  ////////////////////////////
  // Initialize Inputs
  ////////////////////////////
  initial begin
    // Initialize Inputs
    reset = 0;
    sclk = 0;
    MISO = 0;
    CS = 0;
    MDS = 0;

    // Wait 10 cycles for global reset to finish
    #(CLK_PERIOD * 10);
    reset = 1;

    ////////////////////////////
    //    Stimulus Inputs     //
    ////////////////////////////

    $finish;
  end


  ////////////////////////////
  //    Monitor Outputs     //
  ////////////////////////////
  always @(posedge sclk) begin
    // $display("MDO: %d", MDO);
  end

endmodule
