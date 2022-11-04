//
// Verilog Module Tom_Dan_2_0_lib.register_file
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 16:28:41 11/18/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module register_file              // register file of the entire system, unclude 4 registers as described below
#( 
parameter AMBA_WORD = 32
)
(
input logic clk,
input logic rst,
input logic [1:0] Rd_Wr_Id,
input logic [3:0] offset,
input logic [AMBA_WORD-1:0] data_to_reg,
output logic [AMBA_WORD-1:0] data_out,
output logic    [AMBA_WORD - 1:0]AMBA_WORD_registers [1:0], //0-data in, 1-noise
output logic    [1:0] two_bits_registers [1:0] //0-ctrl, 1-codeword_with
) ;


always @(posedge clk or posedge rst)      //write operation, write the "data in" from the register of the offset addres
begin: write_op
  if (rst)                // reseting all the registers
  begin
     AMBA_WORD_registers[0] <= {AMBA_WORD{1'b0}};
     AMBA_WORD_registers[1] <= {AMBA_WORD{1'b0}};
     two_bits_registers[0] <= {2{1'b0}};
     two_bits_registers[1] <= {2{1'b0}};
   end
  else if (Rd_Wr_Id==1) begin
    case(offset[3:0])
     4'h0:  two_bits_registers[0] <= data_to_reg[1:0];
     4'h1: AMBA_WORD_registers[0] <= data_to_reg;
     4'h2:  two_bits_registers[1] <= data_to_reg[1:0];
     default: AMBA_WORD_registers[1] <= data_to_reg;
   endcase
  end
end
 
 always @*                //read operation, read the "data in" from the register of the offset addres 
 begin: read_op
 if (Rd_Wr_Id==0) begin
 case(offset[3:0])
     4'h0: data_out = {{(AMBA_WORD-2){1'b0}},two_bits_registers[0]};
     4'h1: data_out = AMBA_WORD_registers[0];
     4'h2: data_out = {{(AMBA_WORD-2){1'b0}},two_bits_registers[1]};
     default: data_out = AMBA_WORD_registers[1];
   endcase
 end
 else data_out = 0;
end 

endmodule
