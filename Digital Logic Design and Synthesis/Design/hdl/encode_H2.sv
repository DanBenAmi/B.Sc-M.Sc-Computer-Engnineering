//
// Verilog Module Tom_Dan_2_0_lib.encode_H2
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 10:37:38 11/26/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module encode_H2    // calculate the parity bits in case of 16 bits mode (H2)
#( 
parameter DATA_WIDTH = 32
)
(
input  logic [10:0] DATA_IN,
output logic  [15:0] CodeWord
);

logic [4:0] parity;

assign     parity[0] =  DATA_IN[0]^DATA_IN[1]^DATA_IN[3]^DATA_IN[4]^DATA_IN[6]^DATA_IN[8]^DATA_IN[10];
assign     parity[1] =  DATA_IN[0]^DATA_IN[2]^DATA_IN[3]^DATA_IN[5]^DATA_IN[6]^DATA_IN[9]^DATA_IN[10];
assign     parity[2] =  DATA_IN[1]^DATA_IN[2]^DATA_IN[3]^DATA_IN[7]^DATA_IN[8]^DATA_IN[9]^DATA_IN[10];
assign     parity[3] =  DATA_IN[4]^DATA_IN[5]^DATA_IN[6]^DATA_IN[7]^DATA_IN[8]^DATA_IN[9]^DATA_IN[10];
assign     parity[4] = (^DATA_IN)^(^parity[3:0]);
assign     CodeWord = {DATA_IN[10:0],parity};
     
endmodule
