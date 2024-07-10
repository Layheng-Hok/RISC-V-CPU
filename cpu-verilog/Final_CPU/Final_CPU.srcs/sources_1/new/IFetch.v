`timescale 1ns / 1ps

module IFetch(
    input clk,
    input rst,
    input [31:0] imm32,
    input jump,
    input jalr,
    input beq,
    input bne,
    input blt, 
    input bltu, 
    input bge,
    input bgeu,
    input zero,
    input [31:0] ALUResult,
    output reg [31:0] ra,
    output wire [31:0] inst
    );

    reg [31:0] pc = 32'h00000000;
    reg [31:0] npc;
    wire [13:0] addra;

    prgrom urom(.clka(clk), .addra(addra), .douta(inst));  
    assign addra = pc[15:2];

    // Determine the next PC value based on the control signals
    always @(*) begin
        if ((beq && zero) || (bne && ~zero) || (blt && ALUResult[31] == 1'b1) ||
            (bge && ALUResult[31] == 1'b0) || (bltu && ALUResult[31] == 1'b1) ||
            (bgeu && ALUResult[31] == 1'b0)) begin
            npc = pc + imm32;
        end else if (jump) begin // jal
            npc = pc + imm32;
        end else if (jalr) begin // jalr
            npc = ALUResult;
        end else begin
            npc = pc + 4;
        end
    end
    
    always @(posedge clk) begin
        ra = pc + 4;
        end

    // Update the PC and ra registers
    always @(negedge clk or negedge rst) begin
        if (~rst) begin
            pc <= 32'h00000000;
        end else begin
            pc <= npc;
        end
    end

endmodule
