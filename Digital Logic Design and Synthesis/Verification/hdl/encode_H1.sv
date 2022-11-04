//
// Verilog Module Tom_Dan_2_0_lib.encode_H1
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 10:37:16 11/26/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module encode_H1      // calculate the parity bits in case of 8 bits mode (H1)
#( 
parameter DATA_WIDTH = 32
)
(
input  logic [3:0] DATA_IN,
output logic  [7:0] CodeWord
);

logic [3:0] parity;

assign     parity[0] = DATA_IN[0]^DATA_IN[1]^DATA_IN[3];
assign     parity[1] = DATA_IN[0]^DATA_IN[2]^DATA_IN[3];
assign     parity[2] = DATA_IN[1]^DATA_IN[2]^DATA_IN[3];
assign     parity[3] = DATA_IN[0]^DATA_IN[1]^DATA_IN[2]^DATA_IN[3]^parity[0]^parity[1]^parity[2];
assign     CodeWord = {DATA_IN[3:0],parity};
endmodule
