.section	.rodata
first_len_msg:                                          .asciz "first pstring length: "
second_len_msg:                                         .asciz ", second pstring length: "
len_msg:                                                .asciz "length: "
str_msg:                                                .asciz "string: "
too_long_msg:                                           .asciz "cannot concatenate strings! \n"
go_down:                                                .asciz "\n"
len_format:                                             .asciz "length: %d"
lowest_CAPS:											.asciz "A"
highest_normal:											.asciz "z"
highest_CAPS:											.asciz "Z"
lowest_normal:											.asciz "a"
switchCase_num:											.quad 32

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

	# Moves only the first bit of where rdi and rsi are pointing, meaning the string's length
	movzbq (%rdi), %rsi
	
	# Prints the first string's length
	lea len_format(%rip), %rdi	# Loads the seeds string into rdi
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function
	
    popq	%rbp
	ret

.type swapCase @function
.global swapCase
swapCase:
    pushq	%rbp
	movq	%rsp,	%rbp
	# Makes sure that the registers are clean
	xorq %r8, %r8

	movzbq (%rsi), %rcx						# Saves the length of the first string in rcx
	movq %rsi, %r8							# Saves the string itself in r8

	# Loops that goes all over a word and changes upper case to lower case, and the opposite
	swap_loop:

	incq %r8
	# Moves string[%rdx] into rax, meaning the letter in place %rdx-1
	cmpb $65, (%r8)							# Compares to the lowest possible letter in uppercase
	jl end									# If lower, it's not a letter, and skips this letter
	cmpb $122, (%r8)						# Compares to the highest possible letter in lowercase
	ja end									# If higher, it's not a letter, skips it
	cmpb $91, (%r8)							# Compares the highest possible letter in uppercase
	jl CAPS									# If lower, then the char is an upper case letter for sure, skips to CAPS
	cmpb $97, (%r8)							# Compares the highest possible letter in uppercase
	jl end									# If lower, then the char is not a letter, skips to end
	# In case it's a lower letter
	lower:
	subb $32, (%r8)							# Decreases the ascii value by 32, resulting in upper case
	jmp end									# Jumps to end

	# In case it's an upper letter
	CAPS:
	addq $32, (%r8)							# Increases the ascii value by 32, resulting in upper case
	jmp end									# Jumps to end

	# Went through all cases
	end:

	subq $1, %rcx							# Decreases rcx by 1
	jrcxz swap_out							# If rcx is 0, ends
	jmp swap_loop							# Otherwise continues

	swap_out:
    popq	%rbp
	ret

.type pstrijcpy @function
.global pstrijcpy
pstrijcpy:
    pushq	%rbp
	movq	%rsp,	%rbp

	# Saving all safe registers due to function calling conventions
	pushq %rbx
	pushq %r8
	pushq %r9
	
	# Saving the start index
	mov %rcx, %rbx
	# Saving the amount of times we'll need to loop (%rdx - %rcx)
	mov %rdx, %rax
	sub %rcx, %rax
	# And moving it back to %rcx
	mov %rax, %rcx
	# Saving the structs on r8 and r9
	movq %rdi, %r8
	movq %rsi, %r9
	# To include the last letter in the string
	inc %rcx
	# Since the first letter of the array is actually the string's length
	inc %rbx
	ijcpy_loop:

	# Moving the bit in the second string at rbx place to al, and al to the first string at the same place
	movb (%r9, %rbx), %al
	movb %al, (%r8, %rbx)
	# Moves on to the next index
	inc %rbx
	# Decreases rcx and checks the loop status
	subq $1, %rcx							# Decreases rcx by 1
	jrcxz ij_out							# If rcx is 0, ends
	jmp ijcpy_loop

	# Ends the function
	ij_out:

	# Returns all the calling convention registers
	popq %rbx
	popq %r8
	popq %r9

    popq	%rbp
	ret

.type pstrcat @function
.global pstrcat
pstrcat:
    pushq	%rbp
	movq	%rsp,	%rbp
	# Saving all safe registers due to function calling conventions
    pushq %rbx
	
	# Moving the counter to rcx, rbx is the pointer to the affected string, rdx the pointer to the affecting string
	mov %rcx, %rbx							# Moves the first string's last index to rbx
	mov %rdx, %rcx							# Moves the letter count or rdx to rcx
	xorq %rdx, %rdx							# Sets rdx to 0
	inc %rbx								# Increases rbx
	inc %rcx								# Increases rcx
	strcat_loop:

	# Moving the bit in the second string at rbx place to al, and al to the first string at the same place
	movb (%rsi, %rdx), %al
	movb %al, (%rdi, %rbx)
	# Moves on to the next index
	inc %rbx
	inc %rdx
	# Decreases rcx and checks the loop status
	dec %rcx									# Decreases rcx by 1
	jrcxz strcat_out							# If rcx is 0, ends
	jmp strcat_loop

	# End
	strcat_out:
	popq    %rbx
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

