# Static variables
.section	.rodata
.global int_prompt
int_prompt:					                            .asciz "%d"
.global str_prompt
str_prompt:					                            .asciz "%s"

.section	.text
.globl		run_func
.type		run_func, @function

    # user choice - %rdi
    # *ptr1 - %rsi
    # *ptr2 - %rcx
    run_func:
        pushq	%rbp
        movq	%rsp,	%rbp

        subq $0X10, %rsp
        movq %rsi, 16(%rbp)
        movq %rcx, 24(%rbp)

        leaw 16(%rbp), %di			# Loads the message prompt into rdi
		xor	%rax, %rax				# Cleans rax
		call printf					# Prints the message prompt with function
		call line_down
        

        # Return to OS with status 0
        mov $0, %rax
        mov %rbp, %rsp
        popq	%rbp
        ret



