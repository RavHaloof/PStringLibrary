.section	.rodata
first_len_msg:                                          .asciz "first pstring length: "
second_len_msg:                                         .asciz ", second pstring length: "
len_msg:                                                .asciz "length: "
str_msg:                                                .asciz "string: "
too_long_msg:                                           .asciz "cannot concatenate strings! \n"
go_down:                                                .asciz "\n"

.section	.text
.globl		main
.type		main, @function
main2:
	pushq	%rbp
	movq	%rsp,	%rbp

	# Code starts here


	# Return to OS with status 0
	mov $0, %rax
	popq	%rbp
	ret

.type pstrlen @function
.global pstrlen
pstrlen:
    pushq	%rbp
	movq	%rsp,	%rbp
    
    popq	%rbp
	ret

.type swapCase @function
.global swapCase
swapCase:
    pushq	%rbp
	movq	%rsp,	%rbp
    
    popq	%rbp
	ret

.type pstrijcpy @function
.global pstrijcpy
pstrijcpy:
    pushq	%rbp
	movq	%rsp,	%rbp
    
    popq	%rbp
	ret

.type pstrcat @function
.global pstrcat
pstrcat:
    pushq	%rbp
	movq	%rsp,	%rbp
    
    popq	%rbp
	ret

.type line_down @function
.global line_down
	line_down:
	# Going down a line
		pushq %rbp					# Entering a function, pushing stack
        movq %rsp, %rbp	

		lea go_down, %rdi			# Loads \n into rdi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function

		popq %rbp					# We pop the stack and return to main
        ret

.type utils @function
.global utils
	print_int:
		lea num_prompt(%rip), %rdi	# Loads the seeds string into rdi
		mov num_guess, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function

    print_str:
        lea win_msg2, %rdi			# Loads the message prompt into rdi
		xor	%rax, %rax				# Cleans rax
		call printf					# Prints the message prompt with function
		call line_down

    scan_str:
        lea chr_prompt(%rip), %rdi	# We add the prefix to scan the input correctly
    	lea double_answer(%rip), %rsi	# We put the seed number in rsi to be accepted by the scan
    	xor %rax, %rax				# We clean rax
    	call scanf					# Calling scanf function

    scan_int:
        lea num_prompt(%rip), %rdi	# We add the prefix to scan the input correctly
    	lea seed_val(%rip), %rsi	# We put the seed number in rsi to be accepted by the scan
    	xor %rax, %rax				# We clean rax
    	call scanf					# Calling scanf function

