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
`include "../slave_full.v"
module encrypt (
    input reset,
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

// reg [127:0] cipher_out_data_k1_reg;
// reg [127:0] cipher_out_data_k2_reg;
// reg [127:0] cipher_out_data_k3_reg;


wire temp_done;
wire [391:0] data_out;
wire [391:0] data_in_w;
reg [127:0] data_in;
reg [2:0] state_reg;
reg [2:0] state_next;

wire [7:0]param;

localparam IDLE             = 2'b00; 
localparam FILL_DATA        = 2'b01; 
localparam SEND_DATA        = 2'b10;




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

        //should we add a counter to give the cipher a chance to compute ??

        state_reg <= 2'b0;

    end
    else begin
        state_reg <= state_next;
    end
end

always @(posedge clk) begin
    state_next = state_reg;
    
    case(state_reg)
        IDLE: begin
            if(!cs) begin
                state_next <= FILL_DATA;
            end
        end
        FILL_DATA: begin
            if(temp_done) begin
                in_data = data_out;
                state_next = SEND_DATA;
            end
        end
        SEND_DATA: begin
            // cipher_out_data_k1_reg = cipher_out_data_k1;
            // cipher_out_data_k2_reg = cipher_out_data_k2;
            // cipher_out_data_k3_reg = cipher_out_data_k3;
            if(temp_done) begin
                case(param)
                    8'd16: begin
                        data_in = cipher_out_data_k1;
                    end
                    8'd24: begin
                        data_in = cipher_out_data_k2;
                    end
                    8'd32: begin
                        data_in = cipher_out_data_k3;
                    end
                endcase
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
assign data_in_w[391 -: 128] = data_in;
assign param = in_data[263-:8];
endmodule
