# Title: Project 1 Problem 4					Filename: CSE420Project1Problem1.asm
# Author1: Levi Conall <l.conall@asu.edu> 			Date: 06/02/2017
# Description: 	This program takes two user inputs u and v and calculates the value of the equation
#		3u^2 + 7uv - v^2 + 1 using three functions.  ComputeEquationResult calculates the value
#		of the equation using the defined functions Multiply and Square. ComputeEquationResult 
# 		could have been implemented in the main function directly, but for ease of reading it was
#		separated out into its own function so show just the calculations related to the equation. 
# Input: int u, int v
# Output: "3u^2 + 7uv - v^2 + 1 = %d", result 

################# Data segment #####################
.data
	strPrompt:	 .asciiz "Please enter integer values for u and v.\n" 
	strPromptU:	 .asciiz "u = " 
	strPromptV:	 .asciiz "v = " 
	
	strResult: 	 .asciiz "3u^2 + 7uv - v^2 + 1 = "
	
	strCR:		 .asciiz "\n" 
################# Code segment #####################
.text 
.globl main 

main:	
	# --- START Program prompt ---
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, strPrompt      	# "load address" of the string
	syscall     		# Print the string
	# --- END Program prompt ---
	
	
	# --- START Prompt and read integer u from user --- 
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, strPromptU      # "load address" of the string
	syscall     		# Print the string
	li $v0, 5      		# syscall #5 - read an integer
	syscall        		# Read the integer
	move $t0, $v0  		# Save u into register $t0
	# --- END Prompt and read integer u from user --- 
	
	
	# --- START Prompt and read integer v from user --- 
	li $v0, 4   		# syscall #4 - print string at address in $a0      
	la $a0, strPromptV      # "load address" of the string
	syscall     		# Print the string 
	li $v0, 5      		# syscall #5 - read an integer
	syscall        		# Read the integer
	move $t1, $v0  		# Save v into register $t1
	# --- END Prompt and read integer v from user --- 
	
	
	# --- START Print whitespace --- 
	li $v0, 4   		# syscall #4 - print string at address in $a0      
	la $a0, strCR      	# "load address" of the string
	syscall     		# Print the string
	# --- END Print whitespace --- 
	
	
	# --- START call ComputeEquationResult (u,v) ---
	move $a0, $t0 		# pass u as argument $a0 to computeResult
	move $a1, $t1		# pass v as argument $a0 to computeResult
	jal ComputeEquationResult
	move $t0, $v0 		# $t0 = ComputeEquationResult(u,v) result
	# --- END call ComputeEquationResult (u,v) ---
	
	
	# --- START print "3u^2 + 7uv - v^2 + 1 = %d", result --- 
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, strResult      	# "load address" of the string
	syscall     		# Print the string
	li $v0, 1		# syscall #1 - print integer
	move $a0, $t0		# set $a0 = computeResult(u, v) result
	syscall  		# print integer
	li $v0, 4   		# syscall #4 - print string at address in $a0      
	la $a0, strCR      	# "load address" of the string
	syscall     		# Print the string 
	# --- END print "3u^2 + 7uv - v^2 + 1 = %d", result --- 
	
ExitProgram: 
	li $v0, 10
	syscall 



ComputeEquationResult:
	# --- START Save return address --- 
	addi $sp, $sp, -4	# Decrement stack pointer
	sw $ra, ($sp)		# Store $ra
	# --- END Save return address --- 
	
	# --- START Save $s registers --- 
	addi $sp, $sp, -20	# Decrement stack pointer
	sw $s0, ($sp)		# Store $s0 on the stack
	sw $s1, 4($sp)		# Store $s1 on the stack
	sw $s2, 8($sp)		# Store $s2 on the stack
	sw $s3, 12($sp)		# Store $s3 on the stack
	sw $s4, 16($sp)		# Store $s4 on the stack
	# --- END Save $s registers --- 
	
	
	move $s0, $a0 	# s0 = u
	move $s1, $a1 	# s1 = v
	
	
	# --- START calculate 3u^2 ---
	move $a0, $s0 	# Pass u as argument $a0 to Square
	jal Square	
	li $a0, 3	# Pass 3 as argument $a0 to Multiply
	move $a1, $v0	# Pass u^2 as argument $a1 to Multiply	
	jal Multiply	
	move $s2, $v0	# Store result in $s2 [i.e. $s2 = 3u^2]
	# --- END calculate 3u^2 ---
	
	
	# --- START calculate 7uv ---
	li $a0, 7	# Pass 7 as argument $a0 to Multiply
	move $a1, $s0	# Pass u as argument $a1 to Multiply
	jal Multiply	
	move $a0, $v0	# Pass result [i.e. 7u] as argument $a0 to Multiply
	move $a1, $s1	# Pass v as argument $a1 to Multiply
	jal Multiply
	move $s3, $v0	# Store result in $s3 [i.e. $s3 = 7uv]
	# --- END calculate 7uv ---
	
	
	# --- START calculate v^2 ---
	move $a0, $s1 	# Pass v as argument $a0 to Square
	jal Square	
	move $s4, $v0	# Store result in $s4 [i.e. $s4 = v^2]
	# --- END calculate v^2 ---
	
	
	# --- START calculate 3u^2 + 7uv - v^2 + 1 ---
	add $v0, $s2, $s3	# $v0 = (3u^2 + 7uv)	
	sub $v0, $v0, $s4	# $v0 = (3u^2 + 7uv) - v^2 
	addi $v0, $v0, 1	# $v0 = ((3u^2 + 7uv) - v^2) + 1
	# --- END calculate 3u^2 + 7uv - v^2 + 1 ---


	# --- START Load $s registers back ---	
	lw $s4, 16($sp)		# Load the $s4 from the stack
	lw $s3, 12($sp)		# Load the $s3 from the stack
	lw $s2, 8($sp)		# Load the $s2 from the stack
	lw $s1, 4($sp)		# Load the $s1 from the stack	
	lw $s0, ($sp)		# Load the $s0 from the stack
	addi $sp, $sp, 20	# Restore the stack pointer
	# --- END Load $s registers back ---	

	# --- START Load return address ---		
	lw $ra, ($sp)		# Load the return address from the stack
	addi $sp, $sp, 4	# Restore the stack pointer
	# --- END Load return address ---	
	
	jr $ra 		# Return from function
	
		
				
Square: 
	mult $a0, $a0	# $lo = $a0 * $a0 = ($a0)^2
	mflo $v0	# $v0 = $lo = ($a0)^2
	
	jr $ra	# Return from function



Multiply: 
	mult $a0, $a1	# $lo = $a0 * $a1
	mflo $v0	# $v0 = $lo = $a0 * $a1
	
	jr $ra	# Return from function
	
