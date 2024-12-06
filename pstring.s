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

    lea int_prompt(%rip), %rdi  # Use int_prompt as example output
    movl $31, %esi              # Example integer to print
    xor %eax, %eax              # Clear %rax
    call printf
	call line_down
	
    popq	%rbp
	ret

.type swapCase @function
.global swapCase
swapCase:
    pushq	%rbp
	movq	%rsp,	%rbp

    lea int_prompt(%rip), %rdi
    movl $33, %esi
    xor %eax, %eax
    call printf
	call line_down

    popq	%rbp
	ret

.type pstrijcpy @function
.global pstrijcpy
pstrijcpy:
    pushq	%rbp
	movq	%rsp,	%rbp

	lea int_prompt(%rip), %rdi
    movl $34, %esi
    xor %eax, %eax
    call printf
    call line_down

    popq	%rbp
	ret

.type pstrcat @function
.global pstrcat
pstrcat:
    pushq	%rbp
	movq	%rsp,	%rbp
    
	lea int_prompt(%rip), %rdi
    movl $37, %esi
    xor %eax, %eax
    call printf
	call line_down

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
		lea int_prompt(%rip), %rdi	# Loads the seeds string into rdi
		mov %rsp, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function

    print_str:
        lea str_msg, %rdi			# Loads the message prompt into rdi
		xor	%rax, %rax				# Cleans rax
		call printf					# Prints the message prompt with function
		call line_down

