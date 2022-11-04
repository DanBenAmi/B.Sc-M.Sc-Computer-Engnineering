//
// Verilog Module Tom_Dan_2_0_lib.encode_H3
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 10:37:58 11/26/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module encode_H3 #(         // calculate the parity bits in case of 32 bits mode (H3)
parameter DATA_WIDTH = 32
)
(
input  logic [25:0] DATA_IN,
output logic  [DATA_WIDTH-1:0] CodeWord
);

logic [5:0] parity;

assign     parity[0] =  DATA_IN[0]^DATA_IN[1]^DATA_IN[3]^DATA_IN[4]^DATA_IN[6]^DATA_IN[8]^DATA_IN[10]^DATA_IN[11]^DATA_IN[13]^DATA_IN[15]^DATA_IN[17]
            ^DATA_IN[19]^DATA_IN[21]^DATA_IN[23]^DATA_IN[25];
assign     parity[1] =  DATA_IN[0]^DATA_IN[2]^DATA_IN[3]^DATA_IN[5]^DATA_IN[6]^DATA_IN[9]^DATA_IN[10]^DATA_IN[12]^DATA_IN[13]^DATA_IN[16]^DATA_IN[17]
            ^DATA_IN[20]^DATA_IN[21]^DATA_IN[24]^DATA_IN[25];
assign     parity[2] =  (^DATA_IN[3:1])^(^DATA_IN[10:7])^(^DATA_IN[17:14])^(^DATA_IN[25:22]);
assign     parity[3] = (^DATA_IN[10:4])^(^DATA_IN[25:18]);
assign     parity[4] = (^DATA_IN[25:11]);
assign     parity[5] = (^DATA_IN[25:0])^(^parity[4:0]);
assign     CodeWord = {DATA_IN[25:0],parity[5:0]};
     
endmodule



