//
// Verilog Module Tom_Dan_2_0_lib.encoder
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 17:56:14 11/18/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module encoder        // receive the "data in" and return encoded codeword with respect to the number of bits mode
#( 
parameter DATA_WIDTH = 8
)
(
input  logic [DATA_WIDTH-1:0] DATA_IN,
input  logic [1:0] Codeword_Width,
output logic  [DATA_WIDTH-1:0] CodeWord
);

logic  [7:0] CodeWord1;
logic  [15:0] CodeWord2;
logic  [DATA_WIDTH-1:0] CodeWord3;
  generate                              //generating different sub-modules with respect to the data width 
   if (DATA_WIDTH == 8) begin                   //data width is 8 bits maximum (H1)
      encode_H1 #(.DATA_WIDTH(DATA_WIDTH)) U_encode_H1(
      .DATA_IN  (DATA_IN[3:0]),
      .CodeWord (CodeWord)
    ); end
    
    else if (DATA_WIDTH == 16) begin             //data width is 16 bits maximum  (H1, H2)
      encode_H1 #(.DATA_WIDTH(DATA_WIDTH)) U_encode_H1(
       .DATA_IN  (DATA_IN[3:0]),
       .CodeWord (CodeWord1));
      encode_H2 #(.DATA_WIDTH(DATA_WIDTH)) U_encode_H2(
       .DATA_IN  (DATA_IN[10:0]),
       .CodeWord (CodeWord2)); 
      always @*
      begin : num_bits_mode_mux12
        if(Codeword_Width==0)CodeWord = {{(DATA_WIDTH-8){1'b0}},CodeWord1};
        else CodeWord = CodeWord2;
      end
    end
    
    else if (DATA_WIDTH == 32) begin             //data width is 32 bits maximum  (H1,H2,H3)
      encode_H1 #(.DATA_WIDTH(DATA_WIDTH)) U_encode_H1(
       .DATA_IN  (DATA_IN[3:0]),
       .CodeWord (CodeWord1));
      encode_H2 #(.DATA_WIDTH(DATA_WIDTH)) U_encode_H2(
       .DATA_IN  (DATA_IN[10:0]),
       .CodeWord (CodeWord2)); 
       encode_H3 #(.DATA_WIDTH(DATA_WIDTH)) U_encode_H3(
       .DATA_IN  (DATA_IN[25:0]),
       .CodeWord (CodeWord3));
      always @*
      begin: num_bits_mode_mux123
        if(Codeword_Width==0)CodeWord = {{(DATA_WIDTH-8){1'b0}},CodeWord1};
        else if(Codeword_Width==1)CodeWord = {{(DATA_WIDTH-16){1'b0}},CodeWord2};
        else CodeWord = CodeWord3;
      end
    end
  endgenerate
endmodule
