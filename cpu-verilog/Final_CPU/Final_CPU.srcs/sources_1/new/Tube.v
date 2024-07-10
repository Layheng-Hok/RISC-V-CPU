`timescale 1ns / 1ps

module Tube(input clk,                  // 23MHz CPU clk
            input fpga_clk,
            input rst,                      //reset
            input clk_div_2s,                //2 sec clock
            input button,               // test case hutton      
            input button2,     
            input IOWrite,              // IO sign
            input TubeCtrl,              // tube ctrl
            input[7:0] tubeaddr,         // tube address
            input[15:0] tubewdata,       // tube write data
            input [31:0] tubewdata32,      // tube write data 32 bits
            input [15:0] testcase,         // test case number
            output reg[7:0] sel,         // Bit selective signal
            output reg[7:0] tube0,       // Segment-selected signal
            output reg[7:0] tube1);
    
    parameter cnt  = 50000;
    reg[18:0] divclk_cnt = 0;
    reg divclk           = 0;
    reg[3:0] disp_dat    = 0;
    reg[2:0] disp_bit    = 0;
    reg [3:0] num0, num1, num2, num3, num4, num5, num6, num7;
    reg[31:0] data, dataSlow;
    reg testNum;
    reg[31:0] array [0:191];
    integer i = 0;
    integer j = 0;
    integer x = 0;
    
       
       always @(posedge fpga_clk) begin
         if (divclk_cnt == cnt) begin
            divclk <= ~divclk;
            divclk_cnt <= 0;
        end else begin
            divclk_cnt <= divclk_cnt + 1'b1;
        end
        end
        
        
        always @(posedge fpga_clk or negedge rst) begin
            if(~rst) begin testNum <= 1'b0; end
            else if (testcase == 16'h0007) testNum <= 1'b1;
            else if(button2) testNum <= 1'b0;
            else testNum <= testNum;
        end
        
            always @(posedge clk or negedge rst) begin
            if (~rst) begin
                i <= 0;
                for (x = 0; x < 192; x = x + 1) begin
                    array[x] <= 0;
                end
            end else if (tubeaddr == 8'h69 && testNum) begin
                array[i] <= tubewdata32;
                i <= i + 1;
            end
            else if(button2) begin
                i <= 0;
                for (x = 0; x < 192; x = x + 1) begin
                    array[x] <= 0;
                end
            end
        end
        
        always @(posedge clk_div_2s or negedge rst) begin
            if(~rst) begin 
                j <= 0;
                dataSlow <= 32'b0;
             end
              else if (testNum && array[j] != 32'b0) begin j <= j + 1; end
              else if(button2) begin
                  j <= 0;
              end
               dataSlow <= array[j];
        end
   
       always @(posedge fpga_clk or negedge rst) begin
                if (~rst) begin
                   data <= 32'b0;
                end 
                else if(testNum) begin
                    data <= dataSlow;
                end 
                else if(testNum == 1'b0) begin
                    if (tubeaddr == 8'h70 || tubeaddr == 8'h72) begin
                       data <= {{16{tubewdata[15]}}, tubewdata[15:0]};
                    end 
                    else begin
                        data <= tubewdata32;
                       end
                end
               end

    always@(negedge clk or negedge rst) begin
        if (~rst) begin
            num7 <= 4'h0;
            num6 <= 4'h9;
            num5 <= 4'ha;
            num4 <= 4'hb;
            num3 <= 4'hc;
            num2 <= 4'h0;
            num1 <= 4'h0;
            num0 <= 4'h0;
        end
        else if ((TubeCtrl == 1'b1 && IOWrite == 1'b1) || dataSlow != 32'b0) begin
            num7 <= data[31:28];
            num6 <= data[27:24];
            num5 <= data[23:20];
            num4 <= data[19:16];
            num3 <= data[15:12];
            num2 <= data[11:8];
            num1 <= data[7:4];
            num0 <= data[3:0];
            end
        else begin
            num7 <= num7;
            num6 <= num6;
            num5 <= num5;
            num4 <= num4;
            num3 <= num3;
            num2 <= num2;
            num1 <= num1;
            num0 <= num0;
        end
    end

    always@(posedge divclk) begin
        if (disp_bit > 7) begin
            disp_bit <= 0;
        end
        else begin
            disp_bit <= disp_bit + 1'b1;
            case (disp_bit)
                3'b000 :
                begin
                    disp_dat <= num0;
                    sel <= 8'b00000001;
                end
                3'b001 :
                begin
                    disp_dat <= num1;
                    sel <= 8'b00000010;
                end
                3'b010 :
                begin
                    disp_dat <= num2;
                    sel <= 8'b00000100;
                end
                3'b011 :
                begin
                    disp_dat <= num3;
                    sel <= 8'b00001000;
                end
                3'b100 :
                begin
                    disp_dat <= num4;
                    sel <= 8'b00010000;
                end
                3'b101 :
                begin
                    disp_dat <= num5;
                    sel <= 8'b00100000;
                end
                3'b110 :
                begin
                    disp_dat <= num6;
                    sel <= 8'b01000000;
                end
                3'b111 :
                begin
                    disp_dat <= num7;
                    sel <= 8'b10000000;
                end
                default:
                begin
                    disp_dat <= 0;
                    sel <= 8'b00000000;
                end
            endcase
        end
    end
    
    always@(disp_dat) begin
        if (sel > 8'b00001000) begin
            case (disp_dat)
                4'h0 : tube0 = 8'hfc;
                4'h1 : tube0 = 8'h60;
                4'h2 : tube0 = 8'hda;
                4'h3 : tube0 = 8'hf2;
                4'h4 : tube0 = 8'h66;
                4'h5 : tube0 = 8'hb6;
                4'h6 : tube0 = 8'hbe;
                4'h7 : tube0 = 8'he0;
                4'h8 : tube0 = 8'hfe;
                4'h9 : tube0 = 8'hf6;
                4'ha : tube0 = 8'hee;
                4'hb : tube0 = 8'h3e;
                4'hc : tube0 = 8'h9c;
                4'hd : tube0 = 8'h7a;
                4'he : tube0 = 8'h9e;
                4'hf : tube0 = 8'h8e;
            endcase
        end
        else begin
            case (disp_dat)
                4'h0 : tube1 = 8'hfc;
                4'h1 : tube1 = 8'h60;
                4'h2 : tube1 = 8'hda;
                4'h3 : tube1 = 8'hf2;
                4'h4 : tube1 = 8'h66;
                4'h5 : tube1 = 8'hb6;
                4'h6 : tube1 = 8'hbe;
                4'h7 : tube1 = 8'he0;
                4'h8 : tube1 = 8'hfe;
                4'h9 : tube1 = 8'hf6;
                4'ha : tube1 = 8'hee;
                4'hb : tube1 = 8'h3e;
                4'hc : tube1 = 8'h9c;
                4'hd : tube1 = 8'h7a;
                4'he : tube1 = 8'h9e;
                4'hf : tube1 = 8'h8e;
            endcase
        end
    end
endmodule