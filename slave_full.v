/*
    *
    * Module: slave
    * Description: this module is the slave module in the spi protocol
    * ==============================================
    * Inputs:

    * Outputs:


    * Author: Amir Kedis 
    * Date: 10 - May - 2023 
*/

module slave_full (
  // Control signals
  input reset,      // reset the state of the slave
  input clk,        // real clock 
  output done,      // done signal to indicate the slave is done

  // Data signals
  output [391:0] data_out, // the 1-byte data received from the master
  input  [391:0] data_in, // the 1-byte data sent to the master
  // TODO: might need to add a signal here to indecte ready to get input 

  // SPI signals
  input sclk,       // serial clock (1-bit)
  output miso,      // master input slave output (1-bit)
  input mosi,       // master output slave input (1-bit)
  input cs          // chip select active low
  );

//////////////////////////////  Registers  //////////////////////////////
// Will register the data because the data is not stable
reg mosi_reg;                 // master output slave input Register (1-bit)
reg miso_reg;                 // master input slave output Register (1-bit)
reg [391:0] data_in_reg;        // the 1-byte data sent to the slave
reg [391:0] data_out_reg;       // the 1-byte data received from the slave
reg sclk_reg;                 // serial clock Register
reg sclk_shift_reg;           // serial clock shift - For detacting the rising edge
reg [9:0] counter_reg;        // counter to count the number of bits sent/received
reg done_reg;                 // done signal reg
reg cs_reg;                   // chip select active low reg


//////////////////////////////  next states  //////////////////////////////
reg mosi_next;                // controling the next state logic of the mosi_reg
reg miso_next;                // controling the next state logic of the miso_reg
reg [391:0] data_in_next;       // controling the next state logic of the data_in_reg
reg [391:0] data_out_next;      // controling the next state logic of the data_out_reg
reg sclk_next;                // controling the next state logic of the sclk_reg
reg sclk_shift_next;          // controling the next state logic of the sclk_shift_reg
reg [9:0] counter_next;       // controling the next state logic of the counter_reg
reg done_next;                // controling the next state logic of the done_reg
reg cs_next;                  // controling the next state logic of the cs_reg


////////////////////////////// Memory //////////////////////////////
always @(posedge clk) begin
  if (reset) begin
    done_reg      <= 0;
    miso_reg      <= 0;
    data_out_reg  <= 0;
    counter_reg   <= 0;
  end
  else begin
    done_reg      <= done_next;
    miso_reg      <= miso_next;
    data_out_reg  <= data_out_next;
    counter_reg   <= counter_next;
  end 

  // Not affected by reset
  mosi_reg      <= mosi_next;
  data_in_reg   <= data_in_next;
  sclk_reg      <= sclk_next;
  sclk_shift_reg<= sclk_shift_next;
  cs_reg        <= cs_next;
end

//////////////////////////////  Next State Logic  //////////////////////////////
always @(*) begin
  // Default values
  sclk_next       = sclk;     // slck will be a mirror of the master's sclk
  sclk_shift_next = sclk_reg; // will be late by a half cycle from the sclk used for detecting the rising edge
  mosi_next       = mosi;
  miso_next       = miso_reg;
  data_in_next    = data_in_reg;
  data_out_next   = data_out_reg;
  counter_next    = counter_reg;
  done_next       = 0;
  cs_next         = cs;

  // cs is active low
  if (cs_reg) begin 
    counter_next = 0;
    data_in_next  = data_in;         // Register the data when cs is high (data_in is not stable)
    miso_next    = data_in_reg[391];  // prepare MSB - the data is sent MSB first 
  end
  else begin 
    // Risiing Edge - trick from google
    if (!sclk_shift_reg && sclk_reg) begin
      data_in_next = {data_in_reg[390:0], 1'bz}; // shift the data_in_reg to the left and add the new mosi bit
      counter_next = counter_reg + 1;              // increment the counter

      // last bit
      if (counter_reg == 391) begin
        data_out_next = {data_out_reg[390:0], mosi}; // FIXME: will need to change
        done_next     = 1;                            // set the done signal
        data_in_next  = data_in;                      // read the next byte to continue transction
      end

    end
    // Falling Edge
    else if (sclk_shift_reg && !sclk_reg) begin
      miso_next = data_in_reg[391];                      // OUTPUT the MSB
      data_out_next = {data_out_reg[390:0], mosi_reg};
    end
  end
end

//////////////////////////////  Output Assignment  //////////////////////////////
assign done = done_reg;
assign data_out = (done_reg == 1'b1) ? data_out_reg : data_out;
assign miso = (cs == 0) ? miso_reg : 1'bz;

endmodule