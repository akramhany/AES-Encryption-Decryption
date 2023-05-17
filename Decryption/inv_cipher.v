
module inv_cipher (
    expanded_key,
    i_data,
    NR,
    sync,
    clk,
    o_data
);

  input wire sync;
  input wire [127:0] i_data;
  output wire [127:0] o_data;
  input wire [3:0] NR;
  input wire clk;
  input wire [1919:0] expanded_key;
  
  reg [3:0] counter;
  reg [1919:0] expanded_key_temp;
  reg [127:0] temp_state1;
  wire [127:0] temp_state2;
  wire [127:0] temp_state3;
  wire [127:0] sub_out;
  wire [127:0] shift_out;
  wire [127:0] added_round;
  

  add_round_key add(.i_state(i_data), .i_key(expanded_key[1919 -128*(NR) -:128]), .o_state(temp_state3));

  inv_shift_rows shift(.i_state(temp_state1), .o_state(shift_out));
  inv_sub_bytes sub(.i_initial_state(shift_out), .o_result_state(sub_out));
  add_round_key add2(.i_state(sub_out), .i_key(expanded_key_temp[1919 -128*(NR-1) -:128]), .o_state(added_round));
  inv_mix_columns mix(.i_state(added_round), .o_state(temp_state2));

  always @(posedge clk) begin
    if (sync) begin
      counter = 0;
      expanded_key_temp = expanded_key;
      temp_state1 = temp_state3;
    end 
    else if (counter < NR-1) begin
      temp_state1 <= temp_state2;
      expanded_key_temp <= expanded_key_temp >> 128;
      counter <= counter + 1;
    end

    
  end

wire [127:0]sub_out2;
wire [127:0]shift_out2;
wire [127:0]key_out_f;

inv_shift_rows shift2(.i_state(temp_state1), .o_state(shift_out2));
inv_sub_bytes sub2(.i_initial_state(shift_out2), .o_result_state(sub_out2));
add_round_key add3(.i_state(sub_out2), .i_key(expanded_key_temp[1919 -128*(NR-1) -:128]), .o_state(key_out_f));

assign o_data = key_out_f;
endmodule