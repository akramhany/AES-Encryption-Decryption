/*
    *
    * Module: slave
    * Description: this module is the slave module in the spi protocol
    * ==============================================
    * Inputs:
      * reset: reset signal
      * sclk: serial clock
      * mosi: master out slave in
      * CS: chip select
      * miso_data: slave data in ( the data that the slave sends to the master)
    * Outputs:
      * mosi_data: slave data out ( the data that the master sends to the slave)
      * MISO: master in slave out

    * Author: Amir Kedis 
    * Date: 10 - May - 2023 
*/

module slave (
  // Control signals
  input reset,      // reset the state of the slave
  input sclk,       // serial clock

  // MOSI signals
  output [7:0] mosi_data, // the 1-byte data received from the master
  // TODO: might need to add a signal here to indecte output is ready

  // MISO signals 
  input  [7:0] miso_data, // the 1-byte data sent to the master
  // TODO: might need to add a signal here to indecte ready to get input 

  // SPI signals
  output MISO,      // master input slave output (1-bit)
  input MOSI,       // master output slave input (1-bit)
  input CS          // chip select active low
  );

//////////////////////////////  Registers  //////////////////////////////
// Will register the data because the data is not stable
reg [7:0] mosi_data_reg; // the 1-byte data received from the master
reg [7:0] miso_data_reg; // the 1-byte data sent to the master
reg [2:0] counter;       // counter to count the number of bits sent/received


//////////////////////////////  next states  //////////////////////////////
reg [7:0] mosi_data_next; // controling the next state logic of the mosi_data_reg
reg [7:0] miso_data_next; // controling the next state logic of the miso_data_reg


////////////////////////////// Serial Clock //////////////////////////////
assign sclk_en = (CS == 1'b0) ? sclk : 1'b0; // if CS is high, then sclk is low

//////////////////////////////  Set up  //////////////////////////////
always @(negedge CS) begin 
  // reset the registers to 0 and restarts the counter
  mosi_data_reg <= 8'b0;
  miso_data_reg <= miso_data;
  counter <= 4'b0;
  //MISO <= miso_data[0];
end

////////////////////////////// Memory //////////////////////////////
always @(posedge sclk_en) begin
  if (reset) begin
    // reset the registers to 0 and restarts the counter
    mosi_data_reg <= 8'b0;
    miso_data_reg <= 8'b0;
    counter <= 4'b0;
  end
  else begin
    // updates the registers and increments the counter
    mosi_data_reg <= mosi_data_next;
    miso_data_reg <= miso_data_next;
    counter <= counter + 1;
  end
end

//////////////////////////////  Next State Logic  //////////////////////////////
always @(*) begin
  // miso data next - the logic of sending 1 bit
  if (CS == 1'b0) begin 
    miso_data_next <= {miso_data_reg[6:0], 1'b0};
  end else begin
    miso_data_next <= miso_data_reg;
  end

  // mosi data next - the logic of receiving 1 bit
  if (CS == 1'b0) begin 
    mosi_data_next <= {mosi_data_reg[6:0], MOSI};
  end else begin
    mosi_data_next <= mosi_data_reg;
  end
end

//////////////////////////////  Output Logic  //////////////////////////////
assign MISO = (CS == 1'b0) ? miso_data_reg[7] : 1'bz; // if CS is high, then MISO is low

assign mosi_data = mosi_data_reg; // the 1-byte data received from the master

endmodule