.data


.text


# Calls sub_a and passes the string in via the stack
main:



# takes in the string and sends substrings to sub_b to get the decimal value or error msg back
# prints returned results from sub_b
sub_a:





# takes in each substring and loops through the characters to evaluate the result
# returns decimal value or error msg 
sub_b:





end:
	li $v0, 10
	syscall