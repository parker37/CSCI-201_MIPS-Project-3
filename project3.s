.data
	input: .space 1001			# makes space for user input

.text
# Calls sub_a and passes the string in via the stack
main:
	li $v0, 8				# load syscode for getting input
	la $a0, input			# loads address of input variable
	li $a1, 1001			# caps how many characters to accept before cutting input off
	syscall					# performs action: take in user input
	
	jal sub_a				# goes into sub_a passing input string


# takes in the string and sends substrings to sub_b to get the decimal value or error msg back
# prints returned results from sub_b
sub_a:
	addi $sp, $sp, -4		# create space in stack for return address
	sw $ra, 0($sp)			# store return address into stack
	
	la $t0 ($a0)			# save input string to new register
	li $t2, 0				# count var for substring length
	loop:					# loop for separating string into substrings
	la $t1 0($t0)			# load char into temp var
	beq $t1, 59, sub_program
	
	
	sub_program:
	jal sub_b				# goes into sub_B passing input substring
	j loop
	
	return:

# takes in each substring and loops through the characters to evaluate the result
# returns decimal value or error msg 
sub_b:





end:
	li $v0, 10
	syscall