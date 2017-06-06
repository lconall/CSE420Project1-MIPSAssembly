# Pointers
# 
# main()
# {
#    ---
#    int j, k;
#    ---
#    read j, k
#    ---
#    ---
#    chico (&j, k)
#    ---
#    print j
# }
#
# void chico (int *x, int y)
# {
#    *x = *x + ((y+2)<<2)
# }
#
###################
# The data segment
###################		
.data

# Create some null terminated strings to use
strPromptX:	 	.asciiz "Enter X:" 
strPromptY:	 	.asciiz "Enter Y:" 
strResult:		.asciiz "Result is " 
strCR:		 	.asciiz "\n" 


##########################################
# The text segment -- instructions go here
##########################################	
.text
		.globl main
main:

		add $sp, $sp, 4	# create space for 1 local variable

		# STEP 1 -- get X
		# Print a prompt asking user for input
		li $v0, 4   		# syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptX      # "load address" of the string
		syscall     		# print the string  

		# Now read in the first operand 
		li $v0, 5      		# syscall number 5 will read an int
		syscall        		# read the int (X)
		move $s0, $v0  		# save result in $s0 for later

		# STEP 2 -- get Y
		# Print a prompt asking user for input
		li $v0, 4   		# syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptY      # "load address" of the string
		syscall     		# print the string  

		# Now read in the first operand 
		li $v0, 5      		# syscall number 5 will read an int
		syscall        		# read the int (Y)
		move $s1, $v0  		# save result in $s0 for later

		sw $s0, 0($sp)		# need to save this in memory to create a pointer
		
		move $a0, $sp   	# pass the pointer
		move $a1, $s1

		jal chica		# call the function
		lw $s2, 0($sp)	

		# STEP 5 -- print the result
       		# First print the string prelude  
		li $v0, 4      		# syscall number 4 -- print string
	    	la $a0, strResult   
	    	syscall        		# actually print the string   
	    	# Then print the actual sum
	    	li $v0, 1         	# syscall number 1 -- print int
	    	move $a0, $s2  	  	# add our operands and put in $a0 for print
	    	syscall           	# actually print the int
		# Finally print a carriage return
		li $v0, 4     		# syscall for print string
	    	la $a0, strCR  		# address of string with a carriage return
	    	syscall        		# print the string
		       
		# STEP 5 -- exit
		li $v0, 10  		# Syscall number 10 is to terminate the program
		syscall     		# exit now


chica:		add $t0, $a1, 2
		sll $t0, $t0, 2
		
		lw $t1, 0($a0)		# load x
		add $t2, $t1, $t0
		sw $t2, 0($a0)
		
		jr $ra

