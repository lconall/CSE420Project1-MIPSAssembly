###############################################
# This program does summation of two variables
# and prints the output on the terminal
###############################################

main: 	li $s0, 17 			# initialize a = 17
	li $s1, 4 			# initialize b = 4
	add $s2, $s0, $s1 		# c = a + b

	move $a0, $s2 			# move the number to print into $a0.
	li $v0, 1 			# load syscall print_int into $v0.
	syscall 			# make the syscall.

exit: 	li $v0, 10			# load syscall 10 into $v0
	syscall				# syscall
