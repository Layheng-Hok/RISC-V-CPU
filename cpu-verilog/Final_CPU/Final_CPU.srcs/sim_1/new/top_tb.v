`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/29 16:15:43
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb();
parameter CLK_PERIOD = 10; // Clock period in ns

    // Inputs
    reg fpga_rst;
    reg fpga_clk;
    reg [15:0] switch;
    reg [3:0] button;
    wire [15:0] led;
    wire [7:0] tube_sel;
    wire [7:0] tube0;
    wire [7:0] tube1;
    // Instantiate the unit under test (UUT)
    CPU dut (
        .fpga_rst(fpga_rst),
        .fpga_clk(fpga_clk),
        .switch(switch),
        .button(button),
        .led(led),
        .tube_sel(tube_sel),
        .tube0(tube0),
        .tube1(tube1)
    );

    // Clock generation
    always #10 fpga_clk = ~fpga_clk;

    // Initial stimulus
    initial begin
        // Initialize inputs
        fpga_clk = 1'b1;
        fpga_rst = 1'b0;
        switch = 16'b0;
        button = 2'b0;
        #10
        fpga_rst = 1'b1;
    end
    
    initial fork
    #5700 button = 4'b0100; //rm lights
    #6000 switch = 16'h0700; //tc 6
    #6350 button = 4'b1000; //confirm tc
    #8200 switch = 16'b0000_1010_0000_0000;
    #8300 button = 4'b0001;
//    #8350 switch = 16'b0111101100000000;
//    #8400 button = 4'b0010;
//    #6850 switch = 16'hb300; // lbu
//    #7550 button = 4'b0001; //input a
    
//    #8000 button = 4'b0100;
//    #8200 switch = 16'h0200; //tc 1
//    #8550 button = 4'b1000; //confirm tc
//    #8850 switch = 16'hb200; // lb
//    #9150 button = 4'b0001; //input a
//    #9700 button = 4'b0100;
    
//    #1000 button = 4'b0100;
//    #10100 switch = 16'h0300; //tc 3
//    #10350 button = 4'b1000; //confirm tc
    join

endmodule