//
// Verilog Module Tom_Dan_2_0_lib.Checker
//
// Created:
//          by - danbenam.UNKNOWN (L330W525)
//          at - 18:44:26 12/13/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module Checker  #(
  parameter AMBA_WORD = 32,
  parameter AMBA_ADDR_WIDTH = 20,
  parameter DATA_WIDTH = 32
)
(
   // Port Declarations
   Interface.checker_coverager checker_bus,
   input logic clk,
  input logic arstn
);

//check the timing of the system, i.e. the time from getting the input to transfer the output

property op_done_timing;
				@(posedge clk)  ((checker_bus.PENABLE==1)&&(checker_bus.PWRITE==1)&&(checker_bus.PADDR==0)) |=> (checker_bus.operation_done==1);
      endproperty

assert property(op_done_timing)
  else $error("operation_done timing is not right");
  cover property(op_done_timing);
 			

//check the adress from the cpu
property right_adress;
				@(posedge checker_bus.PENABLE) (checker_bus.PADDR==0) || (checker_bus.PADDR==4)||(checker_bus.PADDR==8) || (checker_bus.PADDR==12);
				endproperty

assert property(right_adress)
  else $error("adress is out of range");
  cover property(right_adress);
 			
 			
//check if reset works properly
property rst_active;
				@(clk) arstn==0 |=> ((checker_bus.data_out == 0) && (checker_bus.num_of_errors == 0));
				endproperty

assert property(rst_active)
  else $error("error with Reset");
  cover property(rst_active);

//check noise
property proper_noise;
				@(checker_bus.PENABLE) ((checker_bus.PENABLE==1)&&(checker_bus.PADDR==12))|-> ($countones(checker_bus.PWRITE)<3);
				endproperty

assert property(proper_noise)
  else $error("to many errors in the noise register");
  cover property(proper_noise);


endmodule
