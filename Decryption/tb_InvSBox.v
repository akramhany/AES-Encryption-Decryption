`include "InvSBox.v"

module tb_InvSBox ();
    reg [7:0] in_toSub_tb;
    wire [7:0] out_Subed_tb;

    InvSBox ob(.in_toSub(in_toSub_tb), .out_Subed(out_Subed_tb));

    localparam period = 5;

    initial begin
        $dumpfile("tb_InvSBox.vcd");
        $dumpvars(0, tb_InvSBox);

        for (in_toSub_tb = 8'd0; in_toSub_tb <= 8'hff ; in_toSub_tb = in_toSub_tb + 1 ) begin
            #period;
        end
    end

    initial begin
        # (257*period) $finish;
    end

endmodule