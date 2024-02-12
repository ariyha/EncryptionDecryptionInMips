        .data
check: .asciiz "hello"
space: .asciiz "\n"
og:   .asciiz "prowler.bmp"      # filename for output
key: .asciiz "key.bmp"
write: .asciiz "dencrypted.bmp"
ogbuffer: .space 786489
keybuffer: .space 786489
outbuffer: .space 786489


.text

  # Open (for reading) a file that does not exist
 

li   $v0, 13       # system call for open file
la   $a0, og     # output file name
li   $a1, 0       # Open for writing (flags are 0: read, 1: write)
li   $a2, 0        # mode is ignored
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor 


li $v0,14
move $a0,$s6
la $a1,ogbuffer
li $a2,786486
syscall 

li   $v0, 13       # system call for open file
la   $a0, key     # output file name
li   $a1, 0       # Open for writing (flags are 0: read, 1: write)
li   $a2, 0        # mode is ignored
syscall            # open a file (file descriptor returned in $v0)
move $s7, $v0      # save the file descriptor 


li $v0,14
move $a0,$s7
la $a1,keybuffer
li $a2,786486
syscall 


la $t0,ogbuffer
la $t1,keybuffer
la $t2,outbuffer

li $s0,54


headerloop: beq  $s0,$0,endheader
	lbu $s2,($t0)
	sb $s2,($t2)

	
	addi $t0,$t0,1
	addi $t1,$t1,1
	addi $t2,$t2,1
	
	subi $s0,$s0,1
	
	j headerloop
	
	
endheader: 
li $s0,786432

xorloop: beq $s0,$0,outwriter
	lbu $s2,($t0)
	lbu $s3,($t1)
	xor $s2,$s2,$s3

	
	sb $s2,($t2)
	
	addi $t0,$t0,1
	addi $t1,$t1,1
	addi $t2,$t2,1
	
	subi $s0,$s0,1
	
	j xorloop
#file stored in buffer

outwriter:
li   $v0, 13       # system call for open file
la   $a0, write     # output file name
li   $a1, 1       # Open for writing (flags are 0: read, 1: write)
li   $a2, 0        # mode is ignored
syscall            # open a file (file descriptor returned in $v0)
move $s7, $v0      # save the file descriptor 

li   $v0, 15       # system call for write to file
move $a0, $s7      # file descriptor 
la   $a1, outbuffer   # address of buffer from which to write
li   $a2, 786489       # hardcoded buffer length
syscall   


li $v0,10
syscall 



  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file


