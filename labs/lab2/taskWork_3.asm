.data
    menu:       .asciiz "\nChoose an operation:\n1. Addition\n2. Subtraction\n3. Multiplication\nEnter your choice: "
    num1Msg:    .asciiz "Enter first number: "
    num2Msg:    .asciiz "Enter second number: "
    resultMsg:  .asciiz "Result = "
    invalidMsg: .asciiz "Invalid choice.\n"
    newline:    .asciiz "\n"

.text

    main:
        li $v0, 4
        la $a0, menu
        syscall

        li $v0, 5
        syscall
        move $t0, $v0

        li $v0, 4
        la $a0, num1Msg
        syscall

        li $v0, 5
        syscall
        move $t1, $v0

        li $v0, 4
        la $a0, num2Msg
        syscall

        li $v0, 5
        syscall
        move $t2, $v0

        beq $t0, 1, case_add
        beq $t0, 2, case_sub
        beq $t0, 3, case_mul
        j default_case

    case_add:
        add $t3, $t1, $t2
        j print_result

    case_sub:
        sub $t3, $t1, $t2
        j print_result

    case_mul:
        mul $t3, $t1, $t2
        j print_result

    default_case:
        li $v0, 4
        la $a0, invalidMsg
        syscall
        j end_program

    print_result:
        li $v0, 4
        la $a0, resultMsg
        syscall

        li $v0, 1
        move $a0, $t3
        syscall

        li $v0, 4
        la $a0, newline
        syscall

    end_program:
        li $v0, 10
        syscall
