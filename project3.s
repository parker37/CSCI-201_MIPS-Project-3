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
	


# takes in each substring and loops through the characters to evaluate the result
# returns decimal value or error msg 
sub_b:





end:
	li $v0, 10
	syscall