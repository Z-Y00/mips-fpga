`timescale 1ns / 1ps

module ALU(
	input [31:0] x,
	input [31:0] y,
	input [3:0] aluop,
	input [4:0] shamt,
	output reg [31:0] res1,
	output reg equ
    );
 reg [31:0] res2;
always @(*)
	begin
	equ = (x == y);
	case(aluop)
	0:
	begin 
		res1 <= y << shamt;
		res2 <= 0;
	end
	1:
	begin 
		res1 <= $signed(y) >>> shamt;//有符号右移
		res2 <= 0;
	end
	2:
	begin 
		res1 <= y >> shamt;
		res2 <= 0;
	end
	3:
	begin 
		{res2, res1} <= x * y;
	end
	4:
	begin 
		res1 <= x / y;
		res2 <= x % y;
	end
	5:
	begin 
		res1 <= x + y;
		res2 <= 0;
	end
	6:
	begin 
		res1 <= x - y;
		res2 <= 0;
	end
	7:
	begin 
		res1 <= x & y;
		res2 <= 0;
	end
	8:
	begin 
		res1 <= x | y;
		res2 <= 0;
	end
	9:
	begin 
		res1 <= x ^ y;
		res2 <= 0;
	end
	10:
	begin 
		res1 <= ~(x | y);
		res2 <= 0;
	end
	11:
	begin 
		res1 <= ($signed(x) < $signed(y)) ? 1 : 0;
		res2 <= 0;
	end
	12:
	begin 
		res1 <= (x < y) ? 1 : 0;
		res2 <= 0;
	end
	default:
	begin 
		res1 <= 0;
		res2 <= 0;
	end
	endcase // aluop

end

endmodule
