
.data               # start of data section
# put any global or static variables here

.section .rodata    # start of read-only data section
# constants here, such as strings
# modifying these during runtime causes a segmentation fault, so be cautious!

prompt:     .string "Enter number of Fibonacci digits to print (0-40):\n" # prompt for user
fib_input:  .string "%d"    # format string for scanf
fib_output: .string "%d "   # format string for printf
newline:    .string "\n"   # newline

.text               # start of code section
.global main        # entry point for gcc

# === Fibonacci function ===
# Receives n in %rdi and prints n Fibonacci numbers
fib_loop:
    pushq %rbp
    movq %rsp, %rbp

    cmpl $0, %edi
    je fib_done

    movl %edi, %r11d        # save n
    movl $0, %r8d           # a = 0
    movl $1, %r9d           # b = 1
    movl $0, %r10d          # i = 0

fib_loop_start:
    cmpl %r11d, %r10d       # if i >= n
    jge fib_done

    movl %r8d, %esi         # print a
    leaq fib_output(%rip), %rdi
    call printf

    movl %r9d, %eax         # next = a + b
    addl %r8d, %eax

    movl %r9d, %r8d         # a = b
    movl %eax, %r9d         # b = next

    incl %r10d              # i++
    jmp fib_loop_start

fib_done:
    popq %rbp
    ret

# === Main function ===
main:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp              # stack alignment + space for input

    leaq prompt(%rip), %rdi
    call printf

    leaq fib_input(%rip), %rdi
    leaq -4(%rbp), %rsi
    xorq %rax, %rax
    call scanf

    movl -4(%rbp), %edi         # move input to %edi
    call fib_loop

    leaq newline(%rip), %rdi
    call printf

    addq $16, %rsp
    movq $0, %rax
    leave
    ret
