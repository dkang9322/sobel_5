`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:28:14 11/24/2013 
// Design Name: 
// Module Name:    shiftregister 
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
module shiftregister #(parameter cols = 640)
     (         
    input 	  clock,
    input [10:0]  hcount,
    input [7:0]   indata,
    output [199:0] matrix
    );

//Data Comes in , Its shifted to right. At end of row 1, its shifted to row 2
//And so on to row 3. Shift out is connected to row3 last pixel
   //Output matrix is connected to last 3 pixels of each row
   //At every clock we shift data/pixel to right.
   //Consider option of performing sobel at end.
   
   reg [7:0] 	  row1 [(cols-1):0];
   reg [7:0] 	  row2 [(cols-1):0];
   reg [7:0] 	  row3 [(cols-1):0];
   reg [7:0] 	  row4 [(cols-1):0];
   reg [7:0] 	  row5 [4:0];
   
   integer 	  i;
   
   
   always @ (posedge clock)
     begin
	
	row1[0]<=indata;
	
	row2[0]<=row1[(cols-1)];//TO ADD
	row3[0]<=row2[(cols-1)];//TOADD
	row4[0]<=row3[(cols-1)];
	row5[0]<=row4[(cols-1)];
	
	for(i=1;i<cols;i=i+1)
	  begin
	     row1[i]<=row1[i-1];
	     row2[i]<=row2[i-1];
	     row3[i]<=row3[i-1];
	     row4[i]<=row4[i-1];
	     
	  end

	row5[4] <= row5[3];
	row5[3] <= row5[2];
	row5[2] <= row5[1];
	row5[1] <= row5[0];

     end	

   assign matrix = {row1[cols-1], row1[cols-2], row1[cols-3], row1[cols-4], row1[cols-5],
		    row2[cols-1], row2[cols-2], row2[cols-3], row2[cols-4], row2[cols-5],
		    row3[cols-1], row3[cols-2], row3[cols-3], row3[cols-4], row3[cols-5],
		    row4[cols-1], row4[cols-2], row4[cols-3], row4[cols-4], row4[cols-5],
		    row5[4], row5[3], row5[2], row5[1], row5[0]};
   

   //Matrix is like this in matrix form:
   // row1[5]  row1[4]  row1[3]  row1[2]  row1[1]->  z24 z23 z22 z21 z20  
   // row2[5]  row2[4]  row2[3]  row2[2]  row3[1]->  z19 z18 z17 z16 z15  
   // row3[5]  row3[4]  row3[3]  row3[2]  row3[1]->  z14 z13 z12 z11 z10
   // row4[5]  row4[4]  row4[3]  row4[2]  row4[1]->  z9 z8 z7 z6 z5
   // row5[5]  row5[4]  row5[3]  row5[2]  row5[1]->  z4 z3 z2 z1 z0  
   //In the sobel module, they will be wired like above.
   //Each pixel is in grey scale so 8 bits.
   
   
   //Matrix is like this in matrix form:
   // row1[5]  row1[4]  row1[3]  ->  z8 z7 z6  
   // row2[5]  row2[4]  row2[3]  ->  z5 z4 z3
   // row3[5]  row3[4]  row3[3]  ->  z2 z1 z0
   //In the sobel module, they will be wired like above.
   //Each pixel is in grey scale so 8 bits.
endmodule