.data
	input: .space 1001		# makes space for user input

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
	addi $sp, $sp, -4			# create space in stack for return address
	sw $ra, 0($sp)				# store return address into stack
	
	la $t0 ($a0)				# save input string to new register
	loop:						# loop for separating string into substrings
	la $s0, input				# space for substring
	li $t2, 0					# count var for substring length
	lb $t1 0($t0)				# load char into temp var
	beq $t1, 0, return			# if '\n' jump to sub_b then return back to main
	beq $t1, 59, sub_program	# if ';' jump to sub_b to get value
	addi $t2, $t2, 1			# increment count
	sb $t1, 0($s0)				# store char into substring register
	addi $s0, $s0, 1			# moves pointer to next byte
	
	sub_program:
	la $a1, ($t2)				# stores length of substring in $a1
	jal sub_b					# goes into sub_B passing input substring
								# print out value with ',' after return
	j loop
	
	return:
	la $a1, ($t2)				# stores length of substring in $a1
	jal sub_b					# goes into sub_B passing input substring
								# print out value after return
	

# takes in each substring and loops through the characters to evaluate the result
# a0: substring
# a1: length of string
# returns decimal value or error msg 
sub_b:





end:
	li $v0, 10
	syscall