.data
#define the string datas
Pa: 		.asciiz  "input a: "
Pb:		.asciiz  "input b: "
Pc:		.asciiz  "input c: "
Presult:		.asciiz  "result =  "

.text
_Start:
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	
	li $v0, 4		#  printf("input a:");
	la $a0, Pa
	syscall
	
	li $v0, 5		# read integer a
	syscall
	move $s0, $v0		#store integer into the the register
	
	li $v0, 4		#  printf("input b:");
	la $a0, Pb
	syscall
	
	li $v0, 5		#read integer b
	syscall
	move $s1, $v0		#store integer into the register
	
	li $v0, 4		#  printf("input c:");
	la $a0, Pc
	syscall 
	
	li $v0, 5		#read integer c
	syscall
	move $s2, $v0		#store integer into the register
	
	move $a0, $s0		#store a into the argument
	move $a1, $s2		#store c into the argument
	jal _madd
	
	move $a0, $s1		#move b, into the abs_sub  arguments
	move $a1, $s4
	jal abs_sub

	move $s3, $v0		#d = abs_sub(b, madd(a, c));
	
	li $v0, 4		#print "the result = "
	la $a0, Presult
	syscall 
	
	li $v0, 1		#print d
	la $a0, ($s3)
	syscall
	
	j _exit			#exit the program
	
abs_sub: 	#a0 = x, a1 = y
	sub $t0, $a0, $a1
	addi $v0, $t0, 0

	jr $ra
		
_madd:	#t0 = x = large , t1 = y = small,  t4 = a while the loop in _madd
	addi $sp, $sp, -4      # adjust stack for 1 item    
	sw   $s4, 0($sp)       # save $s4
	add  $s4, $0, $0	# ans = 0
	
	slt $t2, $a0, $a1	#if  x < y, $t2 = 1 , else $t2 = 0
	beq $t2, $0, small	#if x >= y, $t2 = 0, goto _large
	move $t0, $a0		# x < y, then small= x
	j int_large	
small:	move $t0, $a1		# small = y

int_large:	
	slt $t3, $a0, $a1	#if x < y , $t3=1
	beq $t3, $0, large	#if x > = y, goto large
	move $t1, $a1		#x<y, large = y
	j Loop
large:	move $t1, $a0		#large = x		

Loop:	sge $t4, $t1, $t0	#while large>=small, $t4 = 1
	beq $t4, $0, L1		#if large<small, break
	add $s4, $s4, $t0	#ans = ans + small
	addi $t1, $t1, -1	#large = large - 1
	j Loop
	
L1:	lw $s4, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
_exit: 
	li $v0, 10
	syscall 
