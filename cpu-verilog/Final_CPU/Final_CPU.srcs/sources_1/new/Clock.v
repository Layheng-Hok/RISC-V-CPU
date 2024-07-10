`timescale 1ns / 1ps

module Clock(
    input clk_in1,  // fpga clk
    input rst,      // fpga rst
    output clk_out1, //single cycle cpu clk
    output clk_out2 // data output clk
    );
    
    cpu_clk clk(
        .clk_in1(clk_in1),
        .clk_out1(clk_out1)
    );
    
    clock_divider clock_divider (
        .clk(clk_in1),
        .rst(rst),
        .clk_1(clk_out2)
    );
    
endmodule
