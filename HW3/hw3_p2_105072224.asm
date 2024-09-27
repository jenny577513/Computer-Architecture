.data
#define the string datas
Pprinta: 		.asciiz  "input a: "
Pprintb:		.asciiz  "input b: "
Panswer:		.asciiz  "ans: "

.text

_Start: 		#$s0 = a, $s1 = b, $s2 = c $s3 = d
	addi $s0, $0, 0		#let a = 0 , b = 0, c = 0, d = 0
	addi $s1, $0, 0
	addi $s2, $0, 0
	addi $s3, $0, 0
	
	li $v0, 4		# print "input a: "
	la $a0, Pprinta
	syscall
	
	li $v0, 5		# read a, and  let $s0 = a
	syscall
	addi $s0, $v0, 0
	
	li $v0, 4		# print "input b: "
	la $a0, Pprintb
	syscall
	
	li $v0, 5		# read b, and  let $s1 = b
	syscall
	addi $s1, $v0, 0
	
	addi $a0, $s0, 0	#let the argument $a0 = a, $a1 = b
	jal _re			#goto the function _re
	
	add $s2, $v0, $0	# c = re(a)
	
	li $v0, 4		#print "ans: "
	la $a0, Panswer
	syscall
	
	li $v0, 1		# print c
	la $a0, ($s2)
	syscall
	
	addi $a0, $s1, 0	#let the argument $a0 = b $a1 = c
	addi $a1, $s2, 0
	jal _fn			#goto the function _fn
	
	li $v0, 4		#print "ans: "
	la $a0, Panswer
	syscall
	
	li $v0, 1		#print d
	la $a0, ($s3)
	syscall
	
	j _exit
	
_fn:	# $a0 = x, $a1  =y
	addi $sp, $sp, -16	#create a space for storeage
	sw $a0, 0($sp)		#save a0, a1, ra in memory
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
_test1:	slt $t0, $0, $a0	#if x > 0, $t0 = 1, x<= 0, $t0 = 0
	beq $t0, $0, _test2	#else
	
	addi $v0, $0, 0		#return 0 
	addi $sp, $sp, 16	# pop the stack for 4 items
	jr $ra
	
_test2:	slt $t1, $0, $a1	#if y > 0, $t1 = 1, y <=0 , $t1 = 0
	beq $t1, $0, _test3 	
	
	addi $v0, $0, 0		#return 0 
	addi $sp, $sp, 16	# pop the stack for 4 items
	jr $ra
	
_test3:	slt $t2, $a1, $a0	#if x > y  , $t2  =1
	beq $t2, 0, L1		
	
	addi $v0, $0, 2		#return 2
	addi $sp, $sp, 16	# pop the stack for 4 items
	jr $ra
	
L1:	addi $a0, $a0, -1	# a0 = (x-1)
	addi $a1, $a1, 0	# a1 = y
	jal _fn			# fn(x - 1, y)
	
	mul $v0, $v0, 3
	move $s0, $v0
	
	addi $a1, $a1, -1	# y-1
	jal _fn			# fn(x, y - 1)
	
	mul $v0, $v0, 2
	move $s1, $v0
	
	addi $a0, $a0, -1	# a0 = (x-1)
	addi $a1, $a1, -1	# a1 = (y-1)
	jal _fn			#fn(x - 1, y - 1)
	
	move $s2, $v0
	
	add $v0, $s0, $s1	# 3 * fn(x - 1, y) + 2 * fn(x, y - 1)
	add $v0, $v0, $s2	#3 * fn(x - 1, y) + 2 * fn(x, y - 1) + fn(x - 1, y - 1);
	
	lw $ra, 8($sp)
	lw $ra, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra
_re:	#$a2 = x = a, $t1 = reference
	addi $sp, $sp, -8
	sw $a2, 0($sp)
	sw $ra, 4($sp)
	#return (x >= 2) ? (x * x + x * re(x - 1) + (x - 1) * re(x - 2)) : ((x == 1) ? 1 : 0)
	
	slti $t0, $a2, 2	#x <2 , t0=1 , x>=2 , t0=0
	beq $t0, $0, _loop1	#t0=0, goto_loop1
	jal _loop2
	
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
_loop1:	mul $s0, $a2, $a2	# x*x
	
	addi $a2, $a2, -1	#x=x-1
	jal _re			# re(x - 1) 
	mul $v0, $v0, $a2	 #x * re(x - 1)
	move $s1, $v0
	
	addi $s2, $a2, -1	
	addi $a2, $a2, -2
	jal _re
	mul  $v0, $v0, $s2
	
	add $s0, $s0, $s1
	add $v0, $s0, $v0
	
	lw $a2, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8 
	add $v0, $v0, $a2	
	jr $ra
	
_loop2:	addi $t0, $0, 1
	beq $a2, $t0, L2
	addi $v0, $0, 0
	
L2:	move $v0, $t0
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
_exit:
	li $v0, 10
	syscall
