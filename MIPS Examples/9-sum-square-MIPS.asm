#
#  Author: Aviral Shrivastava
#  Email: Aviral.Shrivastava@asu.edu
#  Course: CSE 230
# 
#  *** MIPS Calling Convention ***
#  s registers are preserved across function calls. If callee want to use them, their values need to be saved and restored. Caller does not worry about s registers.
#  t registers are not preserved across function calls. So callee can modify it without storing/restoring. 
#  However, it caller needs to use a t register then it can store and restore that temporary register across function call.
#
#  We try this convention on the following program
#
#  int sumSquare(int x, int y) {
#    return mult(x,x)+ y;
#  }
#
#  int mult (x,y) {
#    int t=0;
#    for (i=0; i<y; i++)
#       t = addFn(t,x);
#    return t;
#  }
#

.data

strPromptFirst:	 .asciiz "Enter the first operand: " 
strPromptSecond: .asciiz "Enter the second operand: " 
strResult:	 .asciiz "Result is: " 
strCR:		 .asciiz "\n" 

.text
		.globl main

main:		
		# STEP 1 -- get the first operand
		# Print a prompt asking user for input
		li $v0, 4   			# syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptFirst   	# "load address" of the string
		syscall     			# actually print the string  

		# Now read in the first operand 
		li $v0, 5      			# syscall number 5 will read an int
		syscall        			# actually read the int
		move $t0, $v0  			# save result in $s0 for later

		# STEP 2 -- repeat above steps to get the second operand
		# First print the prompt
		li $v0, 4      			# syscall number 4 will print string whose address is in $a0   
		la $a0, strPromptSecond      	# "load address" of the string
		syscall        			# actually print the string

		# Now read in the second operand 
		li $v0, 5      			# syscall number 5 will read an int
		syscall        			# actually read the int
		move $t1, $v0  			# save result in $s1 for later

		move $a0, $t0
		move $a1, $t1
		jal sumSquare
		move $t2, $v0

		# STEP 3 -- print the result
                # First print the string prelude  
		li $v0, 4      			# syscall number 4 -- print string
	        la $a0, strResult   
	        la $a0, strResult   
	        syscall       			# actually print the string   
	        # Then print the actual sum
	        li $v0, 1         		# syscall number 1 -- print int
	        move $a0, $t2     		# print $s2
	        syscall           		# actually print the int
		# Finally print a carriage return
		li $v0, 4      			# syscall for print string
	        la $a0, strCR  			# address of string with a carriage return
	        syscall        			# actually print the string

		# STEP 5 -- exit
		li $v0, 10  			# Syscall number 10 is to terminate the program
		syscall     			# exit now

sumSquare:	add  $sp, $sp, -8
		sw   $ra, 0($sp)

		move $t0, $a1		
		move $a1, $a0
		jal  mult
		add  $v0, $v0, $t0
		
		lw   $ra, 0($sp)
		add  $sp, $sp, 8
		jr   $ra

		
mult:		add  $sp, $sp, -20
		sw   $ra, 0($sp)
		sw   $s0, 4($sp)		# $s0 and $s1 can be used across by caller function sumSquare. 
		sw   $s1, 8($sp)		# Save and restore.
		
		li   $s0, 0
		li   $s1, 0
		move $s2, $a1			# $t1 = $a1 = y
		move $a1, $a0			# $a1 = x
	
Loop:		bge  $s0, $s2, LoopExit		# compare loop iterator with y
		move $a0, $s1

		sw   $a0, 12($sp)		# Save and restore $a0 (i.e. sum t).
		sw   $a1, 16($sp)		# Save and restore $a1 (i.e. x).
		jal  addFn
		lw   $a0, 12($sp)
		lw   $a1, 16($sp)
		move $s1, $v0
		add  $s0, $s0, 1
		j Loop

LoopExit:	move $v0, $s1
		lw   $ra, 0($sp)
		lw   $s0, 4($sp)
		lw   $s1, 8($sp)
		add  $sp, $sp, 20
		jr   $ra

				
addFn:		add  $v0, $a0, $a1
		jr   $ra

  
