`timescale 1ns / 1ps

module DataMem(
    input clk, 
    input mem_read, mem_write,
    input [31:0] addr, 
    input [31:0] din, 
    output [31:0] dout 
    );
    
    RAM udram(.clka(~clk), .wea(mem_write), .addra(addr[15:2]), .dina(din), .douta(dout));

endmodule