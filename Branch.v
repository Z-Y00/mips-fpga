`timescale 1ns / 1ps
//ģ�鹦��Ϊ��BNE��BEQ��BLEZ��BGTZ��BZһ��6������ת��ת�����źźϲ���һ��branch�źţ�����PC_dataģ������
//BZ�źŴ���BLTZ��BGEZ����ָ���ָ��OP��ͬ����Ϊ1������Ϊ��16��20λ��ͬ��BLTZΪ0��BGEZΪ1
module Branch(Bne,Beq,Blez,Bgtz,Bz,equal,CODE_16,rs_data,Branch_out);
    input Bne,Beq,Blez,Bgtz,Bz,equal,CODE_16;   //equalΪALU�ĵ�������źţ�CODE_16Ϊָ���16λ����������BLTZ��BGEZ�ź�
    input [31:0]rs_data;    //rs�Ĵ�����ֵ
    output Branch_out;  //��������ת�����ź�
    
    assign Branch_out = (Bne&(~equal)) | (Beq&equal) | (Blez&(rs_data[31]|(rs_data==0)))
                    | (Bgtz&(~rs_data[31])&(rs_data!=0)) | (Bz&(CODE_16&(~rs_data[31]) | ~CODE_16&rs_data[31]));
endmodule
