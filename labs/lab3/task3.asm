        .data
A:      .word 4
B:      .word 6

msgResult: .asciiz "Result = "

        .text
        .globl main

# ===========================
# Function: compute(a, b)
# returns (a + b) * 2
# ===========================
compute:
    # Prologue: save $s0 (callee-saved)
    addi $sp, $sp, -4
    sw   $s0, 0($sp)

    add  $s0, $a0, $a1      # s0 = a + b
    sll  $v0, $s0, 1        # v0 = s0 * 2

    # Epilogue
    lw   $s0, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

# ===========================
# main function
# ===========================
main:
    # save $ra and $s0
    addi $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $s0, 0($sp)

    lw   $t0, A
    lw   $t1, B
    li   $s0, 99

    # call compute
    move $a0, $t0
    move $a1, $t1
    jal  compute

    move $t3, $v0       # store result into t3

    # ===============================
    # PRINT RESULT
    # ===============================

    # print text: "Result = "
    li   $v0, 4
    la   $a0, msgResult
    syscall

    # print number (value in t3)
    li   $v0, 1
    move $a0, $t3
    syscall

    # print newline
    li   $v0, 4
    la   $a0, msgResult+9   # OR use your own newline message
    syscall

    # restore saved registers
    lw   $s0, 0($sp)
    lw   $ra, 4($sp)
    addi $sp, $sp, 8

    jr   $ra
