//
// Verilog Module Tom_Dan_2_0_lib.Coverage
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 19:23:13 12/12/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module Coverage #(
  parameter AMBA_WORD = 32,
  parameter AMBA_ADDR_WIDTH = 20,
  parameter DATA_WIDTH = 32
)
(
   // Port Declarations
   Interface.checker_coverager coverage_bus,
   input logic clk,
  input logic arstn
);

covergroup reset @ (arstn);
				// checking if the reset signal went to all the ranges
				reset : coverpoint arstn{
         bins low = {0};
         bins high = {1};
          }
endgroup


// Coverage Group
covergroup regular_test @ (posedge clk);
        // checking if the enable signal went to all the ranges
        enable : coverpoint coverage_bus.PENABLE{
         bins low = {0};
         bins high = {1};
          }
         // checking if the operation done signal went to all the ranges
        operation_done : coverpoint coverage_bus.operation_done{
         bins low = {0};
         bins high = {1};
          }
 
endgroup 




// Coverage Group
covergroup results @ (posedge coverage_bus.operation_done);
   // checking if the parameter went to all the ranges
        data_out : coverpoint coverage_bus.data_out{
         bins four = {[0:15]};
         bins eight = {[16:(2**8-1)]};
         bins eleven = {[(2**8):(2**11-1)]};
         bins sixteen = {[(2**11):(2**16-1)]};
         bins twenty_six = {[(2**16):(2**26-1)]};
         bins thirty_two = {[(2**26):(2**32-1)]};
          }
        
        num_of_errors : coverpoint coverage_bus.num_of_errors
          iff ((coverage_bus.operation == 2) ||(coverage_bus.operation == 1)){
         bins zero = {0};
         bins one = {1};
         bins two= {2};
         bins three_ot_more = default;
       }


endgroup


covergroup data_in @ (negedge coverage_bus.PSEL && coverage_bus.PADDR == 4);
   //check data in signals      
        data_in: coverpoint coverage_bus.PWDATA{
         bins four = {[0:15]};
         bins eight = {[16:(2**8-1)]};
         bins eleven = {[(2**8):(2**11-1)]};
         bins sixteen = {[(2**11):(2**16-1)]};
         bins twenty_six = {[(2**16):(2**26-1)]};
         bins thirty_two = {[(2**26):(2**32-1)]};
          }
endgroup

covergroup adress @ (coverage_bus.PADDR);
   //check adress signals      
        addres: coverpoint coverage_bus.PADDR{
         bins ctrl = {0};
         bins data_in = {4};
         bins codeword_width = {8};
         bins noise = {12};
         bins wrong_address = default;
          }
endgroup

covergroup ctrl @ (negedge coverage_bus.PSEL && coverage_bus.PADDR == 0);
   //check adress signals      
        ctrl: coverpoint coverage_bus.PWDATA{
         bins zero = {0};
         bins one = {1};
         bins two = {2};
         bins three = {3};
          }
endgroup

covergroup codeword_width @ (posedge clk && coverage_bus.PADDR == 8);
   //check adress signals      
        codeword_width: coverpoint coverage_bus.PWDATA{
         bins zero = {0};
         bins one = {1};
         bins two = {2};
         bins three = {3};
          }
endgroup

// Instance of covergroup regular_test
regular_test tst = new();
results ress = new();
data_in data_in_1 = new();
adress adress_1 = new();
ctrl ctrl_1 = new();
codeword_width codeword_width_1 = new();
reset reset_1 = new();

endmodule
