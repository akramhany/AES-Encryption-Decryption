`include "sbox.v"

module sub_bytes (
    input wire clk,
    input wire [127:0] i_initial_state,
    output reg [127:0] o_result_state
);

/*
    this module takes every byte in the i_initial_state
    and substitue it using the sbox
*/

reg [127:0] aux;
wire [7:0] aux_2;

reg [4:0] i = 5'd0;
reg [7:0] sub_clk;

SBox the_subbing (.in_toSub(aux [(i + 1)*8 -1 -:8]    ) , .out_Subed(aux_2) );

always @(posedge clk) begin
    sub_clk = sub_clk + 1;
    o_result_state[(i + 1)*8 -1 -:8] = aux_2;
    aux = i_initial_state;
end

always @(posedge sub_clk[7] ) begin
    if(i < 5'd16) begin
        i = i + 1'b1;
    end
end

endmodule