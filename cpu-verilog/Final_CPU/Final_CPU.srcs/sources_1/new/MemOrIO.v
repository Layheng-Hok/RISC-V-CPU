`timescale 1ns / 1ps

module MemOrIO(
    input mRead,                 // read memory, from Controller
    input mWrite,                // write memory, from Controller
    input IOReadUnsigned,        // read unsigned IO, from Controller
    input IOReadSigned,          // read signed IO, from Controller
    input IOWrite,               // write IO, from Controller
    input[31:0] addr_in,         // from alu_result in ALU
    output[31:0] addr_out,       // address to Data-Memory
    input[31:0] m_rdata,         // data read from Data-Memory
    input[15:0] io_rdata,        // data read from IO, 16 bits
    output reg [31:0] r_wdata,        // data to Decoder(register file)
    input[31:0] r_rdata,         // data read from Decoder(register file)
    output reg [31:0] write_data, // data to memory or I/O??m_wdata, io_wdata??
    output reg [31:0] write_data_32, // just write_data but original 32bit value
    output LEDCtrl,              // LED Chip Select
    output SwitchCtrl,           // Switch Chip Select
    output TubeCtrl
    );
    
    assign addr_out   = addr_in;
//    assign r_wdata    = (IOReadUnsigned == 1)? {16'b0,io_rdata}:m_rdata;
    // assign r_wdata = (IOReadUnsigned == 1'b1) ? {16'b0, io_rdata} : 
    //              (IOReadSigned == 1'b1) ? {{24{io_rdata[7]}}, io_rdata[7:0]} : 
    //              m_rdata;
    assign SwitchCtrl = ((IOReadUnsigned == 1'b1 || IOReadSigned == 1'b1)&& (addr_in[7:4] == 4'h0 || addr_in[7:4] == 4'h1 || addr_in[7:4] == 4'h2)) ? 1'b1 : 1'b0;
    assign LEDCtrl    = (IOWrite == 1'b1 && addr_in[7:0] != 8'h72 &&(addr_in[7:4] == 4'h4 || addr_in[7:4] == 4'h5 || addr_in[7:4] == 4'h6)) ? 1'b1 : 1'b0;
    assign TubeCtrl   = (IOWrite == 1'b1 && (addr_in[7:4] == 4'h7 || addr_in[7:0] == 8'h69)) ? 1'b1 : 1'b0;

    always @* begin
        if (addr_out[7:0] == 8'h00 && IOReadUnsigned) begin
            r_wdata = {16'h0000, io_rdata};
        end 
        else if (addr_out[7:0] == 8'h00 && IOReadSigned) begin
            r_wdata = {{16{io_rdata[15]}}, io_rdata};
        end
        else if (addr_out[7:0] == 8'h10 && IOReadUnsigned) begin
            r_wdata = {24'h000000, io_rdata[7:0]};
        end
        else if (addr_out[7:0] == 8'h10 && IOReadSigned) begin
            r_wdata = {{24{io_rdata[7]}}, io_rdata[7:0]};
        end
        else if (addr_out[7:4] == 4'h2) begin
            r_wdata = {28'b0, io_rdata[3:0]};
        end
        else begin
            r_wdata = m_rdata;
        end 
    end

    always @* begin
        if ((mWrite == 1'b1)||(IOWrite == 1'b1)) begin
             write_data = ((mWrite == 1'b1)? r_rdata :{{16{r_rdata[15]}},r_rdata[15:0]});
             write_data_32 = r_rdata;
        end
        else begin
            write_data = 32'hZZZZZZZZ;
        end
    end

endmodule