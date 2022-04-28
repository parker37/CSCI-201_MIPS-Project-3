.data
	input: .space 1001		# makes space for user input
	substr: .space 11		# makes space for user input
	comma: .asciiz ","
	errorMsg: .asciiz "-"	# response to incorrect input
	
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
	
	la $s0, ($a0)				# save input string to new register
	move $s2, $a0				# save input string to new register
	li $s1, 0					# count var for substring length
	loop:						# loop for separating string into substrings
	li $t3, 0
	lb $t1 0($s0)				# load char into temp var
	beq $t1, 0, return			# if '\n' jump to sub_b then return back to main
	beq $t1, 59, sub_program	# if ';' jump to sub_b to get value
	bnez $t3, skip
	beq $t1, 32, space
	beq $t1, 9, space
	skip:
	addi $s1, $s1, 1			# increment count
	addi $s0, $s0, 1			# moves to next character in input string
	addi $t3, $t3, 1
	j loop
	
	space:
		addi $s0, $s0, 1			# moves to next character in input string
		addi $s2, $s2, 1			# moves to next character in input string
		j loop
	
	sub_program:
	la $a0, ($s1)				# stores length of substring in $a1
	jal sub_b					# goes into sub_B passing input substring
	li $v0, 4					# print out value with ',' after return
	la $a0, comma
	syscall
	li $s1, 0
	addi $s0, $s0, 1			# moves to next character in input string
	addi $s2, $s2, 1			# moves to next character in input string
	j loop
	
	return:
	subi $s1, $s1, 1			# increment count
	la $a0, ($s1)				# stores length of substring in $a1
	jal sub_b					# goes into sub_B passing input substring
	j end							# print out value after return
	

# takes in each substring and loops through the characters to evaluate the result
# a0: substring
# a1: length of string
# returns decimal value or error msg 
sub_b:
	li $t0, 0			# counter
	la $t1, ($a0)			# exponent
	subi $t1, $t1, 1 		# fix 0 index
	loop3:
		blez $a0, mainReturn
		lb $t2, 0($s2)
		beq $t2, 10, mainReturn		# checks if counter reached last character
		beq $t2, 32, check
		beq $t2, 9, check
		blt $t2, '0', formatError		# checks if char is less than the lowest bound
		bgt $t2, 'x', formatError		# checks if char is greater than the upper bound
		ble $t2, '9', number			# checks if char is a number
		blt $t2, 'A', formatError		# checks if char is out of bounds for uppercase letters
		ble $t2, 'X', uppercase		# checks if char is a uppercase letter
		blt $t2, 'a', formatError		# checks if char is out of bounds for lowercase letters
		ble $t2, 'x', lowercase		# checks if char is a uppercase letter
		j formatError
	number:						# converts numbers to values
		addi $t3, $t2, -48
		j exponent
	uppercase:					# converts lowercase letters to values
		addi $t3, $t2, -55
		j exponent
	lowercase:					# converts uppercase letters to values
		addi $t3, $t2, -87
		j exponent	
	next:						# next iteration prep
		subi $a0, $a0, 1
		addi $s2, $s2, 1
		subi $t1, $t1, 1
		j loop3
		
	check:
		subi $a0, $a0, 1
		addi $s2, $s2, 1
		subi $t1, $t1, 1
		blez $a0, mainReturn
		lb $t2, 0($s2)
		beq $t2, 10, mainReturn		# checks if counter reached last character
		beq $t2, 32, check
		beq $t2, 9, check
		j formatError
		
	mainReturn:
		li $v0, 1
		la $a0, ($t0)
		syscall
		jr $ra
		
	exponent:				# loop that acts as a exponent multiplier
		la $t4, ($t1)
		li $t5, 34
		li $t6, 1
		expLoop:
			ble $t4, 0, out
			mul $t6, $t6, $t5
			subi $t4, $t4, 1
			j expLoop
		out:
			mul $t4, $t6, $t3
			add $t0, $t0, $t4
			j next

formatError:
	li $v0, 4			# load sys code for printing strings
	la $a0, errorMsg		# load error message for incorrect input
	syscall
	jr $ra

end:
	li $v0, 10
	syscall
