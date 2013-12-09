`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:14 11/26/2013 
// Design Name: 
// Module Name:    edgedetection 
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

module edgedetection(
		     input 	   reset,
		     input 	   clock,
		     input [23:0]  rgb, // This corresponds to the lower_pixels in ZBT [ZBT[17:0]]
		     input [23:0]  rgb1, // This corresponds to the higher_pixels in ZBT
		     input [10:0]  hcount,
		     output [23:0] edgeoutputsel,
		     output 	   select,
		     input grayscale
		     );

   // Intermediate grayscale outputs that will be multiplexed
   // and passed into the shift register
   wire [7:0] 	  grayout, grayout1;
   wire [7:0] 	  sr_grayout;
   

   // Change made in 5by5 sobel
   wire [199:0]   matrixout;
   wire 	   swi = 1; // Sobel 5x5 
   wire [7:0] 	   edgeoutputsobel;


   //--------------------------------------------------------------------------------
   // Grayscale Module: Parallel Calculation of Two Pixels at a time
   //--------------------------------------------------------------------------------
   rgb2gray converter(clock,rgb,grayout);
   rgb2gray converter2(clock, rgb1, grayout1);

   assign sr_grayout = hcount[0] ? grayout : grayout1;

   shiftregister #(.cols(1344)) shifter(clock,hcount,sr_grayout,matrixout);
   // Note this is the new grayscale output
   wire [7:0] 	   shifted_gs = matrixout[39:32];

   //--------------------------------------------------------------------------------
   // Sobel Module
   //--------------------------------------------------------------------------------
   wire [7:0] 	   sobel_out;
   wire [7:0] 	   sobel3_out;
   
   
   sobel edgedetect(clock,matrixout,swi,sobel_out);

   sobel_3 edgedetect_3(clock, matrixout[103:96],matrixout[95:88],
			matrixout[87:80], matrixout[63:56],
			matrixout[55:48], matrixout[47:40],
			matrixout[23:16], matrixout[15:8],
			matrixout[7:0],swi,sobel3_out);
   

   
   //--------------------------------------------------------------------------------
   // SelectBit Generation
   //--------------------------------------------------------------------------------
   wire [23:0] 	   sobel_rgb;
   wire 	   select_5;
   
   wire [23:0] 	   sobel3_rgb;
   wire 	   select_3;
   
   
   
   selectbit selector(clock, sobel_out, sobel_rgb, select_5);
   selectbit selector_3(clock, sobel3_out, sobel3_rgb, select_3);

   // Below Code is for switching between gs, and edgeOut
   //assign  edgeoutputsel = grayscale ? {shifted_gs, shifted_gs, shifted_gs} :~sobel_rgb;

   // Current code for switching between sobel_3 and sobel_5
   assign  edgeoutputsel = grayscale ? ~sobel_rgb: ~sobel3_rgb;
   assign select = grayscale ? select_5 : select_3;
   
   // To be visually pleasant, let's display the inversion of actual
   

endmodule
