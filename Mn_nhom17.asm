#Chuong trinh: In pho sao
# macro cho viec in ket qua 
.macro inKetQua($staraddress)
	addi	$s0, $zero, 0
    	addi	$s1, $zero, 40
    	forcondPrint:	
    	beq	$s0, $s1, endforPrint
    	
    	lb	$t1, $staraddress($s0)
    	li	$v0, 11
    	move	$a0, $t1
    	syscall
    	addi	$s0, $s0, 1
    	j	forcondPrint
    	
    	endforPrint:
    	
	li	$v0, 4         
	la	$a0, xuongdong    
	syscall  
.end_macro

# macro cho viec xu li du lieu trong moi ngoi sao
.macro XuliStar($staraddress, $charCompare, $charAlternative)
	addi	$s0, $zero, 0
	addi	$s1, $zero, 40
	
	fcond:
	beq	$s0, $s1, endfor
	#forbody
	lb	$t1, s($s0)
	lb	$t2, $charCompare
	beq	$t1, $t2, Process
	li	$t1, ' '
	sb	$t1, $staraddress($s0)		
	addi    $s0, $s0, 1
	j fcond
	
	Process:
	lb	$t1, $charAlternative
	sb	$t1, s($s0)	
	li	$t1, '*'
	sb 	$t1, $staraddress($s0)
	addi    $s0, $s0, 1
	j fcond
	
	endfor:
.end_macro
#Data segment
	.data
#Cac dinh nghia bien
star:	.space 40
star1:	.space 40
star2:	.space 40
star3:	.space 40
star4:	.space 40
star5:	.space 40
star6:	.space 40
star7:	.space 40
star8:	.space 40
star9:	.space 40
s:	.space 40
charCompare:	.space 1
charAlternative:.space 1
fileName:	.asciiz "C:/Users/PC/Downloads/BTL KTMT/STRING.txt"	# duong dan toi file "string.txt"
xuongdong:	.asciiz  "\n"
#Cac cau nhac nhap du lieu

#Code segment
	.text
#----------------------------------- 
# Chuong trinh chinh 
#----------------------------------- 
main:	
# Doc du lieu tu file
	li	$v0, 13		# open_file syscall code = 13
    	la	$a0, fileName   # get the file name
    	li	$a1, 0          # file flag = read (0)
    	syscall
    	move	$s0, $v0        # save the file descriptor. $s0 = file
	
	#read the file
	li	$v0, 14		# read_file syscall code = 14
	move	$a0, $s0	# file descriptor
	la	$a1, s  	# The buffer that holds the string of the WHOLE file
	la	$a2, 40		# hardcoded buffer length
	syscall
	
	# print whats in the file
	li	$v0, 4		# read_string syscall code = 4
	la	$a0, s
	syscall
	
	#Close the file
    	li	$v0, 16         # close_file syscall code
    	move	$a0, $s0      	# file descriptor to close
    	syscall
    	
#Xu ly
	# Quy uoc $t3 de luu gia tri vao charCompare de lay dung bien nay de so sanh gia tri, $t4 la bien dung de thay doi gia tri neu dieu kien so sanh dung
	# xu li star1
	li	$t3, '9'
	sb	$t3, charCompare
	li	$t4, '8'
	sb	$t4, charAlternative
	XuliStar(star1, charCompare,charAlternative)

	# xu li star2
	li 	$t3, '8'
	sb 	$t3, charCompare
	li	$t4, '7'
	sb 	$t4, charAlternative
	XuliStar(star2, charCompare,charAlternative)
	
	# xu li star3
	li	$t3, '7'
	sb	$t3, charCompare
	li 	$t4, '6'
	sb 	$t4, charAlternative
	XuliStar(star3, charCompare,charAlternative)

	# xu li star4
	li	$t3, '6'
	sb 	$t3, charCompare
	li 	$t4, '5'
	sb 	$t4, charAlternative
	XuliStar(star4, charCompare,charAlternative)
	
	# xu li star5
	li	$t3, '5'
	sb 	$t3, charCompare
	li	$t4, '4'
	sb	$t4, charAlternative
	XuliStar(star5, charCompare,charAlternative)
	
	# xu li star6
	li	$t3, '4'
	sb	$t3, charCompare
	li 	$t4, '3'
	sb	$t4, charAlternative
	XuliStar(star6, charCompare,charAlternative)
	
	# xu li star7
	li 	$t3, '3'
	sb	$t3, charCompare
	li	$t4, '2'
	sb	$t4, charAlternative
	XuliStar(star7, charCompare,charAlternative)
	
	# xu li star8
	li	$t3, '2'
	sb	$t3, charCompare
	li	$t4, '1'
	sb	$t4, charAlternative
	XuliStar(star8, charCompare,charAlternative)
	
	# xu li star9
	li 	$t3, '1'
	sb 	$t3, charCompare
	li 	$t4, '0'
	sb	$t4, charAlternative
	XuliStar(star9, charCompare,charAlternative)
#Xuat ket qua (syscall)
xuat_kq:	
        li $v0, 4
        la $a0, xuongdong 
        syscall
	inKetQua(star1)		#in star 1
	inKetQua(star2)		#in star 2
	inKetQua(star3)		#in star 3
	inKetQua(star4)		#in star 4
	inKetQua(star5)		#in star 5
	inKetQua(star6)		#in star 6
	inKetQua(star7)		#in star 7
	inKetQua(star8)		#in star 8
	inKetQua(star9)		#in star 9
#ket thuc chuong trinh (syscall)
	addiu	$v0,$zero,10
	syscall
