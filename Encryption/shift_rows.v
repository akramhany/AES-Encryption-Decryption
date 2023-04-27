/*
  *
  * Module: shift_rows
  * Description: Shifts the rows of the state matrix to the left
  * 
  * Inputs:
  *  i_state[127:0] - The state matrix
  * Outputs:
  *  o_state[127:0] - The state matrix with the rows shifted
  *
  * Author: Amir Anwar
  * Date: 2023-4-27
  *
*/
module shift_rows (
    input [127:0] i_state,
    output [127:0] o_state
);

    // Row 1 - No shift 
    assign o_state[127:120] = i_state[127:120]; // row 1, col 1
    assign o_state[95:88]   = i_state[95:88];   // row 1, col 2
    assign o_state[63:56]   = i_state[63:56];   // row 1, col 3
    assign o_state[31:24]   = i_state[31:24];   // row 1, col 4

    // Row 2 - Shift left by 1
    assign o_state[119:112] = i_state[87:80];   // row 2, col 2 => row 2, col 1
    assign o_state[87:80]   = i_state[55:48];   // row 2, col 3 => row 2, col 2
    assign o_state[55:48]   = i_state[23:16];   // row 2, col 4 => row 2, col 3
    assign o_state[23:16]   = i_state[119:112]; // row 2, col 1 => row 2, col 4


    // Row 3 - Shift left by 2
    assign o_state[111:104] = i_state[47:40];   // row 3, col 3 => row 3, col 1
    assign o_state[79:72]   = i_state[15:8];    // row 3, col 4 => row 3, col 2
    assign o_state[47:40]   = i_state[111:104]; // row 3, col 1 => row 3, col 3
    assign o_state[15:8]    = i_state[79:72];   // row 3, col 2 => row 3, col 4

    // Row 4 - Shift left by 3
    assign o_state[103:96]  = i_state[7:0];     // row 4, col 4 => row 4, col 1
    assign o_state[71:64]   = i_state[103:96];  // row 4, col 1 => row 4, col 2
    assign o_state[39:32]   = i_state[71:64];   // row 4, col 2 => row 4, col 3
    assign o_state[7:0]     = i_state[39:32];   // row 4, col 3 => row 4, col 4

endmodule
