.data
str1:		.asciiz "Please select an integer number A from (0~10): "
str2:		.asciiz "A * 2 = "
str3:		.asciiz "******"
str4:		.asciiz "THE END"
Pnewline: 	.asciiz "\n"
.text

_Start:
	# Prompt the user to enter int
	la $a0, str1
	li $v0,4
	syscall
	         	
	# Get the int and store in $t0
	
  	li $v0,5
  	syscall
  	
  	addi $sp, $sp, -4 
	sw $v0, 0($sp)	  
	lw $t0, 0($sp)	 
  	  	
  	#if input = 0, goto _Exit
  	
  	beq $t0, $0, _Exit  	
  	
  	# If $t0 < 0 || $t0 > 10, goto _OutofRange
  	
  	slti $t2, $t0, 0 
  	slti $t3, $t0, 10
  	bne $t2, $0, goto_OutofRange
  	beq $t3, $0, goto_OutofRange
  		
  	
  	#If input =7, compute input * 2, and print out the answer.
	
	beq $t0, 7, L1
	
	L1:	la $a0, str2
		li $v0, 4
		syscall
				
		sll $t1,$t0,1		
		move $a0, $t1
		li $v0, 1
		syscall
	            
	goto_OutofRange:	
  	#After print out, go back to wait the user to enter number.
  	lw $v0, 0($sp)	 
	addi $sp, $sp, 4   
  	j   	_Start
  	
_function_others:
	#setup counter i
	# $s0 is i
	
	 move $s0, $zero
	 	 
	#Write a Loop for print ******
	Loop:
	
	#Check the input and the counter
	
	
		
	#End the loop and wait the user to enter number.
	
	bge  $s0, $t0, _Start

	# print out ******
	la $a0, str3
	li $v0,4
	syscall
	
	#print out the counter number
	             
	move $a0,$t0
	li $v0, 4
	syscall
	
	# print out ******
	             
	la $a0, str3
	li $v0,4
	syscall
	 
	
	# print out \n (´«¦æ)
	la $a0, Pnewline
	li $v0,4
	syscall
	
	#counter ++
	
	addi $t0, $t0, 1 
	
	#go back to the Loop
	j Loop                

#Stop the program
_Exit:
	#print out THE END
	la $a0, str4
  	li $v0,4
  	syscall
