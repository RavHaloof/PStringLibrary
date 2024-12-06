.section .rodata
.global int_prompt
int_prompt:                                             .asciz "Enter a number: %d\n"
.global int_prompt
str_prompt:                                             .asciz "kill me"
min_option:                                             .long 31
max_option:                                             .long 37
.section .text
.global run_func
.type run_func, @function

run_func:
    # Prologue
    pushq %rbp
    movq %rsp, %rbp

    //Moves the user's choice to rbx, so it doesn't get overriden
    xorq %rax, %rax
    movl %edi, %eax

    # Allocate space on stack for jump table
    subq $80, %rsp               # Allocate space for the jump table (48 bytes)

    # Setting up jump table using stack
    movq $invalid_option, (%rsp)            # Bad answer
    movq $handle_31, 8(%rsp)                # Case 31
    movq $invalid_option, 16(%rsp)          # Bad answer
    movq $handle_33, 24(%rsp)               # Case 33
    movq $handle_34, 32(%rsp)               # Case 34
    movq $invalid_option, 40(%rsp)          # Bad answer
    movq $invalid_option, 48(%rsp)          # Bad answer
    movq $handle_37, 56(%rsp)               # Case 37
    movq %rsi, 64(%rsp)                     # First pointer to string 
    movq %rdx, 72(%rsp)                     # Second pointer to string

    cmp min_option(%rip), %eax
    jl invalid_option

    cmp max_option(%rip), %eax
    ja invalid_option
    
    sub min_option, %eax
    inc %eax
    
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

end_run_func:
    # Restore stack
    addq $80, %rsp              # Free space allocated for jump table
    movq %rbp, %rsp             # Restore base pointer
    popq %rbp                   # Restore previous frame pointer
    ret
