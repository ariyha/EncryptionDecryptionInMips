.data 
space2: .asciiz " "
space: .asciiz "\n"
fin: .asciiz "out.bmp"
buffer: .space 786489
str: .space 2048
length: .space 2
str2: .space 256

.text

li $v0,13
la $a0,fin
li $a1,0
li $a2,0
syscall
move $s6,$v0

li $v0,14
la $a1,buffer
move $a0,$s6
li $a2,786486
syscall

la $s1,buffer  #buffer in s1
addi $s1,$s1,54

li $s2,0
lbu $s2,($s1)

addi $s1,$s1,1

la $t9,length
sb $s2,($t9)

mul $s2,$s2,8

li $t7,2
li $t4,49
li $t5,48

la $t1,str

readloop: beq $s2,$0,completeread

	
	lbu $s3,($s1)
	
	div $s3,$t7
	mfhi $t8

	
	beq $t8,0,readzero
		sb $t4,($t1)
		j afterread
readzero: sb $t5,($t1)
afterread: 
	addi $t1,$t1,1
	addi $s1,$s1,1
	subi $s2,$s2,1
	j readloop
	
completeread:

la $a0,space
li $v0,4
syscall

la $a0,str
li $v0,4
syscall 



la $t0,str
la $t1,str2

la $t9,length
lbu $t9,($t9)

li $s0,48
li $s1,49

 convert: 
 	li $t2,8
 	li $t3,0
 
 binary: 
 	lbu $s3,($t0)
 	beq $s3,$s1,one
 		sll $t3,$t3,1
 		j afterone
 	one:
 		sll $t3,$t3,1
 		addi $t3,$t3,1
 	
 	afterone:
 	addi $t0,$t0,1
 	subi $t2,$t2,1
 	
 	bgt $t2,$0,binary
 	
 	subi $t9,$t9,1
 	sb $t3,($t1)
 	addi $t1,$t1,1
 	
 	 bgt $t9,$0,convert 	
 	
la $a0,space
li $v0,4
syscall
 
la $a0,str2
li $v0,4
syscall 


exit: li $v0,10
 syscall
