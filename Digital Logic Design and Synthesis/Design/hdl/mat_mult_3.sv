//
// Verilog Module Tom_Dan_2_0_lib.mat_mult_3
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 12:09:10 11/26/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module mat_mult_3#( 
parameter DATA_WIDTH = 32
)
(
input  logic [DATA_WIDTH-1:0] NoisyCodeWord,
input  logic [1:0] Codeword_Width,
output logic [5:0] column
);



always @ (Codeword_Width or NoisyCodeWord)      // calculating the s from the equation Hy'=s, i.e. calaulate the multiplication of H with the codeword. 
begin : MUX
  if(Codeword_Width==0)                //8 bit mode, multiply using H1
  begin : H1
    column[5] = 0;
    column[4] = 0;
    column[3] = ^(NoisyCodeWord);
    column[2] = ^(NoisyCodeWord[7:5])^NoisyCodeWord[2]; 
    column[1] = ^(NoisyCodeWord[7:6])^NoisyCodeWord[4]^NoisyCodeWord[1];
    column[0] = NoisyCodeWord[7]^(^(NoisyCodeWord[5:4]))^NoisyCodeWord[0];
  end
  
  else if(Codeword_Width==1)           //16 bit mode, multiply using H2
  begin : H2
    column[5] = 0;
    column[4] = ^(NoisyCodeWord);
    column[3] = ^(NoisyCodeWord[15:9])^NoisyCodeWord[3]; 
    column[2] = ^(NoisyCodeWord[15:12])^(^(NoisyCodeWord[8:6]))^NoisyCodeWord[2]; 
    column[1] = ^(^(NoisyCodeWord[15:14]))^(^(NoisyCodeWord[11:10]))^(^(NoisyCodeWord[8:7]))^NoisyCodeWord[5]^NoisyCodeWord[1];
    column[0] = NoisyCodeWord[15]^NoisyCodeWord[13]^NoisyCodeWord[11]^(^(NoisyCodeWord[9:8]))^(^(NoisyCodeWord[6:5]))^NoisyCodeWord[0];

  end
  
  else
  begin : H3                                   //32 bit mode, multiply using H3
    column[5] = ^(NoisyCodeWord);
    column[4] = ^(NoisyCodeWord[31:17])^NoisyCodeWord[4]; 
    column[3] = ^(NoisyCodeWord[31:24])^(^(NoisyCodeWord[16:10]))^NoisyCodeWord[3]; 
    column[2] = ^(^(NoisyCodeWord[31:28]))^(^(NoisyCodeWord[23:20]))^(^(NoisyCodeWord[16:13]))^(^(NoisyCodeWord[9:7]))^NoisyCodeWord[2];
    column[1] = ^(^(NoisyCodeWord[31:30]))^(^(NoisyCodeWord[27:26]))^(^(NoisyCodeWord[23:22]))^(^(NoisyCodeWord[19:18]))^(^(NoisyCodeWord[16:15]))^
    (^(NoisyCodeWord[12:11]))^(^(NoisyCodeWord[9:8]))^NoisyCodeWord[6]^NoisyCodeWord[1];
    column[0] = NoisyCodeWord[31]^NoisyCodeWord[29]^NoisyCodeWord[27]^NoisyCodeWord[25]^NoisyCodeWord[23]^NoisyCodeWord[21]^
    NoisyCodeWord[19]^(^(NoisyCodeWord[17:16]))^NoisyCodeWord[14]^NoisyCodeWord[12]^(^(NoisyCodeWord[10:9]))^(^(NoisyCodeWord[7:6]))^NoisyCodeWord[0];
  end
end
endmodule