`include "add_round_key.v"
module add_round_key_tb();

reg [127:0] i_state, i_key;
wire [127:0] o_state;

add_round_key ark (
    .i_key(i_key),
    .i_state(i_state),
    .o_state(o_state)
);

initial begin
    i_key = 128'h00000000000000000000000000000000;
    i_state = 128'h00000000000000000000000000000000;

    #50;
    
    i_state = 128'h3243f6a8885a308d313198a2e0370734;
    i_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;

    #10
    $display("Input           = 3243f6a8885a308d313198a2e0370734");
    $display("Key             = 2b7e151628aed2a6abf7158809cf4f3c");
    $display("Output          = %h", o_state);
    $display("Expected output = 193de3bea0f4e22b9ac68d2ae9f84808");

    if (o_state == 128'h193de3bea0f4e22b9ac68d2ae9f84808) begin
        $display("Success !!");
    end
    else begin
        $display("Failed !!");
    end

    #10 $finish;
end

endmodule