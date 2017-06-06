###################
# The data segment
###################		
.data

# Create some null terminated strings to use
strPromptFirst:	 .asciiz "Enter a number: " 
strResult:	 .asciiz "Fact(n) is " 
strCR:		 .asciiz "\n" 


.text
		.globl main
main:
		# STEP 1 -- get the first operand
		# Print a prompt asking user for input
		li $v0, 4   		# syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptFirst  # "load address" of the string
		syscall     		# actually print the string  

		# Now read in the first operand 
		li $v0, 5      		# syscall number 5 will read an int
		syscall        		# read the int
		move $s0, $v0  		# save result in $s0 for later

		move $a0, $s0
		jal fact
		move $s1, $v0

		# STEP 3 -- print the sum
                # First print the string prelude  
		li $v0, 4      		# syscall number 4 -- print string
	        la $a0, strResult   
	        syscall        		# actually print the string   
	        # Then print the actual sum
	        li $v0, 1         	# syscall number 1 -- print int
	        move $a0, $s1   	# add our operands and put in $a0 for print
	        syscall           	# actually print the int
		# Finally print a carriage return
		li $v0, 4      		# syscall for print string
	        la $a0, strCR  		# address of string with a carriage return
	        syscall        		# actually print the string

		# STEP 5 -- exit
		li $v0, 10  		# Syscall number 10 is to terminate the program
		syscall     		# exit now


fact:		addi $sp, $sp, -12
		sw   $ra, 0($sp)
		
		bne  $a0, 1, rec
		li   $v0, 1
		lw   $ra, 0($sp)
		addi $sp, $sp, 12
		jr   $ra 
		
	rec:	sw   $a0, 4($sp)
		add  $a0, $a0, -1
		jal  fact
		lw   $a0, 4($sp)
		mult $v0, $a0
		mflo $v0

		lw $ra, 0($sp)
		addi $sp, $sp, 12
		jr $ra 