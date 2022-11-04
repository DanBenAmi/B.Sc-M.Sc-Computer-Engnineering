//
// Verilog interface my_example_lib.Interface
//
// Created:
//          by - user.UNKNOWN (DESKTOP-A337LJE)
//          at - 21:51:33 10/24/2020
//
// using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
//

`resetall
`timescale 1ns/10ps
interface Interface #(
  parameter AMBA_WORD = 32,
  parameter AMBA_ADDR_WIDTH = 20,
  parameter DATA_WIDTH = 32)(
  input logic clk,
  input logic arstn
  );
  
//signals declaration

logic [AMBA_ADDR_WIDTH-1:0]PADDR;
logic PENABLE;
logic PSEL;
logic [AMBA_WORD-1:0]PWDATA;
logic PWRITE;
logic [AMBA_WORD-1:0]PRDATA;
logic [DATA_WIDTH-1:0]data_out;
logic operation_done;
logic [1:0]num_of_errors;
integer operation;
integer val; 


//modports declaration
modport stimulus (output PADDR, PENABLE, PSEL, PWDATA, PWRITE,operation,val);
modport checker_coverager (input PADDR, PENABLE,PSEL,PWDATA,PWRITE,PRDATA,data_out,operation_done,num_of_errors,operation);
modport Compare (input operation_done,PRDATA, num_of_errors, data_out, arstn,PENABLE,PWRITE,val);

endinterface

