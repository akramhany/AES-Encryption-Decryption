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
`include "Encryption/cipher.v"
`include "Decryption/inv_cipher.v"
`include "slave_full.v"

module AES (
    input sync,
    input cs,          
    input clk,
    input sclk,             
    input mosi,       
    output miso,
    output done
);



reg [391:0] in_data;

wire [127:0] cipher_out_data_k1;
wire [127:0] cipher_out_data_k2;
wire [127:0] cipher_out_data_k3;

wire [127:0] inv_cipher_out_data_k1;
wire [127:0] inv_cipher_out_data_k2;
wire [127:0] inv_cipher_out_data_k3;

wire [1407:0]o_expanded_key_1;
wire [1663:0]o_expanded_key_2;
wire [1919:0]o_expanded_key_3;
reg [1919:0]selected_key;



wire temp_done;
wire [391:0] data_out;
wire [391:0] data_in_w;
reg [255:0] data_in;
reg [2:0] state_reg;
reg [2:0] state_next;

wire [7:0]param;

localparam IDLE             = 3'b000; 
localparam FILL_DATA_ENC    = 3'b001;
localparam FILL_DATA_DEC    = 3'b010; 
localparam SEND_DATA_ENC    = 3'b011;
localparam SEND_DATA_DEC    = 3'b100;
localparam WAIT1            = 3'b101;
localparam WAIT2            = 3'b110; 




slave_full enc_slave (
   .reset(sync),
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
    if(sync) begin
        in_data = 0;
        state_reg <= 2'b0;

    end
    else begin
        state_reg <= state_next;
    end
end

always @(*) begin
    state_next = state_reg;
    case(state_reg)
        IDLE: begin
            if(!cs) begin
                state_next <= FILL_DATA_ENC;
            end
        end
        FILL_DATA_ENC: begin
            if(temp_done) begin
                in_data = data_out;
                state_next = SEND_DATA_ENC;
            end
        end
        SEND_DATA_ENC: begin
            if(temp_done) begin
                case(param)
                    8'd16: begin
                        data_in[255:128] = cipher_out_data_k1;
                        data_in[127:0] = inv_cipher_out_data_k1;
                    end
                    8'd24: begin
                        data_in[255:128] = cipher_out_data_k2;
                        data_in[127:0] = inv_cipher_out_data_k2;
                    end
                    8'd32: begin
                        data_in[255:128] = cipher_out_data_k3;
                        data_in[127:0] = inv_cipher_out_data_k3;
                    end
                endcase
                state_next = IDLE;
            end
        end
    endcase
end

cipher  k1 (
    .i_data(in_data[391-:128]),
    .expanded_key(selected_key),
    .NR(param/4 + 6),
    .o_data(cipher_out_data_k1)
     );
cipher #(6,12) k2 (
    .i_data(in_data[391-:128]),
    .i_key(in_data[255-:192]),
    .o_data(cipher_out_data_k2)
     );

inv_cipher #(4,10) ik1 (
    .i_data(cipher_out_data_k1),
    .i_key(in_data[255-:128]),
    .o_data(inv_cipher_out_data_k1)
     );
inv_cipher #(6,12) ik2 (
    .i_data(cipher_out_data_k2),
    .i_key(in_data[255-:192]),
    .o_data(inv_cipher_out_data_k2)
     );
     key_expansion #(.NK(4), .NR(10)) ke128 (
    .i_cypher_key(in_data[255 -:128]),
    .o_expanded_key(o_expanded_key_1)
);
     key_expansion #(.NK(6), .NR(12)) ke128 (
    .i_cypher_key(in_data[255 -:128]),
    .o_expanded_key(o_expanded_key_2)
);
     key_expansion #(.NK(8), .NR(14)) ke128 (
    .i_cypher_key(in_data[255 -:128]),
    .o_expanded_key(o_expanded_key_3)
);
assign done = temp_done;
assign data_in_w[383 -: 256] = data_in;
assign param = in_data[263-:8];
endmodule
