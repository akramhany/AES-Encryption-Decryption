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
    output reg enc_recived
    

);


reg [127:0] cipher_in_data;
reg [7:0] parameters; // {NK, NR}
reg [256:0] key;
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


localparam IDLE             = 3'b000; 
localparam FILL_DATA        = 3'b001; 
localparam FILL_PARAMETERS  = 3'b010;
localparam FILL_KEY         = 3'b011;
localparam SEND_DATA        = 3'b100;

reg [4:0]c1; //counts FILL_DATA
reg [5:0]c2; //counts FILL_KEY
reg [4:0]c3; //counts SEND_DATA



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
        cipher_in_data <= 128'b0;
        parameters <= 8'b0;
        key <= 256'b0;

        c1 = 5'b0;
        c2 = 6'b0;
        c3 = 5'b0;
        
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
            c1 = 5'b0;
            c2 = 6'b0;
            c3 = 5'b0;
            if(!cs) begin
                state_next <= FILL_DATA;
            end
        end
        FILL_DATA: begin
            if(c1 < 16)begin
                if(temp_done) begin
                    $display("hahahahahah");
                    cipher_in_data[7:0] = data_out;
                    if (c1 < 15) begin
                        cipher_in_data = cipher_in_data << 8;
                    end
                    c1 = c1 + 1'b1;
                    $display("%b", c1);
                end
                state_next = FILL_DATA;
            end
            else begin
                state_next = FILL_PARAMETERS;
            end
        end
        FILL_PARAMETERS: begin
            if(temp_done) begin
                parameters = data_out;
                if(parameters != 0)
                    state_next = FILL_KEY;
            end
        end
        FILL_KEY: begin
            if(c2 < parameters) begin
                if(temp_done)begin
                    key[7:0] = data_out;
                    key = key << 8; 
                    c2 = c2 + 1;
                end
                state_next = FILL_KEY;
            end
            else begin
                state_next = SEND_DATA;  
            end
        end
        SEND_DATA: begin
            cipher_out_data_k1_reg = cipher_out_data_k1;
            cipher_out_data_k2_reg = cipher_out_data_k2;
            cipher_out_data_k3_reg = cipher_out_data_k3;
            if(c3 < 16) begin
				if(temp_done) begin
                    case(parameters)
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
                            data_in = cipher_out_data_k3_reg[127:120];
                            cipher_out_data_k3_reg = cipher_out_data_k3_reg << 8;
                            c3 = c3 +1;
                        end
                    endcase
                end
                state_next = SEND_DATA;
            end
            else if(c3 == 16) begin
                enc_recived = 1;
                state_next = IDLE;
            end


        end
    endcase
end

cipher #(4,10) k1 (
    .i_data(cipher_in_data),
    .i_key(key[127:0]),
    .o_data(cipher_out_data_k1)
     );
cipher #(6,12) k2 (
    .i_data(cipher_in_data),
    .i_key(key[191:0]),
    .o_data(cipher_out_data_k2)
     );
cipher #(8,14) k3 (
    .i_data(cipher_in_data),
    .i_key(key[255:0]),
    .o_data(cipher_out_data_k3)
     );

assign done = temp_done;
assign data_in_w = data_in;
endmodule
