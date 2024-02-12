.data 
space2: .asciiz " "
outbuffer: .space 786489
header: .space 54
fin: .asciiz "prowler.bmp"
fout: .asciiz "out.bmp"
str: .asciiz "hello we are grp 2"
length: .byte 18
str2: .space 300
space: .asciiz "\n"

.text
li   $v0, 13       # system call for open file
la   $a0, fin   #read file name
li   $a1, 0       # Open for writing (flags are 0: read, 1: write)
li   $a2, 0        # mode is ignored
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor 

li $v0,14
move $a0,$s6
la $a1,header
li $a2,54
syscall 



li   $v0, 13       # system call for open file
la   $a0, fout     # output file name
li   $a1, 1       # Open for writing (flags are 0: read, 1: write)
li   $a2, 0        # mode is ignored
syscall            # open a file (file descriptor returned in $v0)
move $s7, $v0      # save the file descriptor for fout

la $s2,header
la $s1,outbuffer
li $s3,54

headerloop: beq $s3,$0,stringconvert
	lbu $s4,($s2)
	sb $s4,($s1)
	
	addi $s2,$s2,1
	addi $s1,$s1,1
	subi $s3,$s3,1
	
	j headerloop

stringconvert:

	la $t0,str
	la $t1,str2
	la $s0,length #length of string
	lbu $s0,($s0)
	li $t2,0


	
converter: beq $s0,$0,writepart
	li $t4,7
	lb $t3,0($t0)

binarypart:
	sll $t5,$t3,24
	srl $t5,$t5,31

	beq $t5,$0,addzero
		li $t9,49
		sb $t9,($t1)
		j binaryconv
	addzero:
		li $t9,48
		sb $t9,($t1)
	
	binaryconv:
	move $a0,$t5
	li $v0,1
	syscall
	
	addi $t1,$t1,1
	addi $t2,$t2,1

	sll $t3,$t3,1
	subi $t4,$t4,1

	bge $t4,$0,binarypart

	addi $t0,$t0,1
	subi $s0,$s0,1
	j converter

writepart:
	la $a0,space
	li $v0,4
	syscall	
	
	la $t1,str2
	la $s0,length
	la $s1,outbuffer
	addi $s1,$s1,54
	li $s3, 786431
	lbu $s0,($s0)
	li $t5,8
	mult $s0,$t5
	mflo $s4
	

	sb $s0,($s1)
	
	addi $s1,$s1,1
	
writeloop: beq $s4,$0,randomwrite
	
	li $t6,2
	li $a1,240
	li $v0,42
	syscall
	
	move $s5,$a0 #s5 has random
	
	lbu $s2,($t1)
	div $s2,$t6
	mfhi $s2
	div $s5,$t6
	mfhi $t5
	beq $s2,$t5,writeinimg
		addi $s5,$s5,1
writeinimg:
	la $a0,space2
	li $v0,4
	syscall	
	
	move $a0,$s5
	li $v0,1
	syscall 
	
	sb $s5,($s1)
	
	addi $t1,$t1,1
	addi $s1,$s1,1
	subi $s4,$s4,1
	subi $s3,$s3,1
	
	j writeloop
	
randomwrite: beq $s3,$0,end
	
	li $a1,255
	li $v0,42
	syscall
	
	move $s5,$a0
	

	sb $s5,($s1)
	
	addi $s1,$s1,1
	subi $s3,$s3,1
	
	j randomwrite

end:

li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor 
la   $a1, outbuffer   # address of buffer from which to write
li   $a2, 786489       # hardcoded buffer length
syscall   

la $a0,space
li $v0,4
syscall

la $a0,str2
li $v0,4
syscall



li $v0,10
syscall
