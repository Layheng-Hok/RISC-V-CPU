`timescale 1ns / 1ps

module Switch(input clk,                       // 23MHz CPU clk
               input rst,                      // Reset
               input IOReadUnsigned,           // IO read unsigned
               input IOReadSigned,             // IO read signed
               input SwitchCtrl,               // Switch ctrl
               input [3:0] button,             // Button
               input [7:0] switchaddr,         // Switch address
               input [15:0] switch,            // Switch
               output reg [15:0] switchrdata); // Switch read data

    always@(negedge clk or negedge rst) begin
        if (~rst) begin
            switchrdata <= 16'h0000;
        end
        else begin 
             if (SwitchCtrl && (IOReadUnsigned || IOReadSigned)) begin 
                if (switchaddr == 8'h00) begin //0xffffc00
                    switchrdata[15:0] <= switch[15:0]; //read from the 16 switches
                end else if (switchaddr == 8'h10) begin //0xffffc10
                     switchrdata[15:0] <= {8'h00, switch[15:8]}; //read from the left 8 switches
                end else if (switchaddr == 8'h20) begin //0xffffc20
                     switchrdata[15:0] <= {15'b000_0000_0000_0000, button[3]}; //read from V1 (test_case button)
                end else if (switchaddr == 8'h22) begin //0xffffc22
                     switchrdata[15:0] <= {15'b000_0000_0000_0000, button[2]}; //read from R11 (end test button)
                end else if (switchaddr == 8'h24) begin //0xffffc24
                     switchrdata[15:0] <= {15'b000_0000_0000_0000, button[0]}; //read from R17 (input A button)
                end else if (switchaddr == 8'h26) begin //0xffffc26
                     switchrdata[15:0] <= {15'b000_0000_0000_0000, button[1]}; //read from U4 (input B button)
                end             
            end                                     
       end
    end 
    
endmodule
