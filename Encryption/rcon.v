/*
    fucntion discryption:
    rcon is a function that returns the round constant
    to be used in key expantion, by giving it the number
    of the round.
*/

function automatic [31:0] rcon (
    input [3:0]  i_round_number
);
begin
    rcon = 32'd0;
    rcon [31:24] = (i_round_number == 4'd1 ) ? 8'h01:
                   (i_round_number == 4'd2 ) ? 8'h02:
                   (i_round_number == 4'd3 ) ? 8'h04:
                   (i_round_number == 4'd4 ) ? 8'h08:
                   (i_round_number == 4'd5 ) ? 8'h10:
                   (i_round_number == 4'd6 ) ? 8'h20:
                   (i_round_number == 4'd7 ) ? 8'h40:
                   (i_round_number == 4'd8 ) ? 8'h80:
                   (i_round_number == 4'd9 ) ? 8'h1b:
                   (i_round_number == 4'd10) ? 8'h36:
                   8'bxxxxxxxx;
end
endfunction
