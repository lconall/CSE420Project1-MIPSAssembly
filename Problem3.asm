# Title: Project 1 Problem 3					Filename: CSE420Project1Problem3.asm
# Author1: Levi Conall <l.conall@asu.edu> 			Date: 06/02/2017
# Description:  The goal of this program is to create a function called update sum that takes two pointer
#		parameters and uses them to create a running total of each of the elements in a ten element array.
#  		The main function sets up the array using a loop and then calls update sum for each element in the
#		the array using another loop. Finally it prints the final total before exiting. 
# Input: N/A
# Output: "Sum = %d", *sum   	

################# Data segment #####################
.data
	sum:	.word	0
	array: 	.word 	0:10
	
	strSumPrintout:	 .asciiz "Sum = " 
	strCR:		 .asciiz "\n" 
################# Code segment #####################
.text 
.globl main

main:	
	# --- START Save $s registers --- 
	addi $sp, $sp, -4	# Decrement stack pointer
	sw $s0, ($sp)		# Store $s0 on the stack
	# --- END Save old $s0 value --- 
	
	
	la $t0, array # load the address of the array into $t0
	
	# --- START for(i = 0; i < 10; i++) ---
	li $t1, 0 					# i = 0
	FillArrayLoop: beq, $t1, 10, FillArrayLoopExit 	# Branch if ($t0 == 10 [i.e. i == 10])	
		
		addi $t2, $t1, 1 			# $t2 = $t1 + 1 [i.e. $t2 = i + 1]
		li $t3, 3				# $t3 = 3
		mult $t3, $t2				# $lo = $t3 * $t2 [i.e. $lo = 3(i + 1)]   	
		mflo $t2 				# $t2 = $lo
		
		sw $t2, ($t0)				# array[i] = 3(i + 1)
	
		addi $t0, $t0, 4 			# Get the address of the next element in array
		addi $t1, $t1, 1 			# i++
		
		j FillArrayLoop
	FillArrayLoopExit: 
	# --- END for(i = 0; i < 10; i++) ---
	
	
	# --- START load pointers to sum and first array element into arguments $a0 and $a1 ---
	la $a0, sum # load &sum into $a0 for update sum function call
	la $a1, array # load &array[0] into $a1 for update sum function call
	# --- END load pointers to sum and first array element into arguments $a0 and $a1 ---
	
	# --- START for(i = 0; i < 10; i++) ---
	li $s0, 0 					# i = 0
	UpdateSumLoop: beq, $s0, 10, UpdateSumLoopExit 	# Branch if ($s0[i.e. i] == 10)	
		
		jal updateSum 				# call updateSum
		
		addi $a1, $a1, 4 			# Get address array[i+1]
		addi $s0, $s0, 1 			# i++
		
		j UpdateSumLoop
	UpdateSumLoopExit: 
	# --- END for(i = 0; i < 10; i++) ---
	
	
	# --- START printf("Sum = %d", *sum) ---
	li $v0, 4   		# syscall #4 - print string at address in $a0     
	la $a0, strSumPrintout  # "load address" of the string
	syscall     		# Print the string 
	li $v0, 1		# syscall #1 - print integer
	la $a0, sum		# "load address" of sum
	lw $a0, ($a0)		# Get integer value of sum
	syscall  		# print the integer
	li $v0, 4  		# syscall #4 - print string at address in $a0        
	la $a0, strCR		# "load address" of the string
	syscall     		# Print the string 
	# --- END printf("Sum = %d", *sum) ---
	
	
	# --- START Load $s registers back ---		
	lw $s0, ($sp)		# Load the $s0 from the stack
	addi $sp, $sp, 4	# Restore the stack pointer
	# --- END Load old $s0 value back into $s0 ---	

ExitProgram: 
	li $v0, 10
	syscall 



updateSum:
	# --- START Save return address --- 
	addi $sp, $sp, -4	# Decrement stack pointer
	sw $ra, ($sp)		# Store $ra
	# --- END Save return address --- 


	# --- START load pointer arguments into temporary registers ---
	lw $t0, ($a0) 		# $t0 = *total
	lw $t1, ($a1) 		# $t1 = *element
	# --- END load pointer arguments into temporary registers ---
		
	# --- START *total += *element ---
	add $t0, $t0, $t1	# *total += *element where $t0 = *total, $t1 = *element 
	sw $t0, ($a0)		# Store $t0 at sum's address
	# --- END *total += *element ---
		
		
	# --- START Load return address ---		
	lw $ra, ($sp)		# Load the return address from the stack
	addi $sp, $sp, 4	# Restore the stack pointer
	# --- END Load return address ---	
	
	jr $ra 		# Return from function
