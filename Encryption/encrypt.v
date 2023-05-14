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
    input clk,            
    output done, 
    input sclk,           
    output miso, 
    input mosi,         
    input cs            
);


reg [127:0] cipher_in_data;
reg [7:0] parameters; // {NK, NR}
reg [256:0] key;
reg [127:0] cipher_out_data;


wire temp_done;
wire [7:0] data_out;
wire [7:0] data_in;
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
  .data_in(data_in),
  .data_out(data_out),
  .done(temp_done)
);

always@(posedge clk) begin
    if(reset) begin
        cipher_in_data <= 128'b0;
        cipher_out_data <= 128'b0;
        parameters <= 8'b0;
        key <= 256'b0;

        c1 <= 5'b0;
        c2 <= 6'b0;
        c3 <= 5'b0;
        //should we add a counter to give the cipher a chance to compute ??

        state_reg <= 3'b0;

    end
    else begin
        state_reg <= state_next;
    end
end

always@(*) begin
    state_next = state_reg;
    
    case(state_reg)
        IDLE: begin
            if(!cs)
                state_next <= FILL_DATA;
        end
        FILL_DATA: begin
            if(c1 < 16)begin
                if(temp_done) begin
                    cipher_in_data[7:0] <= data_out;
                    cipher_in_data <= cipher_in_data << 8;
                    c1 <= c1 + 1;
                end
                state_next <= FILL_DATA;
            end
            else begin
                state_next <= FILL_PARAMETERS;
            end
        end
        FILL_PARAMETERS: begin
            if(temp_done) begin
                parameters <= data_out;
                state_next <= FILL_KEY;
            end
        end
        FILL_KEY: begin
            if(c2 < 4*parameters[7:4]) begin
                if(temp_done)begin
                    key[7:0] <= data_out;
                    key <= key << 8; 
                    c2 <= c2 + 1;
                end
                state_next <= FILL_KEY;
            end
        end
    endcase
end

//don't forget done


endmodule