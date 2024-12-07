.section .rodata
.global int_prompt
int_prompt:					                            .asciz "%ld"
.global str_prompt
str_prompt:					                            .asciz "%s"
min_option:                                             .long 31
max_option:                                             .long 37
string_format:                                          .asciz ", string: %s\n"
switch_prompt_len:										.asciz "length: %d, "
len_format1:                                            .asciz "first pstring "
len_format2:                                            .asciz ", second pstring "
invalid_option_format:                                  .asciz "invalid option!\n"
invalid_input_format:                                   .asciz "invalid input!\n"
invalid_concat_format:                                  .asciz "cannot concatenate strings!\n"
.section .text
.global run_func
.type run_func, @function

run_func:
    # Start
    pushq %rbp
    movq %rsp, %rbp
    # choice -> %rdi
    # *Pstring1 -> %rsi
    # *Pstring2 -> %rdx
    //Moves the user's choice to rbx, so it doesn't get overriden
    xorq %rax, %rax
    movl %edi, %eax

    # Allocate space on stack for jump table
    subq $96, %rsp               # Allocate space for the jump table (48 bytes)

    # Setting up jump table using stack
    movq $invalid_option, (%rsp)            # Bad answer
    movq $handle_31, 8(%rsp)                # Case 31
    movq $invalid_option, 16(%rsp)          # Bad answer
    movq $handle_33, 24(%rsp)               # Case 33
    movq $handle_34, 32(%rsp)               # Case 34
    movq $invalid_option, 40(%rsp)          # Bad answer
    movq $invalid_option, 48(%rsp)          # Bad answer
    movq $handle_37, 56(%rsp)               # Case 37
    movq %rsi, 64(%rsp)                     # First pointer to first string 
    movq %rdx, 72(%rsp)                     # First pointer to second string

    # In case the answer is less than 31 (invalid)
    cmp min_option(%rip), %eax
    jl invalid_option
    # In case the answer is more than 37 (invalid)
    cmp max_option(%rip), %eax
    ja invalid_option

    # Modifies %eax to fit with the jump table
    sub min_option, %eax
    inc %eax
    # Jumps according to the user's choice, should be noted that bad bases between 31-37 are also handled
    movq (%rsp, %rax, 8), %rcx  # Load handler address based on index
    jmp *%rcx                   # Jump to the handler

# pstrlen
handle_31:
    # Moves the saved pointers to the struct in rdi and rsi, and sends them to the function
    lea len_format1(%rip), %rdi	# Loads the seeds string into rdi
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function
    
    mov 64(%rsp), %rdi
    call pstrlen

    lea len_format2(%rip), %rdi	# Loads the seeds string into rdi
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function

    mov 72(%rsp), %rdi
    call pstrlen
    call line_down
    jmp end_run_func
    
# switchCase
handle_33:
    # Calls pstrlen to print the length of first pstring
    mov 64(%rsp), %rdi
    call pstrlen
    # Moves the saved pointers to the struct in rsi and sends them to the function
    mov 64(%rsp), %rsi
    call swapCase
    inc %rsi                    # To ignore the length of the string while we print it
    # Prints the changed string 1
    lea string_format(%rip), %rdi	# Loads the seeds string into rdi
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function

    # Same as before but with the second string
    mov 72(%rsp), %rdi
    call pstrlen

    mov 72(%rsp), %rsi
    call swapCase

    # Prints the changed string 2
    inc %rsi                    # To ignore the length of the string while we print it
    lea string_format(%rip), %rdi	# Loads the seeds string into rdi
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function

    jmp end_run_func
#Pstrijcpy
handle_34:
    # Load first string's address and contents
    movq 64(%rsp), %rsi
    movzbq (%rsi), %r12           # Load entire 64-bit value into %rdx
    # Load second string's address and contents
    movq 72(%rsp), %rsi
    movzbq (%rsi), %r13           # Load entire 64-bit value into %rdx

    lea int_prompt(%rip), %rdi   # Format string
    lea 80(%rsp), %rsi           # Address of first number
    xor %rax, %rax
    call scanf                   # Read input
    movq 80(%rsp), %rbx          # Store first input in %rbx

    lea int_prompt(%rip), %rdi   # Format string
    lea 88(%rsp), %rsi           # Address of first number
    xor %rax, %rax
    call scanf                   # Read input
    movq 88(%rsp), %r15          # Store first input in %r15

    cmpq %rbx, %r12
    jle invalid_case              # Jump if %rbx > %r12

    cmpq %rbx, %r13
    jle invalid_case              # Jump if %rbx > %r13

    cmpq %r15, %r12
    jle invalid_case              # Jump if %r15 > %r12

    cmpq %r15, %r13
    jle invalid_case              # Jump if %r15 > %r13

    cmpq %rbx, %r15
    jl invalid_case              # Jump if %rbx > %r15

    cmpq $0, %rbx
    jl invalid_case              # Jump if 0 > %rbx (negative)

    cmpq $0, %r15
    jl invalid_case              # Jump if 0 > %r15 (negative)


    # Loads all the values we need to pstrijcpy
    movq 64(%rsp), %rdi          # First string to rdi
    movq 72(%rsp), %rsi          # Second string to rsi
    mov %rbx, %rcx               # First index to rcx
    mov %r15, %rdx               # Second index to rdx
    call pstrijcpy

    # Ends the function
    jmp end_pstrijcpy

    # In case the index values were illegal (too small or too large)
    invalid_case:
    lea invalid_input_format(%rip), %rdi
    xor %rax, %rax
    call printf
    # End
    end_pstrijcpy:
    # Calls pstrlen to print the length of first pstring
    mov 64(%rsp), %rdi
    call pstrlen

    # Prints the changed string 1
    lea string_format(%rip), %rdi	# Loads the seeds string into rdi
    mov 64(%rsp), %rsi
    inc %rsi                    # To ignore the length of the string while we print it
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function

    # Calls pstrlen to print the length of first pstring
    mov 72(%rsp), %rdi
    call pstrlen

    # Prints the string 2
    lea string_format(%rip), %rdi	# Loads the seeds string into rdi
    mov 72(%rsp), %rsi
    inc %rsi                    # To ignore the length of the string while we print it
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function

    jmp end_run_func

handle_37:
    # Load first string's address and contents
    movq 64(%rsp), %rdi
    movzbq (%rdi), %rcx           # Load entire 64-bit value into %rcx

    movq 72(%rsp), %rsi
    movzbq (%rsi), %rdx           # Load entire 64-bit value into %rdx

    # Checks whether the two strings' lengths are above 254
    mov %rcx, %rax
    add %rdx, %rax
    cmp $254, %rax
    # If so, skips concat
    ja invalid_concat
    inc %rsi
    call pstrcat
    dec %rsi
    # Increases the OG string's length
    movb (%rdi), %bl
    movb (%rsi), %cl
    addb %cl, %bl
    movb %bl, (%rdi)
    # Jumps to the end of the function 
    jmp end_concat
    
    # In case the strongs were too long to concat
    invalid_concat:
    lea invalid_concat_format(%rip), %rdi
    xor %rax, %rax
    call printf

    end_concat:

    # Calls pstrlen to print the length of first pstring
    mov 64(%rsp), %rdi
    call pstrlen

    # Prints the changed string 1
    lea string_format(%rip), %rdi	# Loads the seeds string into rdi
    mov 64(%rsp), %rsi
    inc %rsi                    # To ignore the length of the string while we print it
	xor %rax, %rax				    # Cleans rax
	call printf					    # Calling printf function

    # Calls pstrlen to print the length of first pstring
    mov 72(%rsp), %rdi
    call pstrlen

    # Prints the string 2
    lea string_format(%rip), %rdi	# Loads the seeds string into rdi
    mov 72(%rsp), %rsi
    inc %rsi                    # To ignore the length of the string while we print it
	xor %rax, %rax				# Cleans rax
	call printf					# Calling printf function

    jmp end_run_func

invalid_option:
    # Default handler
    lea invalid_option_format(%rip), %rdi	# Loads the seeds string into rdi
	xor %rax, %rax				# Cleans rax
    call printf

end_run_func:
    # Restore stack
    addq $96, %rsp              # Free space allocated for jump table
    movq %rbp, %rsp             # Restore base pointer
    popq %rbp                   # Restore previous frame pointer
    ret
