`include "slave.v"
`include "Decryption/inv_cipher.v"

module decryption (
  //basically the ports would be the signals that the slave needs to operate
  input wire reset,
  input wire clk,
  input wire cs,
  input wire mosi,
  output wire miso,
  input wire sclk,
  output wire slave_done
);

  wire [7:0] slave_data_in;
  wire [7:0] slave_data_out; 
//////////////////////////////
//       DUT INSTANCES      //
//////////////////////////////
slave spi_slave (
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

//the regs I am going to need to store the sent and received data
reg [127:0] plane_text;
reg [255:0] recived_key;
reg [127:0] inv_cipherd_text;

endmodule

