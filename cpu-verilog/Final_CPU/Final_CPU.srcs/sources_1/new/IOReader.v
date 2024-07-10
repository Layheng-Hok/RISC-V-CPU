`timescale 1ns / 1ps

module IOReader (
    input			reset,				// reset, active high 
	input			ior,				// from Controller, 1 means read from input devic
    input			switchctrl,			// means the switch is selected as input device 
    input	[15:0]	ioread_data_switch,	// the data from switch
    output	[15:0]	ioread_data 		// the data to memorio 
);
    
    reg [15:0] ioread_data;
    
    always @* begin
        if (~reset)
            ioread_data = 16'h0;
        else if (ior == 1) begin
            if (switchctrl == 1)
                ioread_data = ioread_data_switch;
            else
				ioread_data = ioread_data;
        end
    end
	
endmodule
