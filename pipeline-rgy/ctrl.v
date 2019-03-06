module ctrl(
	input wire				clr,
	input wire              stall_id,
	input wire              stall_ex,
	output reg[5:0]         stall       
	
);

	always @ (*) begin
		if(clr == 1) begin
			stall <= 6'b000000;
		end else if(stall_ex == 1) begin
			stall <= 6'b001111;
		end else if(stall_id == 1) begin
			stall <= 6'b000111;			
		end else begin
			stall <= 6'b000000;
		end    //if
	end      //always
			

endmodule