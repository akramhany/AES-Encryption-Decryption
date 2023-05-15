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

//localparam BigReg = key_size

/// for testing, sending and reciving data
wire [127:0] plane_text;
assign plane_text = 128'h00112233445566778899aabbccddeeff;
wire [127:0] enc_text;
assign enc_text = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
reg [127:0] test_result_send;
reg [127:0] test_result_recive;
reg [255:0] key = 256'h000102030405060708090a0b0c0d0e0f10111213141516170000000000000000;


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
wire enc_send;

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
    .enc_recived(enc_send),
    .done(slave_done)
);

always @(posedge clk) begin

  if (reset) begin        
    wrapper_state   <= IDLE;
  end
  //TODO: put a condition to check if the start_system is 0 (make it asyncho)

end

reg [6:0] i = 0;

/*reg  [2:0]counter = 0;

always @ (posedge start) begin
    counter <= 0;
end

always @ (posedge clk) begin
counter <= counter + 1;
end

always @(posedge counter[2] ) begin
if(start)
  start <= 1'b0; 
end*/

//always #(PERIOD * 2) start = ~start;

reg [3:0] start_counter = 0;
reg [1:0] start_mini_counter = 0;

always @ (negedge clk) begin
    
    if (start_mini_counter == 2'b00 && wrapper_state != IDLE) begin
        $display("1");
        start = ~start;
        start_mini_counter = start_mini_counter + 1;
    end
    else if (start_mini_counter == 2'b01 && wrapper_state != IDLE)   begin
        $display("2");
        start_mini_counter = 2'b00;
end
end


always @ (*)  begin

case (wrapper_state)
    
    IDLE: begin
        start = 0;
        data_in = 8'h00;
        key_size = SIZE_192;
        i = SIZE_256 + 16;
        //TODO: create another reg of size 256 to store the key in it
        if (start_system && ~reset) begin
            wrapper_state = SEND_ENC;
        end
    end

    SEND_ENC: begin

        if (i == SIZE_256 + 16) begin
            //start = 1;
            data_in = plane_text[127 -: 8];
            i = i - 1;
        end
        else if (slave_done) begin
            //start = 1;
            if (i > SIZE_256)    begin
                data_in = plane_text[(i - key_size - (SIZE_256 - key_size)) * 8 - 1 -: 8];
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
        if (i ==  19) begin
            //start = 1;
            test_result_recive[i * 8 - 1 -: 8] = data_out;
            i = i - 1;
        end
        else if (slave_done) begin
            //start = 1;
            if (i > 0) begin
                test_result_recive[i * 8 - 1 -: 8] = data_out;
                i = i - 1;
            end
            else    begin
                wrapper_state = CHECK_ENC;
                i = key_size + 16;
            end
        end
    end

    CHECK_ENC: begin
        if (test_result_recive == enc_text) begin
            $display("Finallyyyyyyyyyyyyyy");
        end
        else begin
            $display("Kill me please");
        end
        start_system = 0;   //TODO: delete this statement if you want the program to run normally
        wrapper_state = IDLE;
    end
    

endcase
end

initial begin
start_system = 1;
reset = 1;
test_result_recive = 0;

#(8 * PERIOD) reset = 0;

end



endmodule