/*
   *
   * Module: encrypt
   * Description: This module acts as a driver for encryption operation by recieving and sending data from the SPI slave.
   * Inputs:
   *     
   * Outputs:
   *     n
   * Author: Adham Hussin
   * Date: 14/5/2023 
*/
`include "cipher.v"
`include "../slave.v"
module encrypt (
    input reset,
    input cs,          
    input clk,
    input sclk,             
    input mosi,       
    output miso,
    output done, 
    output reg enc_sending
    

);



reg [391:0] in_data;

wire [127:0] cipher_out_data_k1;
wire [127:0] cipher_out_data_k2;
wire [127:0] cipher_out_data_k3;

reg [127:0] cipher_out_data_k1_reg;
reg [127:0] cipher_out_data_k2_reg;
reg [127:0] cipher_out_data_k3_reg;


wire temp_done;
wire [7:0] data_out;
wire [7:0] data_in_w;
reg [7:0] data_in;
reg [2:0] state_reg;
reg [2:0] state_next;

wire [7:0]param;

localparam IDLE             = 2'b00; 
localparam FILL_DATA        = 2'b01; 
localparam SEND_DATA        = 2'b10;

reg [7:0]c1; //counts FILL_DATA
reg [4:0]c3; //counts FILL_DATA




slave enc_slave (
  .reset(reset),
  .clk(clk),
  .cs(cs),
  .mosi(mosi),
  .miso(miso),
  .sclk(sclk),
  .data_in(data_in_w),
  .data_out(data_out),
  .done(temp_done)
);

always@(posedge clk) begin
    if(reset) begin
        in_data = 0;
        c1 = 0;
        c3 = 0;
        enc_sending = 0;
        //should we add a counter to give the cipher a chance to compute ??

        state_reg <= 3'b0;

    end
    else begin
        state_reg <= state_next;
    end
end

always @(posedge clk) begin
    state_next = state_reg;
    
    case(state_reg)
        IDLE: begin
            c1 = 0;
            c3 = 0;
            if(!cs) begin
                state_next <= FILL_DATA;
            end
        end
        FILL_DATA: begin
            if(c1 < 49)begin
                if(temp_done) begin
                    in_data[7:0] = data_out;
                    if (c1 < 48) begin
                        in_data = in_data << 8;
                    end
                    c1 = c1 + 1'b1;
                end
                state_next = FILL_DATA;
            end
            else begin
                state_next = SEND_DATA;
            end
        end
        SEND_DATA: begin
            enc_sending = 1;
            cipher_out_data_k1_reg = cipher_out_data_k1;
            cipher_out_data_k2_reg = cipher_out_data_k2;
            cipher_out_data_k3_reg = cipher_out_data_k3;
            if(c3 < 16) begin
				if(temp_done) begin
                    case(param)
                        8'd16: begin
                            data_in = cipher_out_data_k1_reg[127:120];
                            cipher_out_data_k1_reg = cipher_out_data_k1_reg << 8;
                            c3 = c3 +1;
                        end
                        8'd24: begin
                            data_in = cipher_out_data_k2_reg[127:120];
                            cipher_out_data_k2_reg = cipher_out_data_k2_reg << 8;
                            c3 = c3 +1;
                        end
                        8'd32: begin
                            data_in = cipher_out_data_k3_reg[128 - c3 * 8 - 1 -:8];
                            c3 = c3 +1;
                        end
                    endcase
                end
                state_next = SEND_DATA;
            end
            else if(c3 == 16) begin
                state_next = IDLE;
            end


        end
    endcase
end

cipher #(4,10) k1 (
    .i_data(in_data[391-:128]),
    .i_key(in_data[255-:128]),
    .o_data(cipher_out_data_k1)
     );
cipher #(6,12) k2 (
    .i_data(in_data[391-:128]),
    .i_key(in_data[255-:192]),
    .o_data(cipher_out_data_k2)
     );
cipher #(8,14) k3 (
    .i_data(in_data[391-:128]),
    .i_key(in_data[255-:256]),
    .o_data(cipher_out_data_k3)
     );

assign done = temp_done;
assign data_in_w = data_in;
assign param = in_data[263-:8];
endmodule
