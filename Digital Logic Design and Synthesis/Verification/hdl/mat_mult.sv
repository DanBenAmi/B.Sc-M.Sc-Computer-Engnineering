//
// Verilog Module Tom_Dan_2_0_lib.mat_mult
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 15:12:12 11/19/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module mat_mult                   // calculate the multiplication Hy' , when H is the matrix which corresponds with 
#(                                //the codeword width, y is the codeword(might be noisy)
parameter DATA_WIDTH = 32
)
(
input  logic [DATA_WIDTH-1:0] NoisyCodeWord,
input  logic [1:0] Codeword_Width,
output logic [5:0] column
);

generate                         //generating different sub-modules with respect to the data width
  if (DATA_WIDTH == 8) begin              //data width is 8 bits maximum (H1)
    mat_mult_1 #(.DATA_WIDTH(DATA_WIDTH)) mat_mult_1(
   .NoisyCodeWord  (NoisyCodeWord),
   .column         (column[3:0])
  ); 
  assign column[5:4]=0;
  end
  else if(DATA_WIDTH == 16) begin       //data width is 16 bits maximum (H2)
    mat_mult_2 #(.DATA_WIDTH(DATA_WIDTH)) mat_mult_2(
   .NoisyCodeWord  (NoisyCodeWord),
   .Codeword_Width (Codeword_Width),
   .column         (column[4:0])
  ); 
  assign column[5]=0;
  end
  else begin                                  //data width is 32 bits maximum (H3)
    mat_mult_3 #(.DATA_WIDTH(DATA_WIDTH)) mat_mult_3(
   .NoisyCodeWord  (NoisyCodeWord),
   .Codeword_Width (Codeword_Width),
   .column         (column)
  ); end
endgenerate
endmodule
