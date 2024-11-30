# Static variables
.section	.rodata

enter_length_msg:                                       .asciz "Enter Pstring length: "
enter_word_msg:                                         .asciz "Enter Pstring:"
func_select_msg:                                        .asciz "Choose a function:\n"
pstrlen_msg:                                            .asciz "        31. pstrlen\n"
swapCase_msg:                                           .asciz "        33. swapCase\n"
pstrijcpy_msg:                                          .asciz "        34. pstrijcpy\n"
pstrcat_msg:                                            .asciz "        37. pstrcat\n"
int_prompt:					                            .asciz "%d"
str_prompt:					                            .asciz "%s"

.section	.text
.globl		main
.type		main, @function
    main:
        pushq	%rbp
        movq	%rsp,	%rbp

        # Code starts here
        call run_func

        # Return to OS with status 0
        mov $0, %rax
        popq	%rbp
        ret

# A function to select which pstring function does the user want to use
.type run_func @function
.global run_func
    run_func:
        pushq	%rbp
        movq	%rsp,	%rbp

        lea num_prompt(%rip), %rdi	# We add the prefix to scan the input correctly
    	lea %rbx, %rsi	            # We put the seed number in rsi to be accepted by the scan
    	xor %rax, %rax				# We clean rax
    	call scanf					# Calling scanf function

        call pstrlen

        # Return to OS with status 0
        mov $0, %rax
        popq	%rbp
        ret



