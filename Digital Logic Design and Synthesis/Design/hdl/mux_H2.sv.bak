//
// Verilog Module Tom_Dan_2_0_lib.mux_H2
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 16:13:44 11/19/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps           //case codeword width=16 
module mux_H2 
//recieve s (=Hy'), check if the s is equal to a specific column 
//of H and if num of errors<=1 then returning the decoded data (i.e. the  
//codeword with the flip bit in the column index position) and returning the number  
//of errors, else rturning zeros and num of errors = 2
(
input  logic [10:0] NoisyCodeWord,
input logic [4:0] column,
output logic  [10:0] Decoded_Data,
output logic [1:0] NumOfErrors
);



always @ (column or NoisyCodeWord)
begin : MUX_H2                              //mux 2^5 to 1
  case(column)          
    5'b11111: begin
    Decoded_Data = NoisyCodeWord^(11'h400);
    NumOfErrors = 2'b1; 
    end
    5'b11110: begin
    Decoded_Data = NoisyCodeWord^(11'h200);
    NumOfErrors = 2'b1; 
    end
    5'b11101: begin
    Decoded_Data = NoisyCodeWord^(11'h100);
    NumOfErrors = 2'b1; 
    end
    5'b11100: begin
    Decoded_Data = NoisyCodeWord^(11'h080);
    NumOfErrors = 2'b1; 
    end
    5'b11011: begin
    Decoded_Data = NoisyCodeWord^(11'h040);
    NumOfErrors = 2'b1; 
    end
    5'b11010: begin
    Decoded_Data = NoisyCodeWord^(11'h020);
    NumOfErrors = 2'b1; 
    end
    5'b11001: begin
    Decoded_Data = NoisyCodeWord^(11'h010);
    NumOfErrors = 2'b1; 
    end
    5'b10111: begin
    Decoded_Data = NoisyCodeWord^(11'h008);
    NumOfErrors = 2'b1; 
    end
    5'b10110: begin
    Decoded_Data = NoisyCodeWord^(11'h004);
    NumOfErrors = 2'b1; 
    end
    5'b10101: begin
    Decoded_Data = NoisyCodeWord^(11'h002);
    NumOfErrors = 2'b1; 
    end
    5'b10011: begin
    Decoded_Data = NoisyCodeWord^(11'h001);
    NumOfErrors = 2'b1; 
    end
    5'b10000: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    5'b11000: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    5'b10100: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    5'b10010: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    5'b10001: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    5'b0 : begin
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
