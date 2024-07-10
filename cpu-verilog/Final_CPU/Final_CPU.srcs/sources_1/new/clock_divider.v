`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 17:40:03
// Design Name: 
// Module Name: clock1
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


module clock_divider(
input wire clk,rst,
output reg clk_1
    );
    //this is a clock divider
    //which output a clk with 2.5s period
    
    reg [31:0] div_cnt;
parameter TIME_03S = 1500_000_00;
//parameter TIME_03S = 5000; // for simulation
    
    initial begin
    clk_1 = 1'b0;
    div_cnt = 0;
    end
    
    always @(posedge clk, negedge rst) begin
        if(~rst)
            div_cnt <= 0;
        else if(div_cnt == TIME_03S) 
            div_cnt <= 0;
        else 
            div_cnt <= div_cnt + 1;
    end

    always @(posedge clk, negedge rst) begin
        if(~rst)
            clk_1 <= 0;
        else if( div_cnt == (TIME_03S>>1) -1)
            clk_1 <= 1;
        else if(div_cnt == TIME_03S -1 ) 
            clk_1 <= 0;
    end
    
    
    

endmodule