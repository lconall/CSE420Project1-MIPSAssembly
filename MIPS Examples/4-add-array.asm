# Compute the sum of five elements in an array

.data
array:	.word   0 : 5     # "array" of 5 words
size:	.word  5          # size of "array" 

.text 
        # initialize array with values 
        la $s1, array	  # Load Array address
        li $t0, 1	  # Value to be stored
        sw $t0, 0($s1)	  # Store value in the array element

        li $t0, 2
        sw $t0, 4($s1)

        li $t0, 4
        sw $t0, 8($s1)

        li $t0, 3
        sw $t0, 12($s1)

        li $t0, 5
        sw $t0, 16($s1)

        ## Inititalize registers prior looping
        addi $s2, $s1, 20 # s2 has final destination
        add  $t3, $0, $0  # t3 holds summation
        move $t0, $s1	  # to has address of an array element	

        ## loop to add the array elements
Loop: 
        beq $t0, $s2, endLoop
        lw  $t1, 0($t0)	  # Load array value
        add $t3, $t3, $t1 # Update the sum
        addi $t0, $t0, 4  # Increment the address
        j Loop		  
 
endLoop:
        move $a0, $t3
        li $v0, 1         # syscall number 1 -- print int
        syscall           # print the summation

        li $v0, 10  	  # Syscall number 10 is to terminate the program
        syscall     	  # exit now