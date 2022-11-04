//
// Verilog Module Tom_Dan_2_0_lib.tb_overall
//
// Created:
//          by - kessoust.UNKNOWN (L330W513)
//          at - 18:56:53 12/10/2021
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

//the input to the system is arstn which is zero iff rst is 1 or tst_rst(output from the stimulus) is 0. that is because
// we would like to check the arstn in syncronous time of our stimulus output signals. 

`resetall
`timescale 1ns/10ps
module tb_overall#(
  parameter DATA_WIDTH = 32,
  parameter AMBA_ADDR_WIDTH= 32,
  parameter AMBA_WORD = 32 
)();

logic rst = 0;

logic tst_rst;
logic clk = 1;
logic arstn;

always begin : clock_generator_proc
  #1 clk = ~clk;
end

assign arstn = tst_rst && (!rst);

Interface #() tb(
    .clk(clk),
    .arstn(arstn)
);


Stimulus gen(
    .stim_bus(tb),
    .clk(clk),
    .tst_rst(tst_rst)
);
ecc_enc_dec#(.AMBA_WORD(AMBA_WORD),.AMBA_ADDR_WIDTH(AMBA_ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH)) dut(
    .PADDR(tb.PADDR),
    .PENABLE(tb.PENABLE),
    .PSEL(tb.PSEL),
    .PWDATA(tb.PWDATA),
    .PWRITE (tb.PWRITE),
    .clk(tb.clk),
    .arstn(tb.arstn),
    .PRDATA(tb.PRDATA),
    .data_out(tb.data_out),
    .operation_done(tb.operation_done),
    .num_of_errors(tb.num_of_errors)
    );

Compare res_test(
    .Compare(tb)
    );

Coverage cov(
    .coverage_bus(tb),
    .clk(clk),
    .arstn(arstn)
    );

Checker chec(
  .checker_bus(tb),
    .clk(clk),
    .arstn(arstn)
  );

endmodule
