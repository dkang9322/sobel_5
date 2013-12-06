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
module sobel(clock,z0,z1,z2,z3,z4,z5,z6,z7,z8,,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24,switch,edge_out);
	 input clock;
	 input [7:0] z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15,z16,z17,z18,z19,z20,z21,z22,z23,z24;
	 input switch;
	 output [7:0] edge_out;
	 
	reg signed [13:0] Gx;  //Result of mask+differentiation in x
	reg signed [13:0] Gy;  //Result of mask+differentiation in y
	reg signed [13:0] abs_Gx;
	reg signed [13:0] abs_Gy;

	
	reg [10:0] sum; 
	
	always @ (posedge clock)
	begin
	//Gx<=((z2-z0)+((z5-z3)<<1)+(z8-z6)); //masking in x direction
	Gx<=((z4-z0)+(z24-z20)+((z9-z5)<<2)+((z19-z15)<<2)+((z14-z10)<<2)+((z14-z10)<<1)+((z3-z1)<<1)+
		((z23-z21)<<1)+((z8-z6)<<3)+((z18-z16)<<3)+((z13-z11)<<3)+((z13-z11)<<2)); //masking in x direction
	

	Gy<=((z0-z20)+(z4-z24)+((z1-z21)<<2)+((z3-z23)<<2)+((z2-z22)<<2)+((z2-z22)<<1)+((z5-z15)<<1))+
		((z9-z19)<<1)+((z6-z16)<<3)+((z8-z18)<<3)+((z7-z17)<<3)+((z7-z17)<<2)); //masking in y direction
	abs_Gx <= (Gx[13]?~Gx+1:Gx);//if negative, then invert and add  to make pos.
	abs_Gy <= (Gy[13]?~Gy+1:Gy);//if negative, then invert and add  to make pos.
	sum <=abs_Gx+abs_Gy;
	
	//Yet to Apply Threshold
	//Threshold-
	//assign edge_out =(sum > 120) ? 0 : 8'hff
	///assign edge_out =(sum > 120) ? 8'hff : 0
	end
	assign edge_out=(|sum[13:8])?8'hff:sum[7:0];
	endmodule
