/*
    *
    * Module: master
    * Description: this module is the master module in the spi protocol
    * ==============================================
    * Inputs:
      * reset: reset signal
      * sclk: serial clock
      * MISO: master in slave out
      * CS: chip select
      * MDS: master data in (the data that the master will sends to the slave)
    * Outputs:
      * MDO: master data out (the data that the slave sends to the master)
      * MOSI: master out slave in
    * Author: Amir Kedis 
    * Date: 10 - May - 2023 
*/

module master (
  input reset,
  input sclk,
  input MISO,
  input CS,
  input  [7:0] MDS,
  output [7:0] MDO,
  output MOSI
);

// counter logic for the spi protocol
reg [3:0] counter = 0; // counts from 0 to 15

always @(posedge sclk) begin
  counter <= counter + 1;
end

  
endmodule