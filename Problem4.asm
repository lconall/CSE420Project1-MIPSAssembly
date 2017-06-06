# Title: Project 1 Problem 4					Filename: CSE420Project1Problem1.asm
# Author1: Levi Conall <l.conall@asu.edu> 			Date: 06/02/2017
# Description:  This program prompts the user for two inputs.  It then takes two user inputs i and x 
#		and uses a recursive function called compute to compute a return value which is finally 
#		printed to the screen. 
# Input: int i, int x
# Output: "compute(i,x) = %d", result

################# Data segment #####################
.data
	strPrompt:	 .asciiz "Please enter integer values for i and x. \n" 
	strPromptI:	 .asciiz "i = " 
	strPromptX:	 .asciiz "x = " 
	
	strComputeIX: 	 .asciiz "compute(i,x) = "
	
	strCR:		 .asciiz "\n" 
################# Code segment #####################
.text 
.globl main 

main:	
	
	# --- START Program prompt ---
	li $v0, 4		# syscall #4 - print string at address in $a0      
	la $a0, strPrompt      	# "load address" of the string
	syscall    		# Print the string
	# --- END Program prompt ---

	# --- START Prompt and read in integer i from user ---
	li $v0, 4   		# syscall #4 - print string at address in $a0        
	la $a0, strPromptI      # "load address" of the string
	syscall     		# Print the string
	li $v0, 5      		# syscall #5 - read an integer
	syscall        		# Read the integer
	move $t0, $v0  		# Save i into register $t0
	# --- END Prompt and read in integer i from user ---
	
	
	# --- START Prompt and read in integer x from user ---
	li $v0, 4   		# syscall #4 - print string at address in $a0        
	la $a0, strPromptX      # "load address" of the string
	syscall     		# Print the string
	li $v0, 5      		# syscall number 5 will read an int
	syscall        		# actually read the int
	move $t1, $v0  		# Save x into register $t1
	# --- END Prompt and read in integer x from user ---
	
	
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, strCR      	# "load address" of the string
	syscall     		# Print the string
	
	# --- START Call compute (i, x) ---
	move $a0, $t0 		# $a0 = $t0 = i
	move $a1, $t1		# $a1 = $t1 = x
	jal compute		# Call compute (i, x)
	move $t0, $v0 # $t0 = compute(i,x) result
	# --- END Call compute (i, x) ---
	
	# --- START Print "compute(i,x) = %d", result ---
	li $v0, 4   		# syscall #4 - print string at address in $a0      
	la $a0, strComputeIX    # "load address" of the string
	syscall     		# Print the string
	li $v0, 1		# syscall #1 - print integer
	move $a0, $t0		# set $a0 = compute(i, x) result
	syscall  		# print integer
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, strCR      	# "load address" of the string
	syscall     		# Print the string 
	# --- END Print "compute(i,x) = %d", result ---
	
	
ExitProgram: 
	li $v0, 10
	syscall 



compute:
	# --- START Save return address --- 
	addi $sp, $sp, -4		# Decrement stack pointer
	sw $ra, ($sp)			# Store $ra
	# --- END Save return address --- 
		
	# --- START if (x > 0) ---
	if:	ble $a1, $zero, elseif	# branch if x == 0
		addi $t0, $a1, -1	# $t0 = x - 1
		move $a1, $t0		# $a1 = $t0 [i.e. $a1 = x - 1]
		jal compute		# recursively call compute
		
		addi $v0, $v0, 1	# $v0 = compute(i, x-1) + 1
		
		j continue
	# --- END if (x > 0) --- 
	# --- START elseif (i > 0) ---
	elseif: ble $a0, $zero, else 
		addi $t0, $a0, -1	# $t0 = i - 1
		move $a0, $t0		# set parameter i = i - 1
		move $a1, $t0		# set parameter x = i - 1
		jal compute		# recursively call compute
		
		addi $v0, $v0, 5	# $v0 = compute(i, x-1) + 5
		
		j continue
	# --- END elseif (i > 0) ---
	# --- START else ---
	else: 
		li $v0, 1		# return 1
		j continue	
	# --- END else ---
	
	continue: 
	
	# --- START Load return address ---		
	lw $ra, ($sp)			# Load the return address from the stack
	addi $sp, $sp, 4		# Restore the stack pointer
	# --- END Load return address ---	
	
	jr $ra 				# Return from function
