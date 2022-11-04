//
// Verilog Module Tom_Dan_2_0_lib.Stimulus
//
// Created:
//          by - kessoust.UNKNOWN (L330W513)
//          at - 16:44:02 12/10/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module Stimulus #(
  parameter AMBA_WORD = 32,
  parameter AMBA_ADDR_WIDTH = 20,
  parameter DATA_WIDTH = 32
)
(
   // Port Declarations
   Interface.stimulus stim_bus,
   input logic clk,
  output logic tst_rst
);

`define NULL 0
`define Info_bits 4
`define CodeWord_bits 8
`define CTRL_addr 0
`define DATA_addr 4
`define CodeWord_Width_addr 8
`define Noise_addr 12

integer golden_model;
integer noise_file;
integer Data_in;
integer noise;
integer operation;
integer reg_addr;
integer bits;
integer val;
string  base_path = "D:/Users/danbenam/Desktop/Tom_Dan_2.0/Tom_Dan_2_0_lib/hdl/verification_files/golden_model_inputs_";
string  noise_path = "D:/Users/danbenam/Desktop/Tom_Dan_2.0/Tom_Dan_2_0_lib/hdl/verification_files/noise_";
string  mode;
string  bits_num;

logic [AMBA_ADDR_WIDTH-1:0]PADDR;
logic [AMBA_WORD-1:0]PWDATA;
logic R_W;


assign stim_bus.operation = operation;
assign stim_bus.val = val;

initial 
begin : stim_proc
  
  for(operation=0;operation<3;operation=operation+1) begin
    for(bits=0;bits<3;bits=bits+1) begin
    // Initilization
    #2;
    tst_rst = 0;
    @(posedge clk); // wait til next rising edge (in other words, wait 20ns)
    #2
    tst_rst = 1;
    
    mode.itoa(operation);
    bits_num.itoa(bits);
    if(operation == 2)    //Full channel
      begin
        noise_file = $fopen($sformatf({noise_path, bits_num, ".txt"}), "r"); // opening file in reading format
        if (noise_file == `NULL)
          begin 
          $display("noise handle was NULL");
          $finish;
          end
      end
    golden_model = $fopen($sformatf({base_path, mode,bits_num, ".txt"}), "r"); // opening file in reading format
    if (golden_model == `NULL)
      begin 
      $display("golden_model handle was NULL");
      $finish;
      end
   
    @(posedge clk); // wait til next rising edge (in other words, wait 20ns)
    
    APB_protocol(`CodeWord_Width_addr,bits,1);        //CodeWord Width=32
    #2;
    //// Reading First Line of each file
    while(!$feof(golden_model))
      begin
        $fscanf(golden_model, "%b\n", Data_in);
        if(operation == 2)
        begin
          $fscanf(noise_file, "%b\n", noise);
          APB_protocol(`Noise_addr,noise,1);
          #2;
        end
        APB_protocol(`DATA_addr,Data_in,1);
        #2;
        APB_protocol(`CTRL_addr,operation,1);     //Encode operation    
      end
    $fclose(golden_model);
    if(operation == 2) $fclose(noise_file);
    end
  end
  
   //Checking read data from 2-bits registers (CTRL,CodeWordWidth).
  for(reg_addr=0;reg_addr<13;reg_addr=reg_addr+4) begin
    if((reg_addr == 0) || (reg_addr == 8))
    begin
      for(val=0;val<3;val=val+1) begin
      APB_protocol(reg_addr,val,1);
      #2;
      APB_protocol(reg_addr,val,0);
      #2;
      end
    end
    else
    begin
      for(val=0;val<1000;val=val+1) begin
      APB_protocol(reg_addr,val*56456,1);
      #2;
      APB_protocol(reg_addr,val*56456,0);
      #2;
      end
    end
  end
  #100;
  $finish;
end



task APB_protocol(input [AMBA_ADDR_WIDTH-1:0]PADDR, [AMBA_WORD-1:0]PWDATA,R_W);
  begin
  @(posedge clk) begin 
   stim_bus.PADDR <= PADDR; 
   stim_bus.PWDATA <= PWDATA;        
   stim_bus.PSEL <= 1; 
   stim_bus.PWRITE <= R_W;
 end
  #2;
  @(posedge clk) begin
    stim_bus.PENABLE <= 1;         
  end 
  #2;
  @(posedge clk) begin
    stim_bus.PENABLE <= 0;
    stim_bus.PSEL <= 0;
    stim_bus.PWRITE <= 0;
  end
  end
endtask

endmodule
