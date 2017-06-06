#  *** Callee Save Convention ***
#  Caller assumes that callee cannot change any register, other than $v0 or $v1
#  Therefore, it does not need to save anything across a function call
#  But it must save all the registers that it uses at the begining of the function
#  and restore them at the end of the function.
#
#  It is as if there are no "t" registers.... only "s" registers.
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
		li   $v0, 4   			# syscall number 4 will print string whose address is in $a0       
		la   $a0, strPromptFirst      	# "load address" of the string
		syscall     			# actually print the string  

		# Now read in the first operand 
		li   $v0, 5      		# syscall number 5 will read an int
		syscall        			# actually read the int
		move $s0, $v0  			# save result in $s0 for later

		# STEP 2 -- repeat above steps to get the second operand
		# First print the prompt
		li   $v0, 4     		# syscall number 4 will print string whose address is in $a0   
		la   $a0, strPromptSecond     	# "load address" of the string
		syscall        			# actually print the string

		# Now read in the second operand 
		li   $v0, 5      		# syscall number 5 will read an int
		syscall        			# actually read the int
		move $s1, $v0  			# save result in $s1 for later use

		move $a0, $s0
		move $a1, $s1
		jal sumSquare
		move $s2, $v0

		# STEP 3 -- print the result
                # First print the string prelude  
		li   $v0, 4      		# syscall number 4 -- print string
	        la   $a0, strResult   
	        la   $a0, strResult   
	        syscall        			# actually print the string   
	        # Then print the actual sum
	        li   $v0, 1         		# syscall number 1 -- print int
	        move $a0, $s2     		# print $s2
	        syscall           		# actually print the int
		# Finally print a carriage return
		li   $v0, 4    			# syscall for print string
	        la   $a0, strCR			# address of string with a carriage return
	        syscall        			# actually print the string

		# STEP 5 -- exit
		li   $v0, 10  			# Syscall number 10 is to terminate the program
		syscall     			# exit now

sumSquare:	add  $sp, $sp, -8
		sw   $ra, 0($sp)
		sw   $a1, 4($sp)		# callee sumSquare saves $a1 for later use
		
		move $a1, $a0			# $a1 is modifed with value of $a0 (i.e. x)
		jal  mult			# mult(x,x)
		lw   $a1, 4($sp)		# Restore the value at the end
		add  $v0, $v0, $a1
		
		lw   $ra, 0($sp)
		add  $sp, $sp, 8		# Increase stack pointer
		jr   $ra

		
mult:		add $sp, $sp, -24		# Store all the register values at the beginning which will be modified by the function
		sw $ra, 0($sp)		
		sw $a0, 4($sp)
		sw $t1, 8($sp)
		sw $s1, 12($sp)
		sw $a1, 16($sp)
		sw $t2, 20($sp)
		
		li $t1, 0			# Clear $t1
		li $s1, 0			# Clear $s1
		add $t2, $0, $a1		# Store original value of $a1 (i.e. y)
		move $a1, $a0			# $a1 = $a0 = x
	
Loop:		bge $t1, $t2, LoopExit
		move $a0, $s1
		jal addFn
		move $s1, $v0
		add $t1, $t1, 1
		j Loop

LoopExit:	move $v0, $s1			# Restore original values at the end
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $t1, 8($sp)
		lw $s1, 12($sp)
		lw $a1, 16($sp)
		lw $t2, 20($sp)
		add $sp, $sp, 24
		jr $ra
		


addFn:		add $v0, $a0, $a1
		jr $ra
