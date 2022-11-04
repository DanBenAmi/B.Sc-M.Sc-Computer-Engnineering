//
// Verilog Module Tom_Dan_2_0_lib.ECC_ENC_DEC
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 15:16:39 11/20/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module ecc_enc_dec
#( 
parameter AMBA_WORD = 32, 
parameter AMBA_ADDR_WIDTH = 20,
parameter DATA_WIDTH = 8
)
(
input logic [AMBA_ADDR_WIDTH-1:0]PADDR,
input logic PENABLE,
input logic PSEL,
input logic [AMBA_WORD-1:0]PWDATA,
input logic PWRITE,
input logic clk,
input logic arstn,
output logic [AMBA_WORD-1:0]PRDATA,
output logic [DATA_WIDTH-1:0]data_out,
output logic operation_done,
output logic [1:0]num_of_errors
);

logic    [1:0]Rd_Wr_Id;            //from apb to register file
logic    FC_or_Dec;    //mux sel, full channel-0, decode=1
logic    En_or_Dec;    //mux sel, encode=0, decode=1
logic    rst;
logic    [AMBA_WORD - 1:0]AMBA_WORD_registers [1:0]; //0-data in, 1-noise
logic    [1:0] two_bits_registers [1:0]; //0-ctrl, 1-codeword_with
logic    [DATA_WIDTH - 1:0] CodeWord;
logic    [DATA_WIDTH - 1:0] noisy_codeword_fc;
logic    [DATA_WIDTH - 1:0] noisy_codeword_in_dec;
logic [DATA_WIDTH - 1:0] Decoded_Data;

assign rst = ~arstn;

apb  U_apb(
   .pwrite   (PWRITE),
   .psel     (PSEL),
   .penable  (PENABLE),
   .Rd_Wr_Id (Rd_Wr_Id)
);

register_file #(.AMBA_WORD(AMBA_WORD)) U_register_file(
   .clk         (clk),
   .rst         (rst),
   .Rd_Wr_Id    (Rd_Wr_Id),
   .offset      (PADDR[5:2]),
   .data_to_reg (PWDATA),
   .data_out     (PRDATA),
   .AMBA_WORD_registers   (AMBA_WORD_registers),
   .two_bits_registers    (two_bits_registers)
);

control_unit U_control_unit(
   .CTRL           (two_bits_registers[0]),
   .FC_or_Dec      (FC_or_Dec),
   .En_or_Dec      (En_or_Dec)
);

encoder #(.DATA_WIDTH(DATA_WIDTH)) U_encoder(
   .DATA_IN        (AMBA_WORD_registers[0][DATA_WIDTH - 1:0]),
   .Codeword_Width (two_bits_registers[1]),
   .CodeWord      (CodeWord)
);

noise_adder #(.DATA_WIDTH(DATA_WIDTH)) U_noise_adder(
   .noise          (AMBA_WORD_registers[1][DATA_WIDTH - 1:0]),
   .Encoded_data   (CodeWord),
   .noisy_codeword (noisy_codeword_fc)
);

decoder #(.DATA_WIDTH(DATA_WIDTH)) U_decoder(
   .NoisyCodeWord  (noisy_codeword_in_dec),
   .Codeword_Width (two_bits_registers[1]),
   .Decoded_Data   (Decoded_Data),
   .NumOfErrors    (num_of_errors)
);


op_done_logic U_op_done_logic(
   .clk            (clk),
   .rst            (rst),
   .Rd_Wr_Id       (Rd_Wr_Id),
   .operation_done (operation_done)
);

always @*
begin: FC_or_Dec_mux
  if(FC_or_Dec==0)
    noisy_codeword_in_dec = noisy_codeword_fc;
  else
    noisy_codeword_in_dec = AMBA_WORD_registers[0][DATA_WIDTH - 1:0];
end

always @(CodeWord or En_or_Dec or Decoded_Data)
begin: En_or_Dec_mux
  if(En_or_Dec==0)
    data_out = CodeWord;
  else
    data_out = Decoded_Data;
end

endmodule
