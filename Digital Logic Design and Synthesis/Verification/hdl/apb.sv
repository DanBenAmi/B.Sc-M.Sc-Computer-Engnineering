//
// Verilog Module Tom_Dan_2_0_lib.apb
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 12:10:11 11/20/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module apb                 //communication through the apb protocol

(
 // APB
 input logic           pwrite,
 input logic            psel,
 input logic           penable,
 output logic         [1:0]Rd_Wr_Id       // output: 0=read , 1=write , 2=Idle
);

logic apb_write;
logic apb_read;

 /*
 ============== verify master protocol =======================
input logic           clk,
              
logic counter = 1'b0;

assign apb_write = psel && pwrite;
assign apb_read  = psel && ~pwrite;
   
 always @(posedge clk)
 begin
    if (apb_write)
    begin
      if(penable & counter) begin
        Rd_Wr_Id = 2'b01;
        counter = 0;
      end
      else
       counter = 1;
    end
    
    else if (apb_read)
      begin
      if (penable & counter) begin
        Rd_Wr_Id = 2'b00;
        counter = 0;
      end
      else
       counter = 1;
    end 
    else 
    begin
      counter = 0;
      Rd_Wr_Id = 2'b10;
    end
 end // always 
 
  */  
// ============== Trust master protocol =======================

   
assign apb_write = psel && pwrite && penable ;
assign apb_read  = psel && (~pwrite) && penable;
   
 always @(apb_write or apb_read)
 begin: apb_op
    if (apb_write) begin
      Rd_Wr_Id = 2'b01;
    end // if
    else if (apb_read)
        Rd_Wr_Id = 2'b00;
    else
      Rd_Wr_Id = 2'b10;
 end // always 
  
   
   
   
   
endmodule
