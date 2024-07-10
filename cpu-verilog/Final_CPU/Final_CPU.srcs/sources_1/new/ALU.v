`timescale 1ns / 1ps

module ALU(
    input [31:0] ReadData1, ReadData2, imm32,
    input ALUSrc,
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [31:0] ALUResult,
    output wire zero
    );

    wire [31:0] operand2;
    reg [3:0] ALUControl;

    assign operand2 = (ALUSrc == 0) ? ReadData2: imm32;

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0010;   // add (load)
            2'b01: begin // branch
                    if (funct3 == 3'b110 || funct3 == 3'b111) begin            
                        ALUControl = 4'b1001;   // sub bottom 8 bits
                    end else begin
                        ALUControl = 4'b0110;  // sub 
                    end
                   end 
            2'b10: begin // r format
                    if (funct7 == 7'b0000000 && funct3 == 3'b000) begin       // add
                        ALUControl = 4'b0010;
                    end
                    else if (funct7 == 7'b0100000 && funct3 == 3'b000) begin  // sub
                        ALUControl = 4'b0110;
                    end
                    else if (funct7 == 7'b0000000 && funct3 == 3'b111) begin  // and
                        ALUControl = 4'b0000;
                    end
                    else if (funct7 == 7'b0000000 && funct3 == 3'b110) begin  // or
                        ALUControl = 4'b0001;
                    end
                    else if (funct7 == 7'b0000000 && funct3 == 3'b001) begin  // sll
                        ALUControl = 4'b0111;
                    end
                    else if (funct7 == 7'b0100000 && funct3 == 3'b101) begin  // sra
                        ALUControl = 4'b1000;
                    end
                    else if (funct7 == 7'b0000000 && funct3 == 3'b101) begin  //srl
                        ALUControl = 4'b1010;
                    end 
                  end
            2'b11: begin // i format arith
                    if (funct3 == 3'b000) begin // addi
                        ALUControl = 4'b0010;
                    end
                    else if (funct7 == 7'b0000000 && funct3 == 3'b101) begin // srli
                        ALUControl = 4'b1010;
                    end
                    else if (funct7 == 7'b0000000 && funct3 == 3'b001) begin // slli
                        ALUControl = 4'b0111;
                    end
                    else if (funct7 == 7'b0100000 && funct3 == 3'b101) begin // srai
                        ALUControl = 4'b1000;
                     end
                    else if (funct3 == 3'b100) begin //xori
                        ALUControl = 4'b1011;
                    end
                    else if (funct3 == 3'b111) begin // andi
                        ALUControl = 4'b0000;
                    end
                   end
        endcase
    end

      always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = ReadData1 & operand2;
            4'b0001: ALUResult = ReadData1 | operand2;
            4'b0010: ALUResult = ReadData1 + operand2; 
            4'b0110: ALUResult = ReadData1 - operand2;
            4'b0111: ALUResult = ReadData1 << operand2; // sll
            4'b1000: ALUResult = ReadData1 >>> operand2; // sra
            4'b1001: ALUResult = ReadData1[7:0] - operand2[7:0];
            4'b1010: ALUResult = ReadData1 >> operand2; // srl
            4'b1011: ALUResult = ReadData1 ^ operand2; // xor
        endcase
    end

    assign zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

endmodule