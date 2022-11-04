//
// Verilog Module Tom_Dan_2_0_lib.control_unit
//
// Created:
//          by - danbenam.UNKNOWN (L330W513)
//          at - 14:53:59 11/20/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module control_unit               //module for control the output with respect to the ctrl reg
(
input logic [1:0]CTRL,
output logic FC_or_Dec,   // 0 = Full channel,    1 = Decode
output logic En_or_Dec    // 0 = encode,    1 = Decode
);
always @ (CTRL)
begin : operations_mux
  if(CTRL==0)         //Encode
  begin
    FC_or_Dec = 0;
    En_or_Dec = 0;
  end
  else if (CTRL==1)   //Decode
  begin
    FC_or_Dec = 1;
    En_or_Dec = 1;
  end
  else                //Full channel
  begin
    FC_or_Dec = 0;
    En_or_Dec = 1;
  end 
end

endmodule
