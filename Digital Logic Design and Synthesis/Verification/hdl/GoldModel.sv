//
// Verilog Module my_example_lib.GoldModel
//
// Created:
//          by - user.UNKNOWN (DESKTOP-A337LJE)
//          at - 12:11:45 11/20/2020
//
// using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
//

`resetall
`timescale 1ns/10ps
module GoldModel #(
  parameter AMBA_WORD = 32,
  parameter AMBA_ADDR_WIDTH = 20,
  parameter DATA_WIDTH = 32
)
(
   // Port Declarations
   Interface.golden goldenmodel
);

`define NULL 0
`define Encode 0
`define Decode 1
`define FullChannel 2

// Data Types

integer results;
integer report;
integer hit = 0;
integer miss = 0;
integer num_of_errors;
integer operation = 0;
integer bits = 0;


string results_path = "D:/Users/danbenam/Desktop/Tom_Dan_2.0/Tom_Dan_2_0_lib/hdl/verification_files/golden_model_outputs_";
string report_path = "D:/Users/danbenam/Desktop/Tom_Dan_2.0/Tom_Dan_2_0_lib/hdl/verification_files/comparison_report.txt";
string  mode;
string  bits_num;
string op = "Encode ";
string bit_len = "8-bits";

logic [DATA_WIDTH-1:0]GoldRes;

initial
begin : init_proc

    mode.itoa(operation);
    bits_num.itoa(bits);
 
    
    results = $fopen($sformatf({results_path, mode, bits_num, ".txt"}), "r"); // opening file in reading format
    if (results == `NULL) begin // checking if we mangaed to open it
      $display("results handle was NULL");
      $finish;
    end
  
    report = $fopen(report_path, "w"); // opening file in writing format
    if (report == `NULL) begin
      $display("report handle was NULL");
      $finish;
    end
    
    $fwrite(report,$sformatf({op, bit_len,"\n"}));
    $fscanf(results, "%b\n", GoldRes);
    //------------------------------------------------------------------------------------------
    //// Initilization
    hit = 0;
    miss = 0;
end



