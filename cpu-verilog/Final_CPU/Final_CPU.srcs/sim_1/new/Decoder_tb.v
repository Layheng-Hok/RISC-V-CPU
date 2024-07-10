`timescale 1ns / 1ps

module Decoder_tb();

    // Define constants
    parameter PERIOD = 10; // Clock period in ns

    // Inputs
    reg clk;
    reg rst;
    reg regWrite;
    reg [31:0] inst;
    reg [31:0] ra;
    reg jump;
    reg [31:0] writeData;
    reg [15:0] IOData;
    reg IOWrite;

    // Outputs
    wire [15:0] led;
    wire [31:0] rs1Data;
    wire [31:0] rs2Data;
    wire [31:0] imm32;

    // Instantiate the module under test
    Decoder dut (
        .clk(clk),
        .rst(rst),
        .regWrite(regWrite),
        .inst(inst),
        .ra(ra),
        .jump(jump),
        .writeData(writeData),
        .IOData(IOData),
        .IOWrite(IOWrite),
        .led(led),
        .rs1Data(rs1Data),
        .rs2Data(rs2Data),
        .imm32(imm32)
    );

    // Clock generation
    always #((PERIOD / 2)) clk = ~clk;

    // Stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 0;
        regWrite = 0;
        inst = 32'h00000000; // Initialize with a NOP instruction
        ra = 32'h00000000;
        jump = 0;
        writeData = 32'h00000000;
        IOData = 16'h0000;
        IOWrite = 0;

        // Release reset after some time
        #100 rst = 1;

        // Example test scenario
        // Assuming you want to write to register 10 (writeReg = 5'b01010)
        // with data 32'hDEADBEEF when regWrite is enabled.
        // Feel free to modify this scenario based on your requirements.

        // Set the instruction to some valid instruction
        inst = 32'h012002b3;
        // Write enable
        regWrite = 1;

        // Set the destination register

        // Set the data to be written
        writeData = 32'hDEADBEEF;

        // Assert IO write signal (assuming you want to write to register 18)
        IOWrite = 1;

        // Set the data to be written to IO register
        IOData = 16'hABCD;

        // Provide some delay for the signals to stabilize
        #200;

        // End of test scenario

        // Add more test scenarios as needed

        // Finish simulation after some time
        #1000;
        $finish;
    end

endmodule
