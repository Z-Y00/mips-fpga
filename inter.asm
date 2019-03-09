#############################################################
#�ж���ʾ���򣬼�����Ʋ��ԣ�����1�ż�������1ѭ����λ����
#�ж���ʾ���򣬼�����Ʋ��ԣ�����2�ż�������2ѭ����λ����
#���Ҳ���ʾ������ѭ������
#��ֻ���жϷ��������ʾ���򣬷����Ҽ���ж�Ƕ�ף�
#���ʱ��Ҫ���ǿ��жϣ����жϣ������ж���������������ָ��ʵ�֣���α����ֳ����ж���ָ����Ҫ��������
#############################################################
.text

addi $s6,$zero,8       #�жϺ�1,2,3   ��ͬ�жϺ���ʾֵ��һ��

addi $s4,$zero,8      #ѭ��������ʼֵ  
addi $s5,$zero,0       #�������ۼ�ֵ
###################################################################
#                �߼����ƣ�ÿ����λ4λ 
# ��ʾ����������ʾ0x00000016 0x00000106 0x00001006 0x00010006 ... 10000006  00000006 ����ѭ��6��
###################################################################
IntLoop0:
add $s0,$zero,$s6   

IntLeftShift0:       

sll $s0, $s0, 4  
or $s3,$s0,$s4
add    $a0,$0,$s3       #display $s0
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.   

bne $s0, $zero, IntLeftShift0
sub $s4,$s4,$s5      #ѭ�������ݼ�
bne $s4, $zero, IntLoop0

addi   $v0,$zero,10         # system call for exit
syscall                  # we are out of here. 

addi $s6,$zero,1       #�жϺ�1,2,3   ��ͬ�жϺ���ʾֵ��һ��

addi $s4,$zero,6      #ѭ��������ʼֵ  
addi $s5,$zero,1       #�������ۼ�ֵ
###################################################################
IntLoop:
addi $s0,$zero,1   

IntLeftShift:       

#RGY.store s0,s4

sll $s0, $s0, 4  
or $s3,$s0,$s4
add    $a0,$0,$s3       #display $s0
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.   

bne $s0, $zero, IntLeftShift
sub $s4,$s4,$s5      #ѭ�������ݼ�
bne $s4, $zero, IntLoop

addi   $v0,$zero,10         # system call for exit
syscall                  # we are out of here. 


addi $s6,$zero,2       #�жϺ�1,2,3   ��ͬ�жϺ���ʾֵ��һ��

addi $s4,$zero,6      #ѭ��������ʼֵ  
addi $s5,$zero,1       #�������ۼ�ֵ
###################################################################
#                �߼����ƣ�ÿ����λ4λ 
# ��ʾ����������ʾ0x00000016 0x00000106 0x00001006 0x00010006 ... 10000006  00000006 ����ѭ��6��
###################################################################
IntLoop1:
addi $s0,$zero,2  

IntLeftShift1:       

#RGY.store s0,s4

sll $s0, $s0, 4  
or $s3,$s0,$s4
add    $a0,$0,$s3       #display $s0
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.   

bne $s0, $zero, IntLeftShift1
sub $s4,$s4,$s5      #ѭ�������ݼ�
bne $s4, $zero, IntLoop1

addi   $v0,$zero,10         # system call for exit
syscall                  # we are out of here. 


addi $s6,$zero,3       #�жϺ�1,2,3   ��ͬ�жϺ���ʾֵ��һ��

addi $s4,$zero,6      #ѭ��������ʼֵ  
addi $s5,$zero,1       #�������ۼ�ֵ
###################################################################
#                �߼����ƣ�ÿ����λ4λ 
# ��ʾ����������ʾ0x00000016 0x00000106 0x00001006 0x00010006 ... 10000006  00000006 ����ѭ��6��
###################################################################
IntLoop2:
addi $s0,$zero,3

IntLeftShift2:       

#RGY.store s0,s4

sll $s0, $s0, 4  
or $s3,$s0,$s4
add    $a0,$0,$s3       #display $s0
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.   

bne $s0, $zero, IntLeftShift2
sub $s4,$s4,$s5      #ѭ�������ݼ�
bne $s4, $zero, IntLoop2

addi   $v0,$zero,10         # system call for exit
syscall                  # we are out of here. 