always @(posedge goldenmodel.operation_done)
begin : res_procs
  #2;
  if(operation == `Encode)
  begin
    if(GoldRes == goldenmodel.data_out)
      begin
        hit = hit+1;
      end
    else
      begin
        $fwrite(report,"Gold result: %b   DUT result: %b\n",GoldRes,goldenmodel.data_out);
        miss = miss + 1;
      end
    if ($feof(results))
      begin
        $fwrite(report,"hits: %d out of %d\n", hit,hit+miss);
        $fwrite(report,"miss: %d out of %d\n",miss,hit+miss);
        //$fclose(report);
        $fclose(results);
        
        bits = bits + 1;
        if(bits == 3)
        begin
          bits = 0;
          operation = operation + 1;
        end
        
        hit = 0;
        miss = 0;
        
        if(operation == 1) op = "Decode ";    
        else if(operation==2) op = "Full Channel ";
        if(bits==0) bit_len = "8-bits";
        else if(bits==1) bit_len = "16-bits";
        else bit_len = "32_bits";
        
        $fwrite(report,$sformatf({op, bit_len,"\n"})); // opening file in reading format
        
        mode.itoa(operation);
        bits_num.itoa(bits);
         
        results = $fopen($sformatf({results_path, mode, bits_num, ".txt"}), "r"); // opening file in reading format
          if (results == `NULL) begin // checking if we mangaed to open it
            $display("results handle was NULL");
            $finish;
          end
        /*  
        report = $fopen($sformatf({report_path, mode, bits_num, ".txt"}), "w"); // opening file in writing format
          if (report == `NULL) begin
            $display("report handle was NULL");
            $finish;
          end 
          */
      end
    if(operation == `Encode) $fscanf(results, "%b\n", GoldRes);
    else $fscanf(results, "%b %d\n", GoldRes,num_of_errors);
  end

  else if(operation == `Decode || operation == `FullChannel)
  begin
    if((GoldRes == goldenmodel.data_out) && (num_of_errors == goldenmodel.num_of_errors)
     ||((num_of_errors==2)&&(goldenmodel.num_of_errors==2)))
    begin
      hit = hit+1;
    end
    else
    begin
      $fwrite(report,"Gold result: %b %d   DUT result: %b %d\n",GoldRes,num_of_errors,goldenmodel.data_out,goldenmodel.num_of_errors);
      miss = miss + 1;
    end
  if ($feof(results))
    begin
      $fwrite(report,"hits: %d out of %d\n", hit,hit+miss);
      $fwrite(report,"miss: %d out of %d\n",miss,hit+miss);
      $fclose(results);
      
      bits = bits + 1;
      if(bits == 3)
      begin
        bits = 0;
        operation = operation + 1;
      end
      
      hit = 0;
      miss = 0;
      
      if(operation == 1) op = "Decode ";    
      else if(operation==2) op = "Full Channel ";
      else op = "Read from CTRL register:";
      if(bits==0) bit_len = "8-bits";
      else if(bits==1) bit_len = "16-bits";
      else bit_len = "32_bits";
      
      if(operation < 3) $fwrite(report,$sformatf({op, bit_len,"\n"})); // opening file in reading format
      else $fwrite(report,$sformatf({op,"\n"})); // opening file in reading format
        
      mode.itoa(operation);
      bits_num.itoa(bits);
      if(operation<3) begin 
      results = $fopen($sformatf({results_path, mode, bits_num, ".txt"}), "r"); // opening file in reading format
        if (results == `NULL) begin // checking if we mangaed to open it
          $display("results handle was NULL");
          $finish;
        end
      /*  
      report = $fopen($sformatf({report_path, mode, bits_num, ".txt"}), "w"); // opening file in writing format
        if (report == `NULL) begin
          $display("report handle was NULL");
          $finish;
        end
        */
      end 
    end
    if(operation == `Encode) $fscanf(results, "%b\n", GoldRes);
    else if(operation<3) $fscanf(results, "%b %d\n", GoldRes,num_of_errors);
  end
end

always @(negedge goldenmodel.PENABLE && goldenmodel.PWRITE==0)
begin: read_registers
  if((operation==3) || (operation==5))      //2-bit registers - (CTRL, CodeWord_Width)
  begin
    if(goldenmodel.PRDATA == goldenmodel.val)
    begin
      hit = hit + 1;
    end
    else
    begin
      miss = miss + 1;
      $fwrite(report,"Gold result: %d   DUT result: %d\n",goldenmodel.val,goldenmodel.PRDATA);
    end
   
    if(goldenmodel.val == 2)
    begin
      #2;
      $fwrite(report,"hits: %d out of %d\n", hit,hit+miss);
      $fwrite(report,"miss: %d out of %d\n",miss,hit+miss);
      operation = operation + 1;
      if(operation==4)$fwrite(report,"Read from DATA register:\n");
      else if(operation==6)$fwrite(report,"Read from Noise register:\n");
      hit = 0;
      miss = 0;
    end
  end
  else if((operation==4) || (operation==6))       //32-bit register - (DATA,NOISE)  
  begin
    if(goldenmodel.PRDATA == goldenmodel.val*56456)
    begin
      hit = hit + 1;
    end
    else
    begin
      miss = miss + 1;
      $fwrite(report,"Gold result: %d   DUT result: %d\n",goldenmodel.val*56456,goldenmodel.PRDATA);
    end
    if(goldenmodel.val == 999)
    begin
      #2;
      $fwrite(report,"hits: %d out of %d\n", hit,hit+miss);
      $fwrite(report,"miss: %d out of %d\n",miss,hit+miss);
    
      operation = operation + 1;
      if(operation==5)$fwrite(report,"Read from CodeWord_Width register:\n");
      else if(operation==7)
      begin
        $fclose(report);
        $finish;
      end
      hit = 0;
      miss = 0;
    end
  end
end

endmodule
