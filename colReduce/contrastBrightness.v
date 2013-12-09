`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:56 12/02/2013 
// Design Name: 
// Module Name:    contrastBrightness 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module contrastBrightness(
    input [23:0] tRGB,
    input clk,
    input reset,
    output [23:0] uptRGB
    );
   
   wire [7:0] 	  tR;
   wire [7:0] 	  tG;
   wire [7:0] 	  tB;
   
   reg [10:0] 	  uptRtest;
   reg [10:0] 	  uptGtest;
   reg [10:0] 	  uptBtest;
   
   wire [7:0] 	  uptR;
   wire [7:0] 	  uptG;
   wire [7:0] 	  uptB;
   
   assign tR = tRGB[23:16];
   assign tG = tRGB[15:8];
   assign tB = tRGB[7:0];

   // with (contrast, brightness) = (5, 32) got decent results
   // Now trying with (6, 16)
   wire [7:0] 	  contrast 		= 8'd6;
   wire [7:0] 	  brightness 	= 8'd16;
   
   always @(posedge clk) begin
      uptRtest <= (tR*contrast)/4 + brightness;
      uptGtest <= (tG*contrast)/4 + brightness;
      uptBtest <= (tB*contrast)/4 + brightness;
   end
   
   assign uptR = (uptRtest>255)?8'd255:uptRtest;
   assign uptG = (uptGtest>255)?8'd255:uptGtest;
   assign uptB = (uptBtest>255)?8'd255:uptBtest;
   
   assign uptRGB = {uptR,uptG,uptB};

endmodule
