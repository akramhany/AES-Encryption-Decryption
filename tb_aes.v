`include "master.v"
`include "decryption.v"

module tb_aes;
reg clk;
reg reset;


////////////////////////////// flags //////////////////////////////
reg flag_sending, flag_finished_sending, flag_next_byte;
reg [5:0] byte_counter;
reg [7:0] type_byte;

//////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// SIGNALS //////////////////////////////
// master
reg reset;
reg start;
wire buzy;
wire done;
wire slave_done;
reg [7:0] data_in;
wire [7:0] data_out;
wire cs;
wire mosi;
wire miso;
wire sclk;
////////////////////////////// spi_master //////////////////////////////
master spi_master (
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
//////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////// date regs //////////////////////////////
wire [127:0] plane_text;
assign plane_text = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
reg [127:0] text_to_send;
reg [127:0] key = 128'h000102030405060708090a0b0c0d0e0f;
reg [127:0] inv_cipherd_text = 128'd0;
////////////////////////////////////////////////////////////////////////

////////////////////////////// clock //////////////////////////////
localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    //$dumpfile("tb_aes.vcd");
    //$dumpvars(0, tb_aes);
end

initial begin
    reset=1;
    flag_sending = 0;
    flag_finished_sending = 0
    #(CLK_PERIOD*3) reset=0;clk=0;
    repeat(5) @(posedge clk);
    reset=1;
    @(posedge clk);
    repeat(2) @(posedge clk);
    $finish(2);
end

//the alway block I am going to use to send data
always @(posedge clk ) begin
    if(flag_sending && byte_counter >= 6'd50) begin
        byte_counter = 6'd1;
    end
    else if(flag_sending && flag_next_byte)
    {
        if(!start) begin
            start = 1'b0;
        end
        else begin
            start = 1'b0;
            flag_next_byte = 1'b0;
        end
    }
    else if (flag_sending && !flag_next_byte && slave_done) begin
        if(byte_counter <= 6'd16) begin
            data_in = text_to_send[(byte_counter*8 -1) -:8];
            byte_counter = byte_counter + 1;
        end
        else if (byte_counter <= 6'd)
    end
end

endmodule
`default_nettype wire