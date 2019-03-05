`timescale 1ns / 1ps
module ROM (Addr,Data_output);
    input [11:0] Addr;
    output wire [31:0] Data_output;
    reg [31:0] mem [2**10-1:0];
    wire [11:0]index;

    assign index = Addr[11:2];
    assign Data_output = mem[Addr[11:2]];

    initial begin

        $readmemh("/home/sizheree/workspace/Computer_Orgnization_EXP/mips-fpga/hexcode/r_hex.dat",mem);
    end

endmodule