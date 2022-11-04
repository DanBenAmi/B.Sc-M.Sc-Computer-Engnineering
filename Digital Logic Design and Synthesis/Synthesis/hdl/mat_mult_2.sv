//
// Verilog Module Tom_Dan_2_0_lib.mat_mult_2
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 12:09:30 11/26/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module mat_mult_2 #(                // calculating the s from the equation Hy'=s, i.e. calaulate the multiplication of H with the codeword. 
parameter DATA_WIDTH = 32
)
(
input  logic [DATA_WIDTH-1:0] NoisyCodeWord,
input  logic [1:0] Codeword_Width,
output logic [4:0] column
);



always @ (Codeword_Width or NoisyCodeWord)
begin : MUX
  if(Codeword_Width==0)           //8 bit mode, multiply using H1
  begin : H1
    column[4] = 0;
    column[3] = ^(NoisyCodeWord);
    column[2] = ^(NoisyCodeWord[7:5])^NoisyCodeWord[2]; 
    column[1] = ^(NoisyCodeWord[7:6])^NoisyCodeWord[4]^NoisyCodeWord[1];
    column[0] = NoisyCodeWord[7]^(^(NoisyCodeWord[5:4]))^NoisyCodeWord[0];
  end
  
  else                          //16 bit mode, multiply using H2
  begin : H2
    column[4] = ^(NoisyCodeWord);
    column[3] = ^(NoisyCodeWord[15:9])^NoisyCodeWord[3]; 
    column[2] = ^(NoisyCodeWord[15:12])^(^(NoisyCodeWord[8:6]))^NoisyCodeWord[2]; 
    column[1] = ^(^(NoisyCodeWord[15:14]))^(^(NoisyCodeWord[11:10]))^(^(NoisyCodeWord[8:7]))^NoisyCodeWord[5]^NoisyCodeWord[1];
    column[0] = NoisyCodeWord[15]^NoisyCodeWord[13]^NoisyCodeWord[11]^(^(NoisyCodeWord[9:8]))^(^(NoisyCodeWord[6:5]))^NoisyCodeWord[0];

  end

end
endmodule