`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:39:44 11/20/2013 
// Design Name: 
// Module Name:    sobel 
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
module sobel(clock,matrix_inp,switch,edge_out);
   /*
    Redefined Sobel to do the splicing inside, as it makes no sense
    to pass in the inputs value by value
    */
   parameter SMAT=200;
   parameter IND=SMAT-1;

   input clock;
   input [IND:0] matrix_inp;
   
   input       switch;
   output [7:0] edge_out;

   wire [7:0] 	z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24;

   
   assign z0=matrix_inp[IND:IND-7];
   assign z1=matrix_inp[IND-8:IND-8-7];
   assign z2=matrix_inp[IND-16:IND-16-7];
   assign z3=matrix_inp[IND-24:IND-24-7];
   assign z4=matrix_inp[IND-32:IND-32-7];
   assign z5=matrix_inp[IND-40:IND-40-7];
   assign z6=matrix_inp[IND-48:IND-48-7];
   assign z7=matrix_inp[IND-56:IND-56-7];
   assign z8=matrix_inp[IND-64:IND-64-7];
   assign z9=matrix_inp[IND-72:IND-72-7];
   assign z10=matrix_inp[IND-80:IND-80-7];
   assign z11=matrix_inp[IND-88:IND-88-7];
   assign z12=matrix_inp[IND-96:IND-96-7];
   assign z13=matrix_inp[IND-104:IND-104-7];
   assign z14=matrix_inp[IND-112:IND-112-7];
   assign z15=matrix_inp[IND-120:IND-120-7];
   assign z16=matrix_inp[IND-128:IND-128-7];
   assign z17=matrix_inp[IND-136:IND-136-7];
   assign z18=matrix_inp[IND-144:IND-144-7];
   assign z19=matrix_inp[IND-152:IND-152-7];
   assign z20=matrix_inp[IND-160:IND-160-7];
   assign z21=matrix_inp[IND-168:IND-168-7];
   assign z22=matrix_inp[IND-176:IND-176-7];
   assign z23=matrix_inp[IND-184:IND-184-7];
   assign z24=matrix_inp[IND-192:IND-192-7];

   
   // Previously had maximum of 2^10-1 -> 9 bits for mag, 1 bit for sign
   // Note that maximum is 2^13-1 for both signs -> need 12 bits for mag, 1 bit for sign
   reg signed [13:0] Gx;  //Result of mask+differentiation in x
   reg signed [13:0] Gy;  //Result of mask+differentiation in y
   reg signed [13:0] abs_Gx;
   reg signed [13:0] abs_Gy;

   
   reg [13:0] 	     sum; 
   
   always @ (posedge clock)
     begin
	//Gx<=((z2-z0)+((z5-z3)<<1)+(z8-z6)); //masking in x direction
	Gx<=((z4-z0)+(z24-z20)+((z9-z5)<<2)+((z19-z15)<<2)+((z14-z10)<<2)+((z14-z10)<<1)+((z3-z1)<<1)+((z23-z21)<<1)+((z8-z6)<<3)+((z18-z16)<<3)+((z13-z11)<<3))+((z13-z11)<<2); //masking in x direction
	

	Gy<=((z0-z20)+(z4-z24)+((z1-z21)<<2)+((z3-z23)<<2)+((z2-z22)<<2)+((z2-z22)<<1)+((z5-z15)<<1))+((z9-z19)<<1)+((z6-z16)<<3)+((z8-z18)<<3)+((z7-z17)<<3)+((z7-z17)<<2); //masking in y direction
	abs_Gx <= (Gx[13]?~Gx+1:Gx);//if negative, then invert and add  to make pos.
	abs_Gy <= (Gy[13]?~Gy+1:Gy);//if negative, then invert and add  to make pos.
	sum <=abs_Gx+abs_Gy;
	
	//Yet to Apply Threshold
	//Threshold-
	//assign edge_out =(sum > 120) ? 0 : 8'hff
	///assign edge_out =(sum > 120) ? 8'hff : 0
     end // always @ (posedge clock)

   assign edge_out=(sum > 400)?0 : 8'hff;

   
   // This currently gives out a bit noisy -> were not sure of calibration
   // for the threshold for 5by5 sobel filter
   // Very noisy output, not recognizable
   //assign edge_out=(|sum[13:8])?0 : 8'hff;
   
endmodule
