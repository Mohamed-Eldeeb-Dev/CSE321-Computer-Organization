.data
   num1: .asciiz "Enter first number: "
   num2: .asciiz "Enter second number: "
   num3: .asciiz "Enter third number: "
   num4: .asciiz "Enter fourth number: "
   result: .asciiz "The average of the four numbers is: "
   newline: .asciiz "\n"

.text
  main:
    
    li $v0, 4
    la $a0, num1
    syscall

    li $v0, 5
    syscall
    move $t0, $v0   

    li $v0, 4
    la $a0, num2
    syscall

    li $v0, 5
    syscall
    move $t1, $v0


    li $v0, 4
    la $a0, num3
    syscall

    li $v0, 5
    syscall
    move $t2, $v0
     
    li $v0, 4
    la $a0, num4
    syscall

    li $v0, 5
    syscall
    move $t3, $v0

    add $t4, $t0, $t1
    add $t4, $t4, $t2
    add $t4, $t4, $t3

    li $t5, 4
    div $t4, $t5
    mflo $t6

    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t6
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall