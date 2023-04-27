/*
   *
   * Module: tb_inv_mix_columns
   * Description: This module tests the inverse mix columns operation on the input state of AES encryption.
   * Inputs: N/A
   * Outputs: N/A
   * Author: Adham Hussin
   * Date: 27/4/2003 
*/
`include "inv_mix_columns.v"
module tb_inv_mix_columns;


reg [127:0]i_state;
wire [127:0]o_state;


inv_mix_columns inv_mixer(.i_state(i_state), .o_state(o_state));


initial begin
 
    i_state = 128'h046681e5e0cb199a48f8d37a2806264c;
    #10 i_state = 128'h584dcaf11b4b5aacdbe7caa81b6bb0e5;
  
    #10 $finish;
end




always @(o_state) begin
  
  $display("Time = %t, i_state = %h, o_state = %h", $time, i_state, o_state);
end

endmodule