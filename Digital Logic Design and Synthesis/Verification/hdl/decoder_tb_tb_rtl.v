//
// Test Bench Module Tom_Dan_2_0_lib.decoder_tb.decoder_tester
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 11:01:34 11/19/2021
//
// Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
//
`resetall
`timescale 1ns/10ps

module decoder_tb;

// Local declarations
parameter AMBA_WORD = 32;
parameter AMBA_ADDR_WIDTH = 20;
parameter DATA_WIDTH = 32;

// Internal signal declarations
logic                    clk = 1'b0;
logic [DATA_WIDTH - 1:0] NoisyCodeWord;
logic [1:0]              Codeword_Width;
logic [DATA_WIDTH - 1:0] Decoded_Data;
logic [1:0]              NumOfErrors;


always //generate clk (what is the clock frequency & duty cycle in this simulation?)
 #1 clk <= ~clk;

decoder #(AMBA_WORD,AMBA_ADDR_WIDTH,DATA_WIDTH) U_0(
   .clk            (clk),
   .NoisyCodeWord  (NoisyCodeWord),
   .Codeword_Width (Codeword_Width),
   .Decoded_Data   (Decoded_Data),
   .NumOfErrors    (NumOfErrors)
);



initial begin
  
  #10.2ns;  //asyncrounsly de-assert asrtn
  Codeword_Width <= 0;
  #10; // keep low for 10 ticks
  @(posedge clk) NoisyCodeWord <= 8'b10101010; //assert with clk rising edge
  #10; // keep low for 10 ticks
  @(posedge clk) NoisyCodeWord <= 8'b00101010; //assert with clk rising edge
  #10;
   @(posedge clk) NoisyCodeWord <= 8'b10101011; //assert with clk rising edge
  #50; // keep low for 10 ticks
  
  Codeword_Width <= 1;
  #10; // keep low for 10 ticks
  @(posedge clk) NoisyCodeWord <= 16'h86b9; //assert with clk rising edge
  #10; // keep low for 10 ticks
  @(posedge clk) NoisyCodeWord <= 16'b0000011010111001; //assert with clk rising edge
  #10;
   @(posedge clk) NoisyCodeWord <= 16'b1100011010111001; //assert with clk rising edge
   #50; // keep low for 10 ticks
  
  Codeword_Width <= 2;
  #10; // keep low for 10 ticks
  @(posedge clk) NoisyCodeWord <= 32'b10101010101010101010101010101010; //assert with clk rising edge
  #10; // keep low for 10 ticks
  @(posedge clk) NoisyCodeWord <= 32'b00101010101010101010101010101010; //assert with clk rising edge
  #10;
   @(posedge clk) NoisyCodeWord <= 32'b10101010101010101010101010101011; //assert with clk rising edge
  #10; // keep low for 10 ticks
  
end

endmodule // decoder_tb


