//File Name: BACKNED
// Type: Module
// Department : Electrical engineering
// Author: Sagar
//Author's Email ID: guptasagar19965@gmail.com
// Purpose:TEST
// Operation : TEST
// Date : 10 July 2023
// BACKEND DESIGN //
module backend( i_resetbAll,
		i_clk,
		i_sclk,
		i_sdin,
		i_vco_clk,
		o_ready,
		o_resetb1,
		o_gainA1,
		o_resetb2,
		o_gainA2,
		o_resetbvco,);
// INPUT OUTPUT REGISTERS DECLARATION //
    input i_resetbAll, i_clk, i_sclk, i_sdin, i_vco_clk;
	reg [4:0]data;
	integer i;
    output reg o_ready, o_resetb1, o_resetb2, o_resetbvco;
    output reg [1:0] o_gainA1;
    output reg [2:0] o_gainA2;
    reg [4:0] shiftreg;
    reg [4:0] shift2;
    reg [2:0] count; 
    //take serial data from i_sdin and read the data using shift register
    always @ ( posedge (i_sclk))
	
		  begin
					shift2= shiftreg>>1;
					shiftreg ={i_sdin, shift2[3:0]};
					count<=count+1;
			if (count==4)
				begin				
					o_gainA1[0]	<=	shiftreg[0];
					o_gainA1[1]	<=	shiftreg[1];
					o_gainA2[0]	<=	shiftreg[2];
					o_gainA2[1]	<=	shiftreg[3];
					o_gainA2[2]	<=	shiftreg[4];
				end
 
		   end	
	always@(posedge (i_clk) or negedge(i_resetbAll))
	begin
      if(i_resetbAll)  //when i_resetbAll=1, the starup sequence in initiated
	     begin
                for(i=0;i<5;i=i+1)         // store data in reg data 
	              begin
	                 @(posedge i_sclk);
		              data <= {data[4:1],i_sdin};
		          end
               repeat(2)                  // now we wait for two clock cycles
	             begin
		          @(posedge (i_clk) or negedge(i_resetbAll)) ;
	             end
	           o_resetbvco <=1;   // set o_resetbvco=1
	           repeat(10)        // wait for 10 clock cycles
	             begin
		           @(posedge (i_clk) or negedge(i_resetbAll)) ;
	              end
	            o_resetb1 <=1;// set o_resetb1=1
	            o_resetb2<=1;// set o_resetb2=1
	           repeat(10)    // wait for 10 clock cycles
	             begin
		           @(posedge (i_clk) or negedge(i_resetbAll)) ;
	             end
	            o_ready<=1;    // set o_ready=1
		 end
        else           // when  i_resetbAll=0 all  outputs of the backend should be pulled to zero
		  begin
           o_ready <= 0;
           o_resetb1 <= 0;
           o_resetb2 <= 0;
           o_resetbvco <= 0;
           o_gainA1[0] <= 0;
           o_gainA1[1] <= 0;
           o_gainA2[0] <= 0;
           o_gainA2[1] <= 0;
           o_gainA2[2] <= 0;
           shiftreg <=0;
	       shift2 <= 0;
           count <= 0;
           data <=0;
		   end
	end
//====================================================================================
endmodule