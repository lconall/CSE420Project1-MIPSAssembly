## Construction of switch-case statements for set of fixed values
## switch case
# Program:
# int a, b, c;
# int n
# switch (n) {
# case 1: c = a + b;
#         break;
# case 2: c = a - b;
#         break;
# case 3: c = a;
# case 4: c = b;
# print c;

.data
caseTable: 	.word  0 : 5 	# "array" of 5 words
size: 		.word  5        # size of "array" 
      
.text  
	# build the caseTable  
	la   $s1, caseTable

	la   $t5, case1
	sw   $t5, 4($s1)

	la   $t5, case2
	sw   $t5, 8($s1)

	la   $t5, case3
	sw   $t5, 12($s1)

	la   $t5, case4
	sw   $t5, 16($s1)

	add  $t3, $0, $0	# c
	addi $t1, $0, 5		# a = 5
	addi $t2, $0, 3		# b = 3

	li   $s0, 3		# n    --> change this to set n

	## check boundary conditions
	slti $t0, $s0, 1
	bne $t0, $0 endCase     # if n < 1 , then exit case

	slti $t0, $s0, 5
	beq $t0, $0 endCase     # if n > 4 , then exit case

	# load from case table and jump 
	sll $t5, $s0, 2
	add $t0, $s1, $t5
	lw $t0, 0($t0)
	jr $t0

	## cases
case1: 	add $t3, $t1, $t2
	j endCase
 
case2: 	sub $t3, $t1, $t2
	j endCase

case3: 	move $t3, $t1
	j endCase

case4: 	move $t3, $t2

endCase:
	move $a0, $t3
	li $v0, 1        	# syscall number 1 -- print int
	syscall           	# print the outcome

	li $v0, 10  		# Syscall number 10 is to terminate the program
	syscall     		# exit now 
