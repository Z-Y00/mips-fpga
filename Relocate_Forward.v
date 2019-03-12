`timescale 1ns / 1ps

module Relocate_Forward(OP, FUNC, WR_EX, WR_MEM, RegWrite_EX, RegWrite_MEM, R1_ID, R2_ID, JAL_EX, MEM2Reg_EX,
						Forward_R1, Forward_R2, Load_use, Reg_related);
	input [5:0] OP, FUNC;
	input [4:0] WR_EX, WR_MEM, R1_ID, R2_ID;
	input RegWrite_EX, RegWrite_MEM, JAL_EX, MEM2Reg_EX;

	output wire [1:0] Forward_R1, Forward_R2;
	output wire Load_use, Reg_related;

	wire R1_used, R2_used;

	assign R1_used = ~OP[0]&&~OP[1]&&~OP[4]&&~OP[5]&&~FUNC[0]&&~FUNC[2]&&~FUNC[3]&&~FUNC[4]&&FUNC[5] || ~OP[0]&&~OP[1]&&~OP[4]&&~OP[5]&&~FUNC[1]&&~FUNC[3]&&~FUNC[4]&&FUNC[5] || ~OP[0]&&~OP[1]&&~OP[4]&&~OP[5]&&~FUNC[0]&&~FUNC[1]&&FUNC[3]&&~FUNC[4]&&~FUNC[5] || ~OP[0]&&~OP[1]&&~OP[4]&&~OP[5]&&FUNC[1]&&~FUNC[2]&&FUNC[3]&&~FUNC[4]&&FUNC[5] || ~OP[0]&&~OP[1]&&~OP[4]&&~OP[5]&&FUNC[0]&&FUNC[2]&&~FUNC[3]&&~FUNC[4]&&FUNC[5] || ~OP[2]&&OP[3]&&~OP[4]&&~OP[5] || ~OP[0]&&~OP[1]&&OP[2]&&~OP[3]&&~OP[4] || ~OP[1]&&OP[2]&&~OP[4]&&~OP[5] || OP[0]&&OP[2]&&~OP[3]&&~OP[4]&&~OP[5] || OP[0]&&OP[1]&&~OP[2]&&~OP[4]&&OP[5];

	assign R2_used = ~OP[0]&&~OP[1]&&~OP[3]&&~OP[4]&&~OP[5]&&~FUNC[0]&&~FUNC[2]&&~FUNC[3]&&~FUNC[4] || ~OP[0]&&~OP[1]&&~OP[3]&&~OP[4]&&~OP[5]&&~FUNC[1]&&~FUNC[3]&&~FUNC[4]&&FUNC[5] || ~OP[0]&&~OP[1]&&~OP[3]&&~OP[4]&&~OP[5]&&~FUNC[0]&&~FUNC[1]&&FUNC[2]&&FUNC[3]&&~FUNC[4]&&~FUNC[5] || ~OP[0]&&~OP[1]&&~OP[3]&&~OP[4]&&~OP[5]&&FUNC[1]&&~FUNC[2]&&~FUNC[3]&&~FUNC[4]&&~FUNC[5] || ~OP[0]&&~OP[1]&&~OP[3]&&~OP[4]&&~OP[5]&&FUNC[1]&&~FUNC[2]&&FUNC[3]&&~FUNC[4]&&FUNC[5] || ~OP[0]&&~OP[1]&&~OP[3]&&~OP[4]&&~OP[5]&&FUNC[0]&&FUNC[2]&&~FUNC[3]&&~FUNC[4]&&FUNC[5] || ~OP[1]&&OP[2]&&~OP[3]&&~OP[4]&&~OP[5] || OP[0]&&OP[1]&&~OP[2]&&OP[3]&&~OP[4]&&OP[5];

	wire R1hit_EX, R1hit_MEM, R2hit_EX, R2hit_MEM;

	assign R1hit_EX = R1_ID == (RegWrite_EX? WR_EX:0);
	assign R1hit_MEM = R1_ID == (RegWrite_MEM? WR_MEM:0);
	assign R2hit_EX = R2_ID == (RegWrite_EX? WR_EX:0);
	assign R2hit_MEM = R2_ID == (RegWrite_MEM? WR_MEM:0);

	assign Forward_R1 = R1hit_EX ? (JAL_EX ? 3 : 1) : (R1hit_MEM ? 2 : 0);
	assign Forward_R2 = R2hit_EX ? (JAL_EX ? 3 : 1) : (R2hit_MEM ? 2 : 0);
	assign Load_use = (R1hit_EX || R2hit_EX) && MEM2Reg_EX;
	assign Reg_related = R1hit_EX || R1hit_MEM || R2hit_EX || R2hit_MEM;

endmodule