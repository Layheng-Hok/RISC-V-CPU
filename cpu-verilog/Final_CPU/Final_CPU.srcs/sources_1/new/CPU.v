`timescale 1ns / 1ps

module CPU(
    input fpga_rst, 
    input fpga_clk,               
    input [15:0] switch,
    input [3:0] button,

    output [15:0] led,
    output [7:0] tube_sel,
    output [7:0] tube0,
    output [7:0] tube1
    );
    
    wire cpu_clk;
    wire clk_div_2s;

    wire [13:0] fetch_addr;
    wire [31:0] inst;
    wire [31:0] imm32;
    wire zero, MemRead, MemtoReg, MemWrite, MemOrIOtoReg, ALUSrc, RegWrite, IOReadUnsigned, IOReadSigned, IOWrite;
    wire LEDCtrl, SwitchCtrl, TubeCtrl;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    wire [31:0] write_data;
    wire [31:0] write_data_32;
    wire [31:0] addr_out;
    wire [31:0] ram_dat_o;
    wire [1:0] ALUOp;
    wire [31:0] ALU_result;
    wire [15:0] io_rdata;
    wire [31:0] mem_data;
    wire jump, jalr;
    wire [31:0] ra;
    wire [15:0] ledWire;
    wire [15:0] switch_data;
    wire reg19;
    wire rst;
    wire bne, beq, bge, blt, bgeu, bltu;
    
    assign rst = fpga_rst;
    
    Clock Clock(
        .clk_in1(fpga_clk),
        .rst(rst),
        .clk_out1(cpu_clk),
        .clk_out2(clk_div_2s)
    );
    
    // wire RegDST, Branch, nBranch, RegWrite, ALUSrc, MemWrite, MemOrIOtoReg;
    // wire Jmp, Jal, Jr, Zero, MemRead, IORead, IOWrite, I_format, Sftmd;

 
  
    // wire [31:0] link_addr;
    // wire [31:0] branch_base_addr;
    // wire [31:0] Addr_result;
    // wire [31:0] Sign_extend;

    
    IFetch IFetch(
        .clk(cpu_clk),
        .rst(rst),
        .imm32(imm32),
        .jump(jump),
        .jalr(jalr),
        .beq(beq),
        .bne(bne),
        .bge(bge),
        .blt(blt), 
        .bgeu(bgeu), 
        .bltu(bltu),
        .zero(zero),
        .ra(ra),
        .inst(inst),
        .ALUResult(ALU_result)
        //.branch_base_addr(branch_base_addr)
        // .fetch_addr(fetch_addr)
    );
 
    Decoder Decoder(
        .clk(cpu_clk),
        .rst(rst),
        .ALU_result(ALU_result),
        .MemOrIOtoReg(MemOrIOtoReg),
        .regWrite(RegWrite),
        .inst(inst),
        .ra(ra),
        .jump(jump),
        .IOData(mem_data),
        .rs1Data(read_data_1),
        .rs2Data(read_data_2),
        .imm32(imm32)
    );
    
    Controller Controller(
        .inst(inst),
        .ALU_result_high(ALU_result[31:10]),
        .Jump(jump),
        .jalr(jalr),
        .beq(beq),
        .blt(blt),
        .bge(bge),
        .bltu(bltu),
        .bgeu(bgeu),
        .MemRead(MemRead),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemOrIOtoReg(MemOrIOtoReg),
        .IOReadUnsigned(IOReadUnsigned),
        .IOReadSigned(IOReadSigned),
        .IOWrite(IOWrite),
        .bne(bne)
    );
    
    DataMem DataMem(
        .clk(cpu_clk),
        .mem_write(MemWrite),
        .mem_read(MemRead),
        .addr(addr_out),
        .din(read_data_2),
        .dout(ram_dat_o)
    );

    ALU ALU(
        .ReadData1(read_data_1),
        .ReadData2(read_data_2),
        .imm32(imm32),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .funct3(inst[14:12]),
        .funct7(inst[31:25]),
        .ALUResult(ALU_result),
        .zero(zero)
    );
    
    MemOrIO MemOrIO(
        .mRead(MemRead),
        .mWrite(MemWrite),
        .IOReadUnsigned(IOReadUnsigned),
        .IOReadSigned(IOReadSigned),
        .IOWrite(IOWrite),
        .addr_in(ALU_result),
        .addr_out(addr_out),
        .m_rdata(ram_dat_o),
        .io_rdata(io_rdata),
        .r_wdata(mem_data),
        .r_rdata(read_data_2),
        .write_data(write_data),
        .write_data_32(write_data_32),
        .LEDCtrl(LEDCtrl),
        .SwitchCtrl(SwitchCtrl),
        .TubeCtrl(TubeCtrl)
    );

    Switch Switch(
        .clk(fpga_clk),
        .rst(rst),
        .IOReadUnsigned(IOReadUnsigned),
        .IOReadSigned(IOReadSigned),
        .SwitchCtrl(SwitchCtrl),
        .switch(switch),
        .button(button),
        .switchaddr(addr_out[7:0]),
        .switchrdata(io_rdata)
    );
    
     Led Led(
     .clk(cpu_clk),
     .rst(rst),
     .IOWrite(IOWrite),
     .LEDCtrl(LEDCtrl),
     .ledaddr(addr_out[7:0]),
     .ledwdata(write_data[15:0]),
     .led(led)
     );
        
    
    Tube Tube(
         .clk(cpu_clk),
         .fpga_clk(fpga_clk),
         .rst(rst),
         .clk_div_2s(clk_div_2s),
         .button(button[3]),
         .button2(button[2]),
         .IOWrite(IOWrite),
         .TubeCtrl(TubeCtrl),
         .tubeaddr(addr_out[7:0]),
         .tubewdata(write_data[15:0]),
         .tubewdata32(write_data_32),
         .testcase(write_data[15:0]),
         .sel(tube_sel),
         .tube0(tube0),
         .tube1(tube1)
         );

endmodule