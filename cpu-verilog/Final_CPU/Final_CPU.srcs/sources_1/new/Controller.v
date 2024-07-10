`timescale 1ns / 1ps

module Controller(
    input [31:0] inst,
    input[21:0] ALU_result_high,
    output wire Jump,
    output wire jalr,
    output wire beq,
    output wire blt,
    output wire bge,
    output wire bltu,
    output wire bgeu,
    output wire MemRead,
    output reg [1:0] ALUOp,
    output wire MemWrite,
    output reg ALUSrc,
    output wire RegWrite,
    output wire MemOrIOtoReg,
    output wire IOReadUnsigned,
    output wire IOReadSigned,
    output wire IOWrite,
    output wire bne
    );

    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire RFormat, IFormat_arith, lw, sw, lui, lb, lbu;

    assign RFormat = (opcode == 7'b0110011) ? 1'b1 : 1'b0;
    assign IFormat_arith = (opcode == 7'b001_0011) ? 1'b1 : 1'b0;
    assign lw = (opcode == 7'b0000011 && funct3 == 3'b010) ? 1'b1 : 1'b0;   
    assign sw = (opcode == 7'b0100011 && funct3 == 3'b010) ? 1'b1 : 1'b0;
    assign lui = (opcode == 7'b0110111) ? 1'b1 : 1'b0;
    assign lb = (opcode == 7'b0000011 && funct3 == 3'b000) ? 1'b1 : 1'b0;
    assign lbu = (opcode == 7'b0000011 && funct3 == 3'b100) ? 1'b1 : 1'b0;
    
    assign Jump = (opcode == 7'b1101111) ? 1'b1 : 1'b0; // jal 
    assign jalr = (opcode == 7'b1100111 && funct3 == 3'b000) ? 1'b1 : 1'b0; // jalr
    assign beq = (opcode == 7'b1100011 && funct3 == 3'b000) ? 1'b1 : 1'b0; //beq
    assign bne = (opcode == 7'b1100011 && funct3 == 3'b001) ? 1'b1 : 1'b0; //inst is bne, then result is 1
    assign blt = (opcode == 7'b1100011 && funct3 == 3'b100) ? 1'b1 : 1'b0; //blt
    assign bge = (opcode == 7'b1100011 && funct3 == 3'b101) ? 1'b1 : 1'b0; //bge
    assign bltu = (opcode == 7'b1100011 && funct3 == 3'b110) ? 1'b1 : 1'b0; //bltu
    assign bgeu = (opcode == 7'b1100011 && funct3 == 3'b111) ? 1'b1 : 1'b0; //bgeu
    
    assign RegWrite = (RFormat || IFormat_arith || lw || lui || lb || lbu || Jump) ? 1'b1 : 1'b0;
    assign MemWrite = (sw == 1'b1/* && (ALU_result_high[21:0] != 22'h3FFFFF)*/) ? 1'b1 : 1'b0;
    assign MemRead = (lw == 1'b1 && (ALU_result_high[21:0] != 22'h3FFFFF)) ? 1'b1 : 1'b0;
    assign IOReadSigned = ((lw == 1'b1|| lb == 1'b1) && (ALU_result_high[21:0] == 22'h3FFFFF))?1'b1:1'b0;
    assign IOReadUnsigned = (lbu == 1'b1 && (ALU_result_high[21:0] == 22'h3FFFFF))? 1'b1:1'b0;
    assign IOWrite = (sw == 1'b1 && (ALU_result_high[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0;
    assign MemOrIOtoReg = IOReadUnsigned || IOReadSigned || MemRead;
   
    always @(inst) begin
        case(opcode)
            7'b000_0011: ALUOp = 2'b00; // load
            7'b10_0011: ALUOp = 2'b00; // store
            7'b110_0011: ALUOp = 2'b01; // Branch
            7'b011_0011: ALUOp = 2'b10; // R-format
            7'b011_0111: ALUOp = 2'b00; // U type (lui)
            7'b001_0011: ALUOp = 2'b11; // I type (arith)
        endcase    
    end

    always @(inst) begin
        case(opcode)
            7'b000_0011: ALUSrc = 1'b1; // load
            7'b010_0011: ALUSrc = 1'b1; // store
            7'b011_0111: ALUSrc = 1'b1; // U type (lui)
            7'b001_0011: ALUSrc = 1'b1; // I type (arith)
            default: ALUSrc = 1'b0;
        endcase    
    end

endmodule