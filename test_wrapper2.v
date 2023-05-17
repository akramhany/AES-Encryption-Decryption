`include "master_full.v"
`include "AES.v"

module test_wrapper2();

localparam PERIOD = 10;

localparam SIZE_128 = 8'd16;
localparam SIZE_192 = 8'd24;
localparam SIZE_256 = 8'd32;

localparam IDLE = 4'b0000;
localparam SEND = 4'b0001;
localparam WAIT = 4'b0010;
localparam REC = 4'b0011;
localparam CHECK = 4'b0100;

//localparam BigReg = key_size

/// for testing, sending and reciving data
wire [127:0] plane_text;
wire [127:0] enc_text;

reg [127:0] test_result_send;
reg [391:0] test_result_recive;

wire [255:0] key;

reg clk = 0;
always #(PERIOD / 2) clk = ~clk;

reg reset;
reg sync;
reg start;
wire buzy;
wire done;
wire slave_done;
wire  [391:0] data_in;
wire [391:0] data_out;
wire cs;
wire mosi;
wire miso;
wire sclk;

reg start_system;
reg [3:0] wrapper_state;
reg [3:0] wrapper_state_next;
wire [7:0] key_size;

master_full dut (
  .reset(sync),
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
    .sync(sync),
    .clk(clk),
    .cs(cs),
    .mosi(mosi),
    .miso(miso),
    .sclk(sclk),
    .done(slave_done)
); 

reg [1:0] counter = 0;


always @(posedge clk) begin

  if (sync) begin        
    wrapper_state   <= IDLE;
      counter <= counter + 1;
  end
  else begin
    wrapper_state   <= wrapper_state_next;
    if (wrapper_state == CHECK) begin
    end
  end
  //TODO: put a condition to check if the start_system is 0 (make it asyncho)
end



always @ (*)  begin

case (wrapper_state)
    
    IDLE: begin

        start = 0;
        sync = 0;
        if (counter == 2'b00) begin
            start_system = 0;
        end
        else begin
          start_system = 1;
        end
        if (start_system && ~sync) begin
            wrapper_state_next = SEND;
            start = 1;
        end
    end

    SEND: begin
        start = 0;
        if (done) begin
          start = 1;
          wrapper_state_next = WAIT;
        end

    end

    WAIT: begin
        start = 0;

        if (done) begin
          start = 1;
          wrapper_state_next = REC; 
        end
    end

    REC: begin
        start = 0;

        if (done) begin
          start = 1;
          test_result_recive = data_out;
          wrapper_state_next = CHECK;
        end
    end

    CHECK: begin
        start = 0;
        if (test_result_recive[383 -: 128] == enc_text && test_result_recive[255 -: 128] == plane_text) begin
            $display("Finallyyyyyyyyyyyyyy");
            $display("%h",test_result_recive[383 -: 256]);
            $display("%h",plane_text);
        end
        else begin
            $display("Kill me please");
            $display("%d", $time);
        end
        wrapper_state_next = IDLE;
        sync = 1;
    end
endcase
end

initial begin
start_system = 1;
reset = 1;
sync = 1;

#(5 * PERIOD) sync = 0;
reset = 0;

end

assign key_size = (counter == 2'b01) ? SIZE_128 : 
(counter == 2'b10) ? SIZE_192 :
(counter == 2'b11) ? SIZE_256 : 128'h0;

assign enc_text = (counter == 2'b01) ? 128'h69c4e0d86a7b0430d8cdb78070b4c55a :
(counter == 2'b10) ? 128'hdda97ca4864cdfe06eaf70a0ec0d7191 :
(counter == 2'b11) ? 128'h8ea2b7ca516745bfeafc49904b496089 : 128'h0;

assign key = (counter == 2'b01) ? 256'h000102030405060708090a0b0c0d0e0f00000000000000000000000000000000 :
(counter == 2'b10) ? 256'h000102030405060708090a0b0c0d0e0f10111213141516170000000000000000 :
(counter == 2'b11) ? 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f : 256'h0;


assign plane_text = (counter == 2'b01) ? 128'h00112233445566778899aabbccddeeff :
(counter == 2'b10) ? 128'h00112233445566778899aabbccddeeff :
(counter == 2'b11) ? 128'h00112233445566778899aabbccddeeff : 128'h0;

assign data_in = {plane_text, key_size, key};


endmodule