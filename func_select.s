# Static variables
.section	.rodata
.global int_prompt
int_prompt:					                            .asciz "%d"
.global str_prompt
str_prompt:					                            .asciz "%s"
pstrlen_num:                                            .long 31
swapCase_num:                                           .long 33
pstrijcpy_num:                                          .long 34
pstrcat_num:                                            .long 37

.section	.text
.globl		run_func
.type		run_func, @function

    run_func:
        pushq %rbp
        movq %rsp, %rbp

        subq $8, %rsp                # Align %rsp (since pushq misaligns by 8 bytes)
        # Prepare `printf` call
        lea int_prompt(%rip), %rdi    # Load address of format string into %rdi
        movl $42, %esi               # Example integer to print (matches `%d`)
        xor %eax, %eax                # Clear %rax for variadic function calls
        call printf                   # Call `printf`

        # choice -> %rdi
        # *Pstring1 -> %rsi
        # *Pstring2 -> %rdx
        subq $48, %rsp          # Allocate space on stack for jump table

        lea int_prompt(%rip), %rdi	# Loads the seeds string into rdi
        xor %rax, %rax				# Cleans rax
		mov %rax, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function

        # Setting up jump table using stack
        movq $invalid_option, (%rsp)       # Any option which is not the specified numbers
        movq $handle_31, 8(%rsp)           # In case the user typed 31
        movq $handle_33, 16(%rsp)          # In case 33
        movq $handle_34, 24(%rsp)          # In case 34
        movq $handle_37, 32(%rsp)          # In case 37

        # Calculate offset for jump
        # Normalize choice and map to compact index
        movl %edi, %ebx          # Move choice to ebx
        cmpl $31, %ebx           # Check if choice < 31
        jl invalid_option        # Jump to invalid if so
        subl $31, %ebx           # Normalize: subtract 31
        cmpl $6, %ebx            # Check if choice > 37
        ja invalid_option        # Jump to invalid if so

        cmp $1, %ebx             # Check if the number was 32
        je invalid_option        # Jump to invalid option for this case

        cmp $4, %ebx             # Check if the number was 35
        je invalid_option        # Jump to invalid option for this case

        cmp $5, %ebx             # Check if the number was 36
        je invalid_option        # Jump to invalid option for this case

        movq (%rsp, %rbx, 8), %rcx # Load the handler address
        jmp *%rcx                # Jump to the handler

    handle_31:
        lea int_prompt(%rip), %rdi	# Loads the seeds string into rdi
		mov $31, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function
        jmp end_run_func        # Jump to end

    handle_33:
        # Code for handling choice 33
        lea int_prompt(%rip), %rdi	# Loads the seeds string into rdi
		mov $33, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function
        jmp end_run_func

    handle_34:
        # Code for handling choice 34
        lea int_prompt(%rip), %rdi	# Loads the seeds string into rdi
		mov $34, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function
        jmp end_run_func

    handle_37:
        # Code for handling choice 37
        lea int_prompt(%rip), %rdi	# Loads the seeds string into rdi
		mov $37, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function
        jmp end_run_func

    invalid_option:
        # Handle invalid choice
        lea int_prompt(%rip), %rdi	# Loads the seeds string into rdi
		mov $0, %rsi
		xor %rax, %rax				# Cleans rax
		call printf					# Calling printf function

    end_run_func:
        # Return to OS with status 0
        mov $0, %rax
        movq %rbp, %rsp
        popq %rbp
        addq $64, %rsp          # Reset the stack
        ret



