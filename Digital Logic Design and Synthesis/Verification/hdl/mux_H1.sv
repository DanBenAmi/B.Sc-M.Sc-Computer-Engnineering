//
// Verilog Module Tom_Dan_2_0_lib.mux_H1
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 15:46:11 11/26/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps            //case codeword width=8
module mux_H1                      
//recieve s (=Hy'), check if the s is equal to a specific column 
//of H and if num of errors<=1 then returning the decoded data (i.e. the  
//codeword with the flip bit in the column index position) and returning the number  
//of errors, else rturning zeros and num of errors = 2
(
input  logic [3:0] NoisyCodeWord,
input logic [3:0] column,
output logic  [3:0] Decoded_Data,
output logic [1:0] NumOfErrors
);



always @ (NoisyCodeWord or column)        //mux 2^4 to 1
begin : MUX_H1
  case(column) 
    4'b1111: begin
    Decoded_Data = NoisyCodeWord^(4'h8);
    NumOfErrors = 2'b1; 
    end
    4'b1110: begin
    Decoded_Data = NoisyCodeWord^(4'h4);
    NumOfErrors = 2'b1; 
    end
    4'b1101: begin
    Decoded_Data = NoisyCodeWord^(4'h2);
    NumOfErrors = 2'b1; 
    end
    4'b1011: begin
    Decoded_Data = NoisyCodeWord^(4'h1);
    NumOfErrors = 2'b1; 
    end
    4'b1000: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    4'b1100: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    4'b1010: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    4'b1001: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    4'b0 : begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b0; 
    end
    default : begin
    Decoded_Data = 0;
    NumOfErrors = 2'b10; 
    end
 endcase 
end
endmodule
