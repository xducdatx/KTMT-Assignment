#Chuong trinh: Convert Dec to Bin and Hex
#Data segment
		.data
#Cac dinh nghia bien
nl:		.asciiz "\n"
char0:		.byte  '0'
binaryResult:	.asciiz	"Ket qua he 2:  "
hexResult:   	.asciiz "Ket qua he 16: "
decResult:   	.asciiz "Ket qua he 10: "
hexDigit:   	.asciiz "0123456789ABCDEF"
fileName:	.asciiz "C:/Users/datph/Downloads/test/SO_BDH.TXT"	# Dia chi cua file can luu ket qua
dec: 		.space 5
obuf:     	.space 100
obufe:
#Cac cau nhac nhap du lieu

#Code segment
		.text
#----------------------------------- 
# Chuong trinh chinh 
#----------------------------------- 
main:	
#Xu ly
	# open file to write
    	li 	$v0,13           	# open_file syscall code = 13
    	la 	$a0,fileName     	# get the file name
    	li 	$a1,1           	# file flag = write (1)
    	syscall
    	move 	$s1,$v0        		# save the file descriptor. $s0 = file

	# set time
	li	$v0, 40			# get time in milliseconds (as a 64-bit value)
	syscall

	# seed the random generator (just once)
	li 	$v0, 30
	syscall
	
	# random generator

	li 	$a0, 1
	li 	$a1, 65535 
	li 	$v0, 42
	syscall
	
	add 	$s0, $a0, $zero

	# output original in dec
	# output string
	li      $v0,15
	move	$a0, $s1
	la	$a1, decResult
	li 	$a2, 15
	syscall
	
	# output the number
	move 	$a0, $s0
	la 	$a1, dec
	jal 	int2str
	
	slti	$t0, $s0, 10
	beq	$t0, 1, Xuli10
	
	slti	$t0, $s0, 100
	beq	$t0, 1, Xuli100
	
	slti	$t0, $s0, 1000
	beq	$t0, 1, Xuli1000
	
	slti	$t0, $s0, 10000
	beq 	$t0, 1, Xuli10000
	
	Tieptuc:
	li      $v0,15
	move	$a0, $s1
	la	$a1, dec
	li 	$a2, 5
	syscall
	
	#in dec ra man hinh de kiem tra
	li	$v0, 4
	la	$a0, decResult
	syscall
	
	la	$a0, dec
	syscall
	
	la	$a0, nl
	syscall
	
	# output newline
	li      $v0,15
	move	$a0, $s1
	la	$a1, nl
	li 	$a2, 1
	syscall
	# output original in hex
	li      $a1,16
	jal     prthex
	# output original in binary
	li      $a1, 16
	jal     prtbin

	# close file to update information 
    	li	$v0,16         		# close_file syscall code
    	move	$a0,$s1      		# file descriptor to close
    	syscall
    	
