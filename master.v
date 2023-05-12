/*
    *
    * Module: master
    * Description: this module is the master module in the spi protocol
    * ==============================================
    * Inputs:

    * Outputs:

    * Author: Amir Kedis 
    * Date: 10 - May - 2023 
*/

module master (
  // Control Signals
  input reset,      // reset the state of the master
  input clk,        // clock (from FPGA)
  input start,      // start the state machine
  output buzy,      // busy signal indicates transmistion not finished (1-bit)
  output done,      // done signal indicates transmistion finished output ready (1-bit)

  // DATA Signals
  input [7:0] data_in,  // the 1-byte data sent to the slave
  output [7:0] data_out,// the 1-byte data received from the slave

  // SPI Signals
  output cs,            // chip select active low
  output mosi,          // master output slave input (1-bit)
  input miso,           // master input slave output (1-bit)
  output sclk           // serial clock 
);

////////////////////////////  Local Parameters  //////////////////////////////
localparam IDLE     = 2'b00; // idle state
localparam TRANSFER = 2'b01; // send state
localparam WAIT     = 2'b10; // wait state - Will be used to skip first halh cycle


////////////////////////////  Registers  //////////////////////////////
reg state_reg;                // the current state of the state machine
reg [7:0] data_in_reg;        // the 1-byte data sent to the slave
reg [7:0] data_out_reg;       // the 1-byte data received from the slave
reg [1:0] sclk_reg;           // serial clock Register (clk divider by 2)
reg mosi_reg;                 // master output slave input Register (1-bit)
reg [2:0] counter_reg;        // counter to count the number of bits sent/received
reg done_reg;                 // done signal reg

////////////////////////////  next states  //////////////////////////////
reg state_next;               // controling the next state logic of the state_reg
reg [7:0] data_in_next;       // controling the next state logic of the data_in_reg
reg [7:0] data_out_next;      // controling the next state logic of the data_out_reg
reg [1:0] sclk_next;          // controling the next state logic of the sclk_reg
reg mosi_next;                // controling the next state logic of the mosi_reg
reg [2:0] counter_next;       // controling the next state logic of the counter_reg
reg done_next;                // controling the next state logic of the done_reg



////////////////////////////  Output Logic  //////////////////////////////
assign mosi = mosi_reg;       // master output slave input (1-bit)
// sends the clock every two cycles only when state is transfer
assign sclk = ~sclk_reg[1] & (state_reg == TRANSFER);     // serial clock (1-bit)
assign buzy = (state_reg != IDLE);  // busy is high if state is transfer or wait
assign data_out = data_out_reg;
assign done = done_reg;    


endmodule