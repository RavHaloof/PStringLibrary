.section .rodata
.global int_prompt
int_prompt:					                            .asciz "%d"
.global str_prompt
str_prompt:					                            .asciz "%s"
min_option:                                             .long 31
max_option:                                             .long 37
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
    mov 72(%rsp), %rdi
    mov 64(%rsp), %rsi
    call pstrlen

    jmp end_run_func
    
# switchCase
handle_33:
    # Moves the saved pointers to the struct in rdi and rsi, and sends them to the function
    mov 72(%rsp), %rdi
    mov 64(%rsp), %rsi
    call swapCase
    jmp end_run_func

handle_34:
    # Example handler for case 34
    call pstrijcpy
    jmp end_run_func

handle_37:
    # Example handler for case 37
    call pstrcat
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
