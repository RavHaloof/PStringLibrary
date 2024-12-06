.section .rodata
.global int_prompt
int_prompt:                                             .asciz "Enter a number: %d\n"
.global int_prompt
str_prompt:                                             .asciz "kill me"

.section .text
.global run_func
.type run_func, @function

run_func:
    # Prologue
    pushq %rbp
    movq %rsp, %rbp

    //Moves the user's choice to rbx, so it doesn't get overriden
    mov %rdi, %rbx

    lea int_prompt(%rip), %rdi   # Load format string for `%ld`
    movq %rbx, %rsi              # Move 64-bit signed value from %rdi to %rsi
    xor %eax, %eax               # Clear %rax for variadic function calls
    call printf                  # Print the 64-bit signed integer

    # Prepare `printf` call
    lea int_prompt(%rip), %rdi   # Load address of format string into %rdi
    movl $42, %esi               # Example integer to print (matches `%d`)
    xor %eax, %eax               # Clear %rax for variadic function calls
    call printf                  # Call `printf`

    # Allocate space on stack for jump table
    subq $48, %rsp               # Allocate space for the jump table (48 bytes)

    # Setting up jump table using stack
    movq $invalid_option, (%rsp)        # Default handler
    movq $handle_31, 8(%rsp)            # Case 31
    movq $handle_33, 16(%rsp)           # Case 33
    movq $handle_34, 24(%rsp)           # Case 34
    movq $handle_37, 32(%rsp)           # Case 37

    # Example jump to handle_31
    movl $2, %eax               # Simulate normalized index for case 31
    movq (%rsp, %rax, 8), %rcx  # Load handler address based on index
    jmp *%rcx                   # Jump to the handler

handle_31:
    # Example handler for case 31
    lea int_prompt(%rip), %rdi  # Use int_prompt as example output
    movl $31, %esi              # Example integer to print
    xor %eax, %eax              # Clear %rax
    call printf
    jmp end_run_func

handle_33:
    # Example handler for case 33
    lea int_prompt(%rip), %rdi
    movl $33, %esi
    xor %eax, %eax
    call printf
    jmp end_run_func

handle_34:
    # Example handler for case 34
    lea int_prompt(%rip), %rdi
    movl $34, %esi
    xor %eax, %eax
    call printf
    jmp end_run_func

handle_37:
    # Example handler for case 37
    lea int_prompt(%rip), %rdi
    movl $37, %esi
    xor %eax, %eax
    call printf
    jmp end_run_func

invalid_option:
    # Default handler
    lea int_prompt(%rip), %rdi
    movl $0, %esi               # Example output for invalid choice
    xor %eax, %eax
    call printf
    jmp end_run_func

end_run_func:
    # Restore stack
    addq $48, %rsp              # Free space allocated for jump table
    movq %rbp, %rsp             # Restore base pointer
    popq %rbp                   # Restore previous frame pointer
    ret
