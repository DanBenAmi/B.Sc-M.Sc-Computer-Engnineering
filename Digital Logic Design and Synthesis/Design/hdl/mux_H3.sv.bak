//
// Verilog Module Tom_Dan_2_0_lib.mux_H3
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 16:24:54 11/19/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps           //case codeword width=32 
module mux_H3 
//recieve s (=Hy'), check if the s is equal to a specific column 
//of H and if num of errors<=1 then returning the decoded data (i.e. the  
//codeword with the flip bit in the column index position) and returning the number  
//of errors, else rturning zeros and num of errors = 2
(
input  logic [25:0] NoisyCodeWord,
input logic [5:0] column,
output logic  [25:0] Decoded_Data,
output logic [1:0] NumOfErrors
);



always @ (column or NoisyCodeWord)
begin : MUX_H3                      //mux 2^6 to 1
  case(column) 
    6'b111111: begin
    Decoded_Data = NoisyCodeWord^(26'h2000000);
    NumOfErrors = 2'b1; 
    end
    6'b111110: begin
    Decoded_Data = NoisyCodeWord^(26'h1000000);
    NumOfErrors = 2'b1; 
    end
    6'b111101: begin
    Decoded_Data = NoisyCodeWord^(26'h0800000);
    NumOfErrors = 2'b1; 
    end
    6'b111100: begin
    Decoded_Data = NoisyCodeWord^(26'h0400000);
    NumOfErrors = 2'b1; 
    end
    6'b111011: begin
    Decoded_Data = NoisyCodeWord^(26'h0200000);
    NumOfErrors = 2'b1; 
    end
    6'b111010: begin
    Decoded_Data = NoisyCodeWord^(26'h0100000);
    NumOfErrors = 2'b1; 
    end
    6'b111001: begin
    Decoded_Data = NoisyCodeWord^(26'h0080000);
    NumOfErrors = 2'b1; 
    end
    6'b111000: begin
    Decoded_Data = NoisyCodeWord^(26'h0040000);
    NumOfErrors = 2'b1; 
    end
    6'b110111: begin
    Decoded_Data = NoisyCodeWord^(26'h0020000);
    NumOfErrors = 2'b1; 
    end
    6'b110110: begin
    Decoded_Data = NoisyCodeWord^(26'h0010000);
    NumOfErrors = 2'b1; 
    end
    6'b110101: begin
    Decoded_Data = NoisyCodeWord^(26'h0008000);
    NumOfErrors = 2'b1; 
    end
    6'b110100: begin
    Decoded_Data = NoisyCodeWord^(26'h0004000);
    NumOfErrors = 2'b1; 
    end
    6'b110011: begin
    Decoded_Data = NoisyCodeWord^(26'h0002000);
    NumOfErrors = 2'b1; 
    end
    6'b110010: begin
    Decoded_Data = NoisyCodeWord^(26'h0001000);
    NumOfErrors = 2'b1; 
    end
    6'b110001: begin
    Decoded_Data = NoisyCodeWord^(26'h0000800);
    NumOfErrors = 2'b1; 
    end
    6'b101111: begin
    Decoded_Data = NoisyCodeWord^(26'h0000400);
    NumOfErrors = 2'b1; 
    end
    6'b101110: begin
    Decoded_Data = NoisyCodeWord^(26'h0000200);
    NumOfErrors = 2'b1; 
    end
    6'b101101: begin
    Decoded_Data = NoisyCodeWord^(26'h0000100);
    NumOfErrors = 2'b1; 
    end
    6'b101100: begin
    Decoded_Data = NoisyCodeWord^(26'h0000080);
    NumOfErrors = 2'b1; 
    end
    6'b101011: begin
    Decoded_Data = NoisyCodeWord^(26'h0000040);
    NumOfErrors = 2'b1; 
    end
    6'b101010: begin
    Decoded_Data = NoisyCodeWord^(26'h0000020);
    NumOfErrors = 2'b1; 
    end
    6'b101001: begin
    Decoded_Data = NoisyCodeWord^(26'h0000010);
    NumOfErrors = 2'b1; 
    end
    6'b100111: begin
    Decoded_Data = NoisyCodeWord^(26'h0000008);
    NumOfErrors = 2'b1; 
    end
    6'b100110: begin
    Decoded_Data = NoisyCodeWord^(26'h0000004);
    NumOfErrors = 2'b1; 
    end
    6'b100101: begin
    Decoded_Data = NoisyCodeWord^(26'h0000002);
    NumOfErrors = 2'b1; 
    end
    6'b100011: begin
    Decoded_Data = NoisyCodeWord^(26'h0000001);
    NumOfErrors = 2'b1; 
    end
    6'b100000: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    6'b110000: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    6'b101000: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    6'b100100: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    6'b100010: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    6'b100001: begin
    Decoded_Data = NoisyCodeWord;
    NumOfErrors = 2'b1; 
    end
    6'b0: begin
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