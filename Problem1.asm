# Title: Project 1 Problem 1					Filename: CSE420Project1Problem1.asm
# Author1: Levi Conall <l.conall@asu.edu> 			Date: 06/02/2017
# Description:  This program takes a defined string and converts it from UPPERCASE to lowercase.  
#		The string is printed both before and after the conversion to show the program success.
#		It uses three functions that were defined to convert the defined string to lowercase.
#		The first function is MakeStringLowercase which takes a string address as an argument 
#		and uses the other two helper functions to convert it to lowercase. 
#		The second function is a function that is used to calculate the string length and return
#		that value to MakeStringLowercase function.  The last function ConvertUppercaseLetterToLowercase 
#		takes in a byte address for a character and if it is an UPPERCASE letter it converts it to lowercase. 
# Input: 	# No user input
# Output: 	# Outputs the string before and after the conversion to the console

################# Data segment #####################
.data
	string: .asciiz "WELCOME TO COMPUTER ARCHITECTURE CLASS!\0" 
	
	stringBefore: .asciiz "String BEFORE being made lowercase: "
	stringAfter: .asciiz "String AFTER being made lowercase: " 
	
	strCR:		 .asciiz "\n" 
################# Code segment #####################
.text 
.globl main
main:	
	# --- START print string before being made lowercase --- 
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, stringBefore    # "load address" of the string
	syscall     		# Print the string
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, string     	# "load address" of the string
	syscall     		# Print the string
	li $v0, 4   		# syscall #4 - print string at address in $a0      
	la $a0, strCR     	# "load address" of the string
	syscall     		# Print the string
	# --- END print string before being made lowercase ---
	
	
	# --- START convert the string to lowercase ---
	la $t0, string
	move $a0, $t0
	jal MakeStringLowercase
	# --- END convert the string to lowercase ---
	
	
	# --- START print string after being made lowercase --- 
	li $v0, 4   		# syscall #4 - print string at address in $a0    
	la $a0, stringAfter     # "load address" of the string
	syscall     		# Print the string 
	li $v0, 4   		# syscall #4 - print string at address in $a0       
	la $a0, string  	# "load address" of the string
	syscall     		# Print the string 
	li $v0, 4   		# syscall #4 - print string at address in $a0      
	la $a0, strCR   	# "load address" of the string
	syscall     		# Print the string
	# --- END print string after being made lowercase --- 

	
ExitProgram: 
	li $v0, 10
	syscall 



MakeStringLowercase: 
	# --- START Save return address --- 
	addi $sp, $sp, -4	# Decrement stack pointer
	sw $ra, ($sp)		# Store $ra
	# --- END Save return address --- 
	
	# --- START Save $s registers --- 
	addi $sp, $sp, -12	# Decrement stack pointer
	sw $s0, ($sp)		# Store $s0 on the stack
	sw $s1, 4($sp)		# Store $s1 on the stack
	sw $s2, 8($sp)		# Store $s2 on the stack
	# --- END Save $s registers --- 
	
	move $s0, $a0		#Store string address in $s0 
	
	# --- START Calculate string length ---		
	jal NullTerminatedStringLength
	move $s2, $v0 		# Store string length in $s2
	# --- END Calculate string length ---	
			
	
	# --- START Convert string to lowercase loop
	# for i = 0; i < stringLength; i++ 
	li $s1, 0x00 		# $s1 = i = 0
	MakeStringLowerCaseLoop: beq $s1, $s2, MakeStringLowerCaseLoopExit # Branch if ($s1[i.e. i] == $s2 [i.e. stringLength])	
		move $a0, $s0	# Move character's address into $a0 to pass as an argument
		jal ConvertUppercaseLetterToLowercase 
			
		addi $s0, $s0, 0x01 	# Get next character's address
		addi $s1, $s1, 0x01	# $s1++ = i++
		j MakeStringLowerCaseLoop	
	MakeStringLowerCaseLoopExit: 
	# --- END Convert string to lowercase loop	
	
	
	# --- START Load $s registers back ---	
	lw $s2, 8($sp)		# Load the $s2 from the stack
	lw $s1, 4($sp)		# Load the $s1 from the stack	
	lw $s0, ($sp)		# Load the $s0 from the stack
	addi $sp, $sp, 12	# Restore the stack pointer
	# --- END Load $s registers back ---	
	
	
	# --- START Load return address ---		
	lw $ra, ($sp)		# Load the return address from the stack
	addi $sp, $sp, 4	# Restore the stack pointer
	# --- END Load return address ---	
	
	jr $ra 		# Return from function



NullTerminatedStringLength: 		
	# --- START Save return address --- 
	addi $sp, $sp, -4	# Decrement stack pointer
	sw $ra, ($sp)		# Store $ra
	# --- END Save return address --- 
	
	
	move $t0, $a0 		# Get string address
	lb $t1, ($t0) 		# Load first character of string
	
	# --- START String length calculation loop. 
	# NOTE: It ends when null character reached
	StringLengthLoop: beq $t1, $zero, StringLengthLoopExit # Branch when character is NULL
	  	addi $v0, $v0, 1 	# Increment the return value counter
	  	
	  	addi $t0, $t0, 1 	# Get address of next byte
	  	lb $t1, ($t0) 		# Load next character
	  	
		j StringLengthLoop 
	StringLengthLoopExit:
	# --- END String length calculation loop
		
	# --- START Load return address ---		
	lw $ra, ($sp)		# Load the return address from the stack
	addi $sp, $sp, 4	# Restore the stack pointer
	# --- END Load return address ---	
	
	jr $ra 			# Return from function

		
						
ConvertUppercaseLetterToLowercase:
	# --- START Save return address --- 
	addi $sp, $sp, -4	# Decrement stack pointer
	sw $ra, ($sp)		# Store $ra
	# --- END Save return address --- 

	lb $t0, ($a0) 		# Load Character Byte from address $a0

	# --- START Convert UPPERCASE char to lowercase char or skip --- 
	CheckGreaterThanOrEqualToCapitalAOrBranch: blt $t0, 0x41, SkipCharacter
		CheckLessThanOrEqualToCapitalZOrBranch: bgt $t0, 0x5A, SkipCharacter
			UpperCaseLetter: 
				addi $t0, $t0, 0x20 	# Make character lowercase
				sb $t0, ($a0)		# Write updated character back into it's location
	SkipCharacter:
	# --- END Convert UPPERCASE char to lowercase char or skip --- 
	
	
	# --- START Load return address ---		
	lw $ra, ($sp)		# Load the return address from the stack
	addi $sp, $sp, 4	# Restore the stack pointer
	# --- END Load return address ---	
	
	jr $ra 			# Return from function
	
