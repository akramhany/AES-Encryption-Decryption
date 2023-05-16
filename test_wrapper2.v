`include "master_full.v"
`include "AES.v"

module test_wrapper2();

localparam PERIOD = 10;

localparam SIZE_128 = 8'd16;
localparam SIZE_192 = 8'd24;
localparam SIZE_256 = 8'd32;

localparam IDLE = 4'b0000;
localparam SEND_ENC = 4'b0001;
localparam WAIT_ENC = 4'b0010;
localparam REC_ENC = 4'b0011;
localparam CHECK_ENC = 4'b0100;
localparam SEND_DEC = 4'b0101;
localparam WAIT_DEC1 = 4'b0110;
localparam REC_DEC = 4'b0111;
localparam CHECK_DEC = 4'b1000;
localparam WAIT_DEC2 = 4'b1001;

//localparam BigReg = key_size

/// for testing, sending and reciving data
wire [127:0] plane_text;
assign plane_text = 128'h00112233445566778899aabbccddeeff;
wire [127:0] enc_text;
assign enc_text = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
reg [127:0] test_result_send;
reg [391:0] test_result_recive;

/// for testing, sending and reciving data/////////////////////////////////////////////////////
reg [1:0] test_number = 2'd0;

wire [127:0] ciphered_text;
assign ciphered_text = (test_number == 2'd1) ? 128'h69c4e0d86a7b0430d8cdb78070b4c55a:
      (test_number == 2'd2) ? 128'hdda97ca4864cdfe06eaf70a0ec0d7191:
      (test_number == 2'd3) ? 128'h8ea2b7ca516745bfeafc49904b496089;

wire [127:0] plane_text;
assign plane_text = 128'h00112233445566778899aabbccddeeff;
reg [127:0] test_result_send;

wire [255:0] key;
assign key = (test_number == 2'd1) ? 256'h000102030405060708090a0b0c0d0e0f00000000000000000000000000000000:
      (test_number == 2'd2) ? 256'h000102030405060708090a0b0c0d0e0f10111213141516170000000000000000:
      (test_number == 2'd3) ? 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;


wire [7:0] key_size;
assign key_size = (test_number == 2'd1) ? 8'd16:
      (test_number == 2'd2) ? 8'd24:
      (test_number == 2'd3) ? 8'd32;
      
//////////////////////////////////////////////////////////////////////////////////////////////

reg clk = 0;
always #(PERIOD / 2) clk = ~clk;

reg reset;
reg start;
wire buzy;
wire done;
wire slave_done;
reg  [391:0] data_in;
wire [391:0] data_out;
wire cs;
wire mosi;
wire miso;
wire sclk;

reg start_system;
reg [3:0] wrapper_state;
reg [3:0] wrapper_state_next;

master_full dut (
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

AES aes(
    .reset(reset),
    .clk(clk),
    .cs(cs),
    .mosi(mosi),
    .miso(miso),
    .sclk(sclk),
    .done(slave_done)
); 


always @(posedge clk) begin

  if (reset) begin        
    wrapper_state   <= IDLE;
  end
  else begin
    wrapper_state   <= wrapper_state_next;
  end
  //TODO: put a condition to check if the start_system is 0 (make it asyncho)
end


always @ (*)  begin

case (wrapper_state)
    
    IDLE: begin
      test_number = test_number + 1'b1;
        start = 0;
        data_in = 8'h00;
        
        //TODO: create another reg of size 256 to store the key in it
        if (start_system && ~reset) begin
            wrapper_state_next = SEND_ENC;
            data_in = {plane_text, key_size, keys[test_number]};
            start = 1;
        end
    end

    SEND_ENC: begin
        start = 0;
        if (done) begin
          start = 1;
          wrapper_state_next = WAIT_ENC;
        end

    end

    WAIT_ENC: begin
        start = 0;

        if (done) begin
          start = 1;
          wrapper_state_next = REC_ENC;    
        end
    end

    REC_ENC: begin
        start = 0;

        if (done) begin
          start = 1;
          test_result_recive = data_out;
          wrapper_state_next = CHECK_ENC;    
        end
    end

    CHECK_ENC: begin
        if (test_result_recive[383 -: 128] == ciphered_text[test_number]) begin
            $display("Finallyyyyyyyyyyyyyy");
            $display("%h",test_result_recive[383 -: 128]);
            $display("%h",plane_text);
        end
        else begin
            $display("Kill me please");
        end
           //TODO: delete this statement if you want the program to run normally
        wrapper_state_next = SEND_DEC;
        data_in = {test_result_recive[383 -: 128], key_size, keys[test_number]};    
    end

    SEND_DEC: begin
      start = 0;
      if (done) begin
        start = 1;
        wrapper_state_next = WAIT_DEC1;
      end
    end

    WAIT_DEC1: begin
        start = 0;
        if (done) begin
          start = 1;
          wrapper_state_next = WAIT_DEC2;    
        end
    end

    WAIT_DEC2: begin
        start = 0;
        if (done) begin
          start = 1;
          wrapper_state_next = REC_DEC;    
        end
    end

    REC_DEC: begin
        start = 0;
        if (done) begin
          start = 1;
          test_result_recive = data_out;
          wrapper_state_next = CHECK_DEC;
        end 
    end

    CHECK_DEC: begin
        if (test_result_recive[383 -: 128] == plane_text) begin
            $display("OMGGGGGGGGGGGGGGGGGGGGGGG");
            $display("%h",test_result_recive[383 -: 128]);
            $display("%h",plane_text);
        end
        else begin
            $display("Kill me please");
            $display("%h",test_result_recive[383 -: 128]);
            $display("%h",plane_text);
        end
           //TODO: delete this statement if you want the program to run normally
        wrapper_state_next = IDLE;
        start_system = 0;
    end

endcase
end

initial begin
start_system = 1;
reset = 1;

#(5 * PERIOD) reset = 0;

end



endmodule