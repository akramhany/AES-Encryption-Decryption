/*
    *
    * Module: 
    * Description:
    * ==============================================
    * Inputs:

    * Outputs:


    * Author: Akram Hany
    * Date: 10 - May - 2023 
*/

`include "master.v"
`include "Decryption/decrypt.v"
`include "Encryption/encrypt.v"

module test_wrapper();

localparam PERIOD = 10;

localparam SIZE_128 = 8'd16;
localparam SIZE_192 = 8'd24;
localparam SIZE_256 = 8'd32;

localparam IDLE = 3'b000;
localparam SEND_ENC = 3'b001;
localparam REC_ENC = 3'b010;
localparam CHECK_ENC = 3'b011;
localparam SEND_DEC = 3'b100;
localparam REC_DEC = 3'b101;
localparam CHECK_DEC = 3'b110;

localparam key_128 = 256'h000102030405060708090a0b0c0d0e0f00000000000000000000000000000000;
localparam key_192 = 256'h000102030405060708090a0b0c0d0e0f10111213141516170000000000000000;
localparam key_256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

reg [256:0] keys [1:3];

localparam ciphered_text_128 = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
localparam ciphered_text_192 = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
localparam ciphered_text_256 = 128'h8ea2b7ca516745bfeafc49904b496089;

//localparam BigReg = key_size

/// for testing, sending and reciving data/////////////////////////////////////////////////////
wire [127:0] plane_text;
assign plane_text = 128'h00112233445566778899aabbccddeeff;
wire [127:0] enc_text;
assign enc_text = ciphered_text_128;
reg [127:0] test_result_send;
reg [127:0] test_result_recive[1:3];
reg [255:0] key = key_128;
//////////////////////////////////////////////////////////////////////////////////////////////


reg clk = 0;
always #(PERIOD / 2) clk = ~clk;

reg reset;
reg start;
wire buzy;
wire done;
reg [7:0] data_in;
wire [7:0] data_out;
wire cs;
wire mosi;
wire miso;
wire sclk;

wire slave_done;
//reg [7:0] slave_data_in;
wire enc_sending;

reg start_system;
reg [2:0] wrapper_state = IDLE;
reg [7:0] key_size;

master dut (
    .reset(reset),
    .clk(clk),
    .start(start),
    .buzy(buzy),
    .done(done),
    .data_in(data_in),
    .data_out(data_out),
    .cs(cs),
    .mosi(mosi),
    .miso(miso),
    .sclk(sclk)  
);

encrypt encrypt_file (
    .reset(reset),
    .clk(clk),
    .cs(cs),
    .mosi(mosi),
    .miso(miso),
    .sclk(sclk),
    .enc_sending(enc_sending),
    .done(slave_done)
);

always @(posedge clk) begin

  if (reset) begin        
    wrapper_state   <= IDLE;
  end
  //TODO: put a condition to check if the start_system is 0 (make it asyncho)

end

reg [6:0] i = 0;
reg [1:0] test_number = 1'b1;

reg [4:0] counter = 0;
always @ (posedge start) begin
    counter = 0;
end
always @ (posedge clk) begin
counter = counter + 1;
end
always @(posedge counter[4] ) begin
if(start)
  start = 1'b0; 
end

reg [2:0] receive_counter = 0;
reg receive_order = 0;

always @ (posedge clk)  begin
    receive_counter = receive_counter + 1;
end
always @(posedge receive_counter[2]) begin
    if(start && enc_sending) begin
        receive_order = 1'b0;
        start = 1'b0;
    end
    if (slave_done == 0 && receive_order)
        start = 1'b1;
end

always @ (posedge clk)  begin
case (wrapper_state)
    
    IDLE: begin
        start = 0;
        data_in = 8'h00;
        key_size = SIZE_128;
        i = SIZE_256 + 16;
        keys[1] = 256'h000102030405060708090a0b0c0d0e0f00000000000000000000000000000000;
        keys[2] = 256'h000102030405060708090a0b0c0d0e0f10111213141516170000000000000000;
        keys[3] = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        //TODO: create another reg of size 256 to store the key in it
        if (start_system && ~reset) begin
            wrapper_state = SEND_ENC;
        end
    end

    SEND_ENC: begin

        if (i == SIZE_256 + 16) begin
            start = 1;
            data_in = plane_text[127 -: 8];
            i = i - 1;
        end
        else if (slave_done) begin
            start = 1;
            if (i > SIZE_256)    begin
                data_in = plane_text[(i - SIZE_256) * 8 - 1 -: 8];
                i = i - 1;
            end
            else if (i >= 0 && i < SIZE_256)    begin
                data_in = key[(i + 1) * 8 - 1 -: 8];
                if (i == 0) begin
                    wrapper_state = REC_ENC;
                    i = 20;
                end
                i = i - 1;
            end
            else if (i == SIZE_256)   begin
                data_in = key_size;
                i = i - 1;
            end
        end
    end

    REC_ENC: begin

        if (enc_sending) begin
            if (i > 0) begin
                if (i == 19) begin
                    receive_order = 1;
                    i = i - 1;
                end
                else if (slave_done) begin
                    receive_order = 1;
                    test_result_recive[test_number][(i) * 8 - 1 -: 8] = data_out;
                    i = i - 1;
                  
                end
            end
            else    begin
                wrapper_state = CHECK_ENC;
                i = key_size + 16;
            end
        end
    end

    CHECK_ENC: begin
        if (test_result_recive[test_number] == enc_text) begin
            $display("Finallyyyyyyyyyyyyyy");
        end
        else begin
            $display("Kill me please");
        end
        start_system = 0;   //TODO: delete this statement if you want the program to run normally
        wrapper_state = IDLE;
        test_number = test_number + 1'b1;
    end

endcase
end

initial begin
start_system = 1;
reset = 1;

#(5 * PERIOD) reset = 0;

end



endmodule