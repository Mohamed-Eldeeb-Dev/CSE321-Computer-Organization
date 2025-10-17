.data 
   msg1: .asciiz "Enter how many numbers you want to average: "
   msg2: .asciiz "Enter a number: "
   result: .asciiz "The average is: "
   newline: .asciiz "\n"

.text
  main:
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5
    syscall 
    move $t0, $v0

    li $t1, 0      
    li $t2, 0                 

  loop: 
    beq $t2, $t0, compute_average

    li $v0, 4
    la $a0, msg2
    syscall

    li $v0, 5
    syscall
    add $t1, $t1, $v0
    addi $t2, $t2, 1

    j loop

  compute_average:
    div $t1, $t0
    mflo $t3

    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newline 
    syscall

    li $v0, 10
    syscall