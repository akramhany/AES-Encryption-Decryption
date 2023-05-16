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


module AES (
    input reset,
    input cs,          
    input clk,
    input sclk,             
    input mosi,       
    output miso,
    output done
);



reg [391:0] in_data;
reg [391:0] in_data_next;

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
reg [127:0] data_in;
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
        state_reg <= 2'b0;
        selected_key = 0;

    end
    else begin
        state_reg <= state_next;
        in_data = in_data_next;
        case(param)
            8'd16: begin
                selected_key = {o_expanded_key_1, 512'b0};
            end
            8'd24: begin
                selected_key = {o_expanded_key_2, 256'b0};
            end
            8'd32: begin
                selected_key = o_expanded_key_3;
            end
        endcase
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
                in_data_next = data_out;
                state_next = SEND_DATA_ENC;
            end
        end
        SEND_DATA_ENC: begin
            if(temp_done) begin
                data_in = cipher_out_data_k1;
                state_next = WAIT1;
            end
        end

        WAIT1: begin
            if(temp_done) begin
                state_next = WAIT2;
            end
        end

        WAIT2: begin
            if(temp_done) begin
                state_next = FILL_DATA_DEC;
            end
        end

        FILL_DATA_DEC: begin
            if(temp_done) begin
                in_data_next = data_out;
                state_next = SEND_DATA_DEC;
            end
        end
        SEND_DATA_DEC: begin
            if(temp_done) begin
                data_in = inv_cipher_out_data_k1;
                state_next = IDLE;
            end
        end
    endcase
end

cipher  k1 (
    .i_data(in_data_next[391-:128]),
    .expanded_key(selected_key),
    .NR(param/4 + 6),
    .o_data(cipher_out_data_k1)
     );

inv_cipher k2 (
    .i_data(in_data_next[391-:128]),
    .expanded_key(selected_key),
    .NR(param/4 + 6),
    .o_data(inv_cipher_out_data_k1)
     );

key_expansion #(.NK(4), .NR(10)) ke128 (
    .i_cypher_key(in_data_next[255 -:128]),
    .o_expanded_key(o_expanded_key_1)
);
// key_expansion #(.NK(6), .NR(12)) ke192 (
//     .i_cypher_key(in_data_next[255 -:192]),
//     .o_expanded_key(o_expanded_key_2)
// );
// key_expansion #(.NK(8), .NR(14)) ke256 (
//     .i_cypher_key(in_data_next[255 -:256]),
//     .o_expanded_key(o_expanded_key_3)
// );




assign done = temp_done;
assign data_in_w[383 -: 128] = data_in;
assign param = in_data_next[263-:8];
endmodule
