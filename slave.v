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
      * SDS: slave data in ( the data that the slave sends to the master)
    * Outputs:
      * SDO: slave data out ( the data that the master sends to the slave)
      * MISO: master in slave out

    * Author: Amir Kedis 
    * Date: 10 - May - 2023 
*/

module slave (
  input reset,
  input sclk,
  input mosi,
  input CS,
  input  [7:0] SDS,
  output [7:0] SDO,
  output MISO
  );
  
endmodule