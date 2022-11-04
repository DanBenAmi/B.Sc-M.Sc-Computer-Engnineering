//
// Verilog Module Tom_Dan_2_0_lib.noise_adder
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 15:08:28 11/20/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module noise_adder      //adding the noise from the noise register to the codeword from the encoderS
#( 
parameter DATA_WIDTH = 32
)
(
input logic [DATA_WIDTH-1:0]noise,
input logic [DATA_WIDTH-1:0]Encoded_data,
output logic [DATA_WIDTH-1:0]noisy_codeword
);

assign noisy_codeword = noise ^ Encoded_data;
endmodule
