//
// Verilog Module Tom_Dan_2_0_lib.decoder
//
// Created:
//          by - kessoust.UNKNOWN (L330W513)
//          at - 10:30:52 11/19/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module decoder                      // decoding the codeword and returning decoded data
#( 
parameter DATA_WIDTH = 32
)
(
input  logic [DATA_WIDTH-1:0] NoisyCodeWord,
input  logic [1:0] Codeword_Width,
output logic  [DATA_WIDTH-1:0] Decoded_Data,
output logic [1:0] NumOfErrors
);

logic [5:0] column;
logic [1:0] NumOfErrors1;
logic [1:0] NumOfErrors2;
logic [1:0] NumOfErrors3;
logic  [3:0] Decoded_Data1;
logic  [10:0] Decoded_Data2;
logic  [25:0] Decoded_Data3;
logic  [DATA_WIDTH-1:0] Decoded_Data2_full_length;
logic  [DATA_WIDTH-1:0] Decoded_Data3_full_length;

mat_mult #(.DATA_WIDTH(DATA_WIDTH)) U_0(           //calculates column = s = Hy' (y' = codeword transpose)
   .NoisyCodeWord  (NoisyCodeWord),
   .Codeword_Width (Codeword_Width),
   .column         (column)
);
 
 mux_H1 H_1(            // decoding data for case codeword width = 8 (using H1)
   .NoisyCodeWord  (NoisyCodeWord[7:4]),
   .column         (column[3:0]),
   .Decoded_Data   (Decoded_Data1),
   .NumOfErrors    (NumOfErrors1)
);
generate                                                        //generating different sub-modules with respect to the data width
  if(DATA_WIDTH == 16)begin
    mux_H2 H_2(        // decoding data for case codeword width = 16 (using H2)
       .NoisyCodeWord  (NoisyCodeWord[15:5]),
       .column         (column[4:0]),
       .Decoded_Data   (Decoded_Data2),
       .NumOfErrors    (NumOfErrors2)
    );
    assign Decoded_Data2_full_length = {{(DATA_WIDTH-11){1'b0}},Decoded_Data2};
    assign Decoded_Data3 = 0;
    assign NumOfErrors3 = 0;
  end
  else if(DATA_WIDTH == 32)begin
  mux_H2  H_2(         // decoding data for case codeword width = 16 (using H2)
       .NoisyCodeWord  (NoisyCodeWord[15:5]),
       .column         (column[4:0]),
       .Decoded_Data   (Decoded_Data2),
       .NumOfErrors    (NumOfErrors2)
    );
 mux_H3  H_3(          // decoding data for case codeword width = 32 (using H3)
   .NoisyCodeWord  (NoisyCodeWord[31:6]),
   .column         (column[5:0]),
   .Decoded_Data   (Decoded_Data3),
   .NumOfErrors    (NumOfErrors3)
    );
    assign Decoded_Data2_full_length = {{(DATA_WIDTH-11){1'b0}},Decoded_Data2};
    assign Decoded_Data3_full_length = {{(DATA_WIDTH-26){1'b0}},Decoded_Data3};
  end
  else begin
    assign Decoded_Data2 = 0;
    assign Decoded_Data3 = 0;
    assign NumOfErrors2 = 0;
    assign NumOfErrors3 = 0;
  end
endgenerate

always @*
begin : MUX                                 //mux 2^2 to 1 dpending on codeword width
  if(Codeword_Width==0)
  begin : H1
   Decoded_Data = {{(DATA_WIDTH-4){1'b0}},Decoded_Data1};
   NumOfErrors = NumOfErrors1;
  end
  
  else if(Codeword_Width==1)
  begin : H2
   Decoded_Data =Decoded_Data2_full_length;
   NumOfErrors = NumOfErrors2;
  end
  
  else
  begin : H3
   Decoded_Data = Decoded_Data3_full_length;
   NumOfErrors = NumOfErrors3;
  end
end

endmodule
