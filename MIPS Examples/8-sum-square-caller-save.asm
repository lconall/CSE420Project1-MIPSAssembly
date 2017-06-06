#  *** Caller Save Convention ***
#  Caller assumes that callee can change any register
#  Therefore, it needs to save any register that it will need across function call.
#  The caller does not need to save any registers at the begining of the function
#  and restore them back at the end of the function.
#
#  It is as if there are no "s" registers.... only "t" registers.
#
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
strResult:	 .asciiz "Result is " 
strCR:		 .asciiz "\n" 

.text
		.globl main
main:
		# STEP 1 -- get the first operand
		# Print a prompt asking user for input
		li $v0, 4   			# syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptFirst      	# "load address" of the string
		syscall     			# actually print the string  

		# Now read in the first operand 
		li $v0, 5      			# syscall number 5 will read an int
		syscall        			# actually read the int
		move $s0, $v0  			# save result in $s0 for later

		# STEP 2 -- repeat above steps to get the second operand
		# First print the prompt
		li $v0, 4      			# syscall number 4 will print string whose address is in $a0   
		la $a0, strPromptSecond      	# "load address" of the string
		syscall        			# actually print the string

		# Now read in the second operand 
		li $v0, 5      			# syscall number 5 will read an int
		syscall        			# actually read the int
		move $s1, $v0 			 # save result in $s1 for later

		move $a0, $s0
		move $a1, $s1
		jal sumSquare
		move $s2, $v0

		# STEP 3 -- print the result
                # First print the string prelude  
		li $v0, 4      			# syscall number 4 -- print string
	        la $a0, strResult   
	        la $a0, strResult   
	        syscall        			# actually print the string   
	        # Then print the actual sum
	        li $v0, 1         		# syscall number 1 -- print int
	        move $a0, $s2     		# print $s2
	        syscall           		# actually print the int
		# Finally print a carriage return
		li $v0, 4      			# syscall for print string
	        la $a0, strCR  			# address of string with a carriage return
	        syscall        			# actually print the string

		# STEP 5 -- exit
		li $v0, 10  			# Syscall number 10 is to terminate the program
		syscall     			# exit now


		# Function returns x*x + y
		# Initially, a0 = x, a1 = y
sumSquare:	add  $sp, $sp, -8
		sw   $ra, 0($sp)		# $ra is needed later. Save it on stack.
	
		move $s0, $a1		
		move $a1, $a0			# a1 = a0 = x
		jal mult			# v0 = x*x
		add $v0, $v0, $s0		# x*x + y
		
		lw $ra, 0($sp)			# $ra is used across the function call. Restore back.
		add $sp, $sp, 8
		jr $ra

		# Multiply x*y 
mult:		add  $sp, $sp, -20	
		sw   $ra, 0($sp)		# $ra is needed later. Save it on stack.
		li   $t1, 0
		li   $s1, 0
		move $t0, $a1			# $t0 = y = $a1
		move $a1, $a0			# $a1 = x
	
Loop:		bge  $t1, $t0, LoopExit		# compare iterator with y
		move $a0, $s1
		jal  addFn
		move $s1, $v0
		add  $t1, $t1, 1
		j    Loop

LoopExit:	move $v0, $s1
		lw $ra, 0($sp)
		add $sp, $sp, 20
		jr $ra

				
addFn:		add $v0, $a0, $a1
		jr $ra
