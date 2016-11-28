/*
This is a just simple SRAM loader for a Terasic DE1 dev board

Hex displays show curent address byte on the left and data byte on the right

SW8 Down:  Read Mode - SW7-SW0 selects the SRAM address to read and SW4 performs the write
								
	   Up: Write Mode - SW7-SW0 selects the data. SW4 writes the data to the address shown on the left hex display.
							  SW3 Increments the address by one and SW2 decrements by one. SW1 will set the address to the SW7-SW0.
	
-To add: -Make SW2 increment address while in read mode -and- show SW7-SW0 on hex display when it changes
			-Serial connection to PC
			-Integration with Apodora

*/

module SRAMLoader(CLOCK_25, HEX3, HEX2, HEX1, HEX0, LEDG, LEDR, SW, KEY,
						SRAM_ADDR, SRAM_CE_N, SRAM_DQ, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N,
						GPIO_0, GPIO_1);

	//Clock Input
	input wire CLOCK_25;
	
	//Indicators
	output reg [7:0] LEDR;
	output reg [7:0] LEDG;
	
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;	
	
	//Registers	
	parameter param_AddressSpace = 8;
	parameter param_DataSize = 8;
	
	reg isPushed = 0;
	reg  [param_AddressSpace:0] r_addr = 0;
	reg  [param_DataSize:0] r_data = 0;	

	//Hex Displays	
	driver_Hex hexUpper(.upperNibble(HEX3),
							  .lowerNibble(HEX2),
							  .value( r_addr));
							  
	driver_Hex hexLower(.upperNibble(HEX1),
							  .lowerNibble(HEX0),
							  .value( r_data));

	//Inputs
	input wire [9:0] SW;
	reg [7:0] lastSW;
	input wire [3:0] KEY;
	
	//Debug IO
	output reg [7:0] GPIO_0;
	output reg [7:0] GPIO_1;	
	
	//Switch States
	parameter ss_Write =   4'b01;
	parameter ss_Read  =   4'b00;
	parameter ss_Unused =  4'b10;	
	parameter ss_Unused1 = 4'b11;	
	
	//Button States
	parameter bs_Write =	4'b0111;	
	parameter bs_Next =  4'b1011;	
	parameter bs_Prev = 	4'b1101;
	parameter bs_Addr = 	4'b1110;	
	
	parameter bs_Read = 	4'b0111;	
	
	parameter bs_Unpressed = 4'b1111;
	
	//Loader States
	reg [4:0] s_loader = 1;
	
	parameter ls_Idle = 1;
	parameter ls_Read = 2;
	parameter ls_Read2 = 4;	
	parameter ls_Write = 8;
	parameter ls_Write2 = 16;	

	//SRAM Interface 
	output reg [param_AddressSpace:0] SRAM_ADDR;
	inout reg [param_DataSize:0] SRAM_DQ;
	output reg SRAM_CE_N;
	output reg SRAM_OE_N;
	output reg SRAM_WE_N;
	output reg SRAM_LB_N;
	output reg SRAM_UB_N;
	
	parameter f_SRAMOffset = 18'b00_00000000_00000000;

	
	always @ (negedge CLOCK_25) begin	
		if(~isPushed) begin		
			case(SW[9:8])		
				//Switch modes here
				ss_Write:begin
					r_data <= SW[7:0];
					case(KEY)		
						bs_Addr: r_addr <= SW[7:0];					
						bs_Write: s_loader <= ls_Write;
						bs_Next: r_addr <= r_addr+1;
						bs_Prev: r_addr <= r_addr-1;
					endcase					
				end	
				
				ss_Read: begin
					//if (SW[7:0] == lastSW[7:0])
						r_addr <= SW[7:0];
					case(KEY)
						bs_Read: s_loader <= ls_Read;
						bs_Next: r_addr <= r_addr+1;
					endcase
				end
			endcase
			
			//if(lastSW[7:0] != SW[7:0]) begin
			//	lastSW[7:0] <= SW[7:0];
			//end
			
			if(KEY != bs_Unpressed) begin
				LEDG[0] <= 1; //Just so the push buttons can be checked, my dev board's buttons are horrible
				isPushed <= 1;
			end
		end else
			if(KEY == bs_Unpressed) begin
				isPushed <= 0;
				LEDG[0] <= 0;
			end						
			
		//Load/Write state machine
		case(s_loader)
			ls_Idle: ;
			ls_Read: begin
				SRAM_ADDR <= f_SRAMOffset | r_addr;
				SRAM_DQ <= 8'bZZZZ_ZZZZ;
				SRAM_CE_N <= 0;
				SRAM_OE_N <= 0;
				SRAM_LB_N <= 0;
				SRAM_UB_N <= 1;			
				SRAM_WE_N <= 1;
				s_loader <= ls_Read2;			
			end
			
			ls_Read2: begin
				r_data <= SRAM_DQ;
				SRAM_CE_N <= 1;
				SRAM_OE_N <= 1;
				SRAM_LB_N <= 0;
				SRAM_UB_N <= 1;	
				s_loader <= ls_Idle;
			end
		
			ls_Write: begin			
				SRAM_OE_N <= 1;
				SRAM_ADDR <= f_SRAMOffset | r_addr;		
				SRAM_DQ <= r_data;
				SRAM_CE_N <= 0;					
				SRAM_WE_N <= 0;					
				SRAM_LB_N <= 0;
				SRAM_UB_N <= 1;	
				s_loader <= ls_Write2;	
			end
				
			ls_Write2: begin
				SRAM_DQ <= 8'bZZZZ_ZZZZ;
				SRAM_CE_N <= 1;
				SRAM_WE_N <= 1;
				SRAM_LB_N <= 0;
				SRAM_UB_N <= 1;
				s_loader <= ls_Idle;
			end
		endcase
	end
endmodule


