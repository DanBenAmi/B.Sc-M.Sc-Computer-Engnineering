//
// Verilog Module Tom_Dan_2_0_lib.mat_mult_1
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 12:09:53 11/26/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module mat_mult_1             // calculating the s from the equation Hy'=s, i.e. calaulate the multiplication of H1 with the codeword. 
#( 
parameter DATA_WIDTH = 32
)
(
input  logic [DATA_WIDTH-1:0] NoisyCodeWord,
output logic [3:0] column
);



always @ (NoisyCodeWord)
begin : MUX
    column[3] = ^(NoisyCodeWord);
    column[2] = ^(NoisyCodeWord[7:5])^NoisyCodeWord[2]; 
    column[1] = ^(NoisyCodeWord[7:6])^NoisyCodeWord[4]^NoisyCodeWord[1];
    column[0] = NoisyCodeWord[7]^(^(NoisyCodeWord[5:4]))^NoisyCodeWord[0];
  end
endmodule
