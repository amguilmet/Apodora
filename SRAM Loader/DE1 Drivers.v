module driver_Hex(upperNibble, lowerNibble, value);
	output reg [6:0] upperNibble;
	output reg [6:0] lowerNibble;	
	input  [7:0] value;
	always @ (value) begin

		case(value[3:0])
			1:    lowerNibble<=7'b1111001;
			2:    lowerNibble<=7'b0100100;
			3:    lowerNibble<=7'b0110000;
			4:    lowerNibble<=7'b0011001;
			5:    lowerNibble<=7'b0010010;
			6:    lowerNibble<=7'b0000010;
			7:    lowerNibble<=7'b1111000;
			8:    lowerNibble<=7'b0000000;
			9:    lowerNibble<=7'b0011000;
			0:    lowerNibble<=7'b1000000;
			8'hA: lowerNibble<=7'b0001000;
			8'hB: lowerNibble<=7'b0000011;
			8'hC: lowerNibble<=7'b1000110;
			8'hD: lowerNibble<=7'b0100001;
			8'hE: lowerNibble<=7'b0000110;
			8'hF: lowerNibble<=7'b0001110;	
			//default: lowerNibble<=7'b1111111;
		endcase	
		case(value[7:4])
			1:    upperNibble<=7'b1111001;
			2:    upperNibble<=7'b0100100;
			3:    upperNibble<=7'b0110000;
			4:    upperNibble<=7'b0011001;
			5:    upperNibble<=7'b0010010;
			6:    upperNibble<=7'b0000010;
			7:    upperNibble<=7'b1111000;
			8:    upperNibble<=7'b0000000;
			9:    upperNibble<=7'b0011000;
			0:    upperNibble<=7'b1000000;
			8'hA: upperNibble<=7'b0001000;
			8'hB: upperNibble<=7'b0000011;
			8'hC: upperNibble<=7'b0100111;
			8'hD: upperNibble<=7'b0100001;
			8'hE: upperNibble<=7'b0000110;
			8'hF: upperNibble<=7'b0001110;	
			//default: upperNibble<=7'b1111111;
		endcase	
	end
		
endmodule
