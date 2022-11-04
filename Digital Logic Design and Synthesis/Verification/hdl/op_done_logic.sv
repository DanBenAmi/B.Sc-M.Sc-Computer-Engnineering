//
// Verilog Module Tom_Dan_2_0_lib.op_done_logic
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 19:58:07 11/25/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module op_done_logic        // managing operation done D-FF for signal the 
(                           //user the operation done one cycle after recieving new input
input logic clk,
input logic rst,
input logic [1:0] Rd_Wr_Id,
input logic [1:0]addres,
output logic operation_done
);
logic    op_done_reg;

always @(posedge clk or posedge rst)
begin: DFF_with_comparetor
  if(rst) op_done_reg <= 0;
  else if((Rd_Wr_Id == 1) && (addres == 2'b00)) op_done_reg <= 1;
  else op_done_reg <= 0;
end

assign operation_done = op_done_reg;

endmodule
