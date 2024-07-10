`timescale 1ns / 1ps

module Led(input clk,              // clk
            input rst,             // Reset
            input IOWrite,         // IO sign
            input LEDCtrl,         // LED ctrl
            input[7:0] ledaddr,    // LED address
            input[15:0] ledwdata,  // LED write data
            output reg[15:0] led); // LED
    
    always@(negedge clk or negedge rst) begin
        if (~rst) begin
            led <= 16'h0000;
        end
        else if (LEDCtrl && IOWrite) begin
            if (ledaddr == 8'h40) // #0xfffffc40, 16 led
                led[15:0] <= ledwdata[15:0];
            else if (ledaddr == 8'h50) // #0xfffffc50, left 8 led
                led[15:0] <= {ledwdata[7:0], 8'h00};
            else if (ledaddr == 8'h60) // #0xfffffc60, right 8 led
                led[15:0] <= {8'h00, ledwdata[7:0]};
            else
                led <= led;
        end
        else begin
            led <= led;
        end
    end
endmodule
