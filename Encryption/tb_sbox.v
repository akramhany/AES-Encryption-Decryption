`include "sbox.v"

module tb_sbox ();
    reg [7:0] in_toSub_tb;
    wire [7:0] out_Subed_tb;

    sbox ob1(.in_toSub(in_toSub_tb), .out_Subed(out_Subed_tb));

    localparam period = 10;

    initial begin
        $dumpfile("tb_sbox.vcd");
        $dumpvars(0, tb_sbox);

        in_toSub_tb = 8'h8b; #period;
        in_toSub_tb = 8'ha5; #period;
        in_toSub_tb = 8'hcb; #period;
        in_toSub_tb = 8'h42; #period;
        in_toSub_tb = 8'h9f; #period;
        in_toSub_tb = 8'h10; #period;
        in_toSub_tb = 8'h16; #period;
        in_toSub_tb = 8'hce; #period;
        in_toSub_tb = 8'hf3; #period;
    end
endmodule