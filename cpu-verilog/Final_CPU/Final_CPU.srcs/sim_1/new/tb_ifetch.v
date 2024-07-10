`timescale 1ns / 1ps

module tb_ifetch;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] imm32;
    reg jump;
    reg branch;
    reg zero;
    wire [31:0] ra;
    wire [31:0] inst;

    // Instantiate the unit under test (UUT)
    IFetch dut (
        .clk(clk),
        .rst(rst),
        .imm32(imm32),
        .jump(jump),
        .branch(branch),
        .zero(zero),
        .ra(ra),
        .inst(inst)
    );

    // Clock generation
    always #10 clk = ~clk;

    // Initial stimulus
    initial begin
        // Initialize inputs
        clk = 1'b0;
        rst = 1'b0;
        imm32 = 32'h00000000;
        jump = 1'b0;
        branch = 1'b0;
        zero = 1'b0;

        // Wait for a few clock cycles
        #10;

        // Deassert reset
        rst = 1'b1;

        // Apply some test cases
        // Example: Load an instruct
        #1000;
        $finish;
    end

endmodule