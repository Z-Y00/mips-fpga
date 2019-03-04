`timescale 1ns / 1ps

module RegFile(R1_in, R2_in, W_in, Din, WE, clk, R1_out, R2_out);
    parameter WIDTH=32;     //Ĭ��λ��Ϊ32
    input [4:0] R1_in;      //��Ҫ��ȡ�ļĴ���A���
    input [4:0] R2_in;      //��Ҫ��ȡ�ļĴ���B���
    input [4:0] W_in;       //��Ҫд��ļĴ������
    input [WIDTH-1:0] Din;  //��Ҫд���ֵ
    input WE,clk;   //ʹ�ܶ˺�ʱ���ź�
    output [WIDTH-1:0] R1_out;  //�Ĵ���A��ֵ
    output [WIDTH-1:0] R2_out;  //�Ĵ���B��ֵ

    reg [WIDTH-1:0]Reg[31:0];       //�Ĵ����ļ��飨32���Ĵ�����
    integer i;
    initial begin       //�Ĵ���ֵ��ʼΪ0
        for(i=0; i<32; i=i+1) Reg[i]=0;
    end

    always @(posedge clk) begin
        if(WE)  Reg[W_in] = Din;
    end

    assign R1_out = Reg[R1_in];
    assign R2_out = Reg[R2_in];
endmodule