# ket thuc chuong trinh
	li      $v0,10
	syscall
	
	# prtbin -- print in binary
	#
	# arguments:
	#   a0 -- output string
	#   a1 -- number of bits to output
	prtbin:
	li      $a2,1                   # bit width of number base digit
	j       prtany

	# prthex -- print in hex
	#
	# arguments:
	#   a0 -- output string
	#   a1 -- number of bits to output
	prthex:
	li      $a2,4                   # bit width of number base digit
	j       prtany

	# prtany -- print in given number base
	#
	# arguments:
	#   a0 -- output string
	#   a1 -- number of bits to output
	#   a2 -- bit width of number base digit
	#   s0 -- number to print
	#
	# registers:
	#   t0 -- current digit value
	#   t5 -- current remaining number value
	#   t6 -- output pointer
	#   t7 -- mask for digit
	prtany:
	li      $t7,1
	sllv    $t7,$t7,$a2             # get mask + 1
	subu    $t7,$t7,1               # get mask for digit

	la      $t6,obufe               # point one past end of buffer
	subu    $t6,$t6,1               # point to last char in buffer
	sb      $zero,0($t6)            # store string EOS

	move    $t5,$s0                 # get number

	prtany_loop:
	and     $t0,$t5,$t7             # isolate digit
	lb      $t0,hexDigit($t0)       # get ascii digit

	subu    $t6,$t6,1               # move output pointer one left
	sb      $t0,0($t6)              # store into output buffer

  	srlv    $t5,$t5,$a2             # slide next number digit into lower bits
	sub     $a1,$a1,$a2             # bump down remaining bit count
	bgtz    $a1,prtany_loop         # more to do? if yes, loop

	# save result in file
	# output string 
	li      $v0,15
	move	$a0, $s1
	bne	$a2, 1, Process
	la	$a1, binaryResult
	li 	$a2, 14
	syscall
	
	# output the number
	li	$v0, 15
	move 	$a1, $t6
	syscall

	# output newline
	li      $v0,15
	move	$a0, $s1
	la	$a1, nl
	li 	$a2, 1
	syscall

	#in ket qua ra man hinh de kiem tra
	li	$v0, 4
	la	$a0, binaryResult
	syscall
	
	move	$a0, $t6
	syscall
	
	jr      $ra                     # return

	# save result in file
	Process:
	la	$a1, hexResult
	li 	$a2, 15
	syscall
	
	# output the number
	li	$v0, 15
	move 	$a1, $t6
	syscall

	# output newline
	li      $v0,15
	move	$a0, $s1
	la	$a1, nl
	li 	$a2, 1
	syscall
	
	# in ket qua ra man hinh de kiem tra
	li	$v0, 4
	la	$a0, hexResult
	syscall
	
	move	$a0, $t6
	syscall

	la	$a0, nl
	syscall

	jr      $ra			# return
	
	# Ham convert from int to string
	# inputs : $a0 -> integer to convert
	# $a1 -> address of string where converted number will be kept
	# outputs: none
	int2str:
	addi 	$sp, $sp, -4         	# to avoid headaches save $t- registers used in this procedure on stack
	sw  	$t0, ($sp)           	# so the values don't change in the caller. We used only $t0 here, so save that.
	bltz 	$a0, neg_num         	# is num < 0 ?
	j    	next0                	# else, goto 'next0'

	neg_num:                     	# body of "if num < 0:"
	li  	$t0, '-'
	sb  	$t0, ($a1)           	# *str = ASCII of '-' 
	addi	$a1, $a1, 1          	# str++
	li   	$t0, -1
	mul  	$a0, $a0, $t0        	# num *= -1

	next0:
	li  	$t0, -1
	addi	$sp, $sp, -4         	# make space on stack
	sw   	$t0, ($sp)           	# and save -1 (end of stack marker) on MIPS stack

	push_digits:
	blez	$a0, next1           	# num < 0? If yes, end loop (goto 'next1')
	li   	$t0, 10              	# else, body of while loop here
	div	$a0, $t0             	# do num / 10. LO = Quotient, HI = remainder
	mfhi 	$t0                  	# $t0 = num % 10
	mflo 	$a0                  	# num = num // 10  
	addi 	$sp, $sp, -4         	# make space on stack
	sw   	$t0, ($sp)           	# store num % 10 calculated above on it
	j    	push_digits          	# and loop

	next1:
	lw   	$t0, ($sp)           	# $t0 = pop off "digit" from MIPS stack
	addi 	$sp, $sp, 4          	# and 'restore' stack

	bltz 	$t0, neg_digit       	# if digit <= 0, goto neg_digit (i.e, num = 0)
	j   	pop_digits           	# else goto popping in a loop

	neg_digit:
	li   	$t0, '0'
	sb   	$t0, ($a1)           	# *str = ASCII of '0'
	addi 	$a1, $a1, 1          	# str++
	j    	next2                	# jump to next2

	pop_digits:
	bltz 	$t0, next2           	# if digit <= 0 goto next2 (end of loop)
	addi 	$t0, $t0, '0'        	# else, $t0 = ASCII of digit
	sb   	$t0, ($a1)           	# *str = ASCII of digit
	addi 	$a1, $a1, 1          	# str++
	lw   	$t0, ($sp)           	# digit = pop off from MIPS stack 
	addi 	$sp, $sp, 4          	# restore stack
	j    	pop_digits           	# and loop

	next2:
	sb  	$zero, ($a1)         	# *str = 0 (end of string marker)
	lw   	$t0, ($sp)           	# restore $t0 value before function was called
	addi 	$sp, $sp, 4          	# restore stack
	jr  	$ra                  	# jump to caller
	
	Xuli10:
	addi 	$t5, $zero, 0
	addi	$t6, $zero, 4
	
	fcond10:
	beq	$t5, $t6, exit10
	li      $v0,15
	move	$a0, $s1
	la	$a1, char0
	li 	$a2, 1
	syscall
	addi	$t5, $t5, 1
	j	fcond10
	
	exit10:
	j Tieptuc
	
	Xuli100:
	addi 	$t5, $zero, 0
	addi	$t6, $zero, 3
	
	fcond100:
	beq	$t5, $t6, exit100
	li      $v0,15
	move	$a0, $s1
	la	$a1, char0
	li 	$a2, 1
	syscall
	addi	$t5, $t5, 1
	j 	fcond100
	exit100:
	j Tieptuc
	
	Xuli1000:
	addi 	$t5, $zero, 0
	addi	$t6, $zero, 2
	
	fcond1000:
	beq	$t5, $t6, exit1000
	li      $v0,15
	move	$a0, $s1
	la	$a1, char0
	li 	$a2, 1
	syscall
	addi	$t5, $t5, 1
	j 	fcond1000
	
	exit1000:
	j Tieptuc
	
	Xuli10000:
	addi 	$t5, $zero, 0
	addi	$t6, $zero, 1
	
	fcond10000:
	beq	$t5, $t6, exit10000
	li      $v0,15
	move	$a0, $s1
	la	$a1, char0
	li 	$a2, 1
	syscall
	addi	$t5, $t5, 1
	j 	fcond10000
	
	exit10000:
	j Tieptuc

