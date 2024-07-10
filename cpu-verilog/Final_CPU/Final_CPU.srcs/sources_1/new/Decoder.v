`timescale 1ns / 1ps

module Decoder(
    input clk,
    input rst,
    input[31:0] ALU_result,
    input MemOrIOtoReg,
    input regWrite,
    input [31:0] inst,
    input [31:0] ra,
    input jump,
    input [31:0] IOData,
    output [31:0] rs1Data,
    output [31:0] rs2Data,
    output reg [31:0] imm32
    );

    reg [31:0] registers [0:31];
    wire [4:0] writeReg;
    reg [31:0] writeData;
    integer i;
    assign writeReg = inst[11:7];
    assign rs1Data = (inst[6:0] == 7'b0110111) ? 32'b0 : registers[inst[19:15]];
    assign rs2Data = registers[inst[24:20]];
    
    always @* begin
        if(MemOrIOtoReg == 1'b1) writeData = IOData;
        else if(jump) writeData = ra;
        else writeData = ALU_result;
    end

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;
            end
        end
        else begin
            if (regWrite && writeReg != 5'b0) begin
                    registers[writeReg] <= writeData;
            end
        end
    end

    always @(*) begin
        case(inst[6:0])
            7'b0000011: imm32 = { {20{inst[31]}}, inst[31:20] }; // I type (load)
            7'b0010011: imm32 = inst[14:12] == 3'b100 ? 32'hffffffff : { {20{inst[31]}}, inst[31:20] }; // check if xori, I type (arithmetic, e.g. addi)
            7'b1100111: imm32 = { {20{inst[31]}}, inst[31:20] }; // I type (jalr)
            7'b0100011: imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // S type (store)
            7'b1100011: imm32 = { {19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 }; // B type 
            7'b1101111: imm32 = { {19{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0 }; // J type
            7'b0110111: imm32 = {inst[31:12], 12'b0}; // U type (lui)
            7'b0010111: imm32 = {inst[31:12], 12'b0}; // U type (auipc)
            default: imm32 = 32'b0;
        endcase
    end

endmodule