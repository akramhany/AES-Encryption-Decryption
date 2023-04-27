/*
   *
   * Module: tb_mix_columns
   * Description: This module tests the mix columns operation on the input state of AES encryption.
   * Inputs: N/A
   * Outputs: N/A
   * Author: Adham Hussin
   * Date: 27/4/2003 
*/
`include "mix_columns.v"
module tb_mix_columns;


reg [127:0]i_state;
wire [127:0]o_state;


mix_columns mixer(.i_state(i_state), .o_state(o_state));


initial begin
 
    i_state = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
    #10 i_state = 128'h49db873b453953897f02d2f177de961a;
  
    #10 $finish;
end




always @(o_state) begin
  
  $display("Time = %t, i_state = %h, o_state = %h", $time, i_state, o_state);
end

endmodule