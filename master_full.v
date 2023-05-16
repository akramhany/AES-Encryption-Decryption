/*
    *
    * Module: master
    * Description: this module is the master module in the spi protocol
    * ==============================================
    * Inputs:

    * Outputs:

    * Author: Amir Kedis 
    * Date: 10 - May - 2023 
*/

module master_full (
  // Control Signals
  input reset,      // reset the state of the master (active high)
  input clk,        // clock (from FPGA)
  input start,      // start the state machine
  output buzy,      // busy signal indicates transmistion not finished (1-bit)
  output done,      // done signal indicates transmistion finished output ready (1-bit)

  // DATA Signals
  input [391:0] data_in,  // the 1-byte data sent to the slave
  output [391:0] data_out,// the 1-byte data received from the slave

  // SPI Signals
  output cs,            // chip select active low
  output mosi,          // master output slave input (1-bit)
  input miso,           // master input slave output (1-bit)
  output sclk           // serial clock 
);

////////////////////////////  Local Parameters  //////////////////////////////
localparam IDLE     = 2'b00; // idle state
localparam WAIT     = 2'b01; // send state
localparam TRANSFER = 2'b10; // wait state - Will be used to skip first halh cycle


////////////////////////////  Registers  //////////////////////////////
reg [1:0] state_reg;          // the current state of the state machine
reg [391:0] data_in_reg;        // the 1-byte data sent to the slave
reg [391:0] data_out_reg;       // the 1-byte data received from the slave
reg [1:0] sclk_reg;           // serial clock Register (clk divider by 2)
reg mosi_reg;                 // master output slave input Register (1-bit)
reg [9:0] counter_reg;        // counter to count the number of bits sent/received
reg done_reg;                 // done signal reg
reg cs_reg;                   // chip select active low reg

////////////////////////////  next states  //////////////////////////////
reg [1:0] state_next;               // controling the next state logic of the state_reg
reg [391:0] data_in_next;       // controling the next state logic of the data_in_reg
reg [391:0] data_out_next;      // controling the next state logic of the data_out_reg
reg [1:0] sclk_next;          // controling the next state logic of the sclk_reg
reg mosi_next;                // controling the next state logic of the mosi_reg
reg [9:0] counter_next;       // controling the next state logic of the counter_reg
reg done_next;                // controling the next state logic of the done_reg
reg cs_next;                  // controling the next state logic of the cs_reg

////////////////////////////  Memory (Flip-Flop)  //////////////////////////////
always @(posedge clk) begin
  if (reset) begin        // Reset is active high
    // Reset Values
    state_reg     <= IDLE;
    data_in_reg   <= 8'b0;
    data_out_reg  <= 8'b0;
    sclk_reg      <= 2'b0;
    mosi_reg      <= 1'b0;
    counter_reg   <= 3'b0;
    done_reg      <= 1'b0;
    cs_reg        <= 1'b1;
  end
  else begin
    state_reg     <= state_next;
    data_in_reg   <= data_in_next;
    data_out_reg  <= data_out_next;
    sclk_reg      <= sclk_next;
    mosi_reg      <= mosi_next;
    counter_reg   <= counter_next;
    done_reg      <= done_next;
    cs_reg        <= cs_next;
  end
end

////////////////////////////  next states logic (Main Process)  //////////////////////////////
always @(*) begin
  // default values
  state_next    = state_reg;
  data_in_next  = data_in_reg;
  data_out_next = data_out_reg;
  sclk_next     = sclk_reg;
  mosi_next     = mosi_reg;
  counter_next  = counter_reg;
  done_next     = 0;
  cs_next       = cs_reg;

  case (state_reg)

    IDLE: begin
      // reset values
      sclk_next = 2'b0;
      counter_next = 3'b0;

      // if begin go to wait state and register the data
      if (start == 1'b1) begin
        state_next = WAIT;
        data_in_next = data_in;
        cs_next = 1'b0;
      end
    end // IDLE

    WAIT: begin
      sclk_next = sclk_reg + 1'b1;
      // next code skips half cycle then goes to transfer state
      if (sclk_reg == 2'b01) begin
        state_next = TRANSFER;
        sclk_next   = 2'b00;
      end
    end // WAIT

    TRANSFER: begin
      sclk_next = sclk_reg + 2'b01; // increment the clock
      // 1. send data at the first half cycle
      if (sclk_reg == 2'b00) begin
        mosi_next = data_in_reg[391]; // send the MSB first
      end
      // 2. Fallen Edge => read and shift data
      else if  (sclk_reg == 2'b01) begin
        data_in_next = {data_in_reg[390:0], 1'bz}; // shift the data
        data_out_next = {data_out_reg[390:0], miso}; // shift the data
      end
      // 3. Rising Edge => Increment counter
      else if (sclk_reg == 2'b11) begin
        counter_next = counter_reg + 1'b1; // increment the counter

        // if last bit go to idle state and output the data
        if (counter_reg == 9'd391) begin
          state_next = IDLE;
          data_out_next = data_out_reg;
          done_next = 1'b1;
          cs_next = 1'b1;
        end
      end
    end // TRANSFER

  endcase

end


////////////////////////////  Output Logic  //////////////////////////////
assign mosi = mosi_reg;       // master output slave input (1-bit)
// sends the clock every two cycles only when state is transfer
assign sclk = ~sclk_reg[1] & (state_reg == TRANSFER);     // serial clock (1-bit)
assign buzy = (state_reg != IDLE);  // busy is high if state is transfer or wait
assign data_out =  data_out_reg;    
assign cs = cs_reg;           // chip select active low
assign done = done_reg;       // done signal

endmodule