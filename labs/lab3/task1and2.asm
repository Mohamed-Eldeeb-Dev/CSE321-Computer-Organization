        .data
test1:      .asciiz "Test fib(0)\n"
test2:      .asciiz "Test fib(1)\n"
test3:      .asciiz "Test fib(2)\n"
test4:      .asciiz "Test fib(3)\n"
test5:      .asciiz "Test fib(4)\n"
test6:      .asciiz "Test fib(5)\n"
test7:      .asciiz "Test fib(6)\n"

labExpected: .asciiz "  Expected = "
labResult:   .asciiz "  Result   = "
passMsg:     .asciiz "  Test case passed!!\n\n"
failMsg:     .asciiz "  Test case failed!!\n\n"

newline:     .asciiz "\n"

        .text
        .globl main

# ======================================================
# fib: recursive Fibonacci (final correct version)
# Input: $a0 = n
# Output: $v0 = fib(n)
# Prologue/Epilogue save $ra, $s0 (n), $s1 (temp for fib(n-1))
# ======================================================
fib:
    # Save $ra, $s0, $s1 (12 bytes)
    addi $sp, $sp, -12
    sw   $s0, 0($sp)
    sw   $s1, 4($sp)
    sw   $ra, 8($sp)

    # store n in s0 (callee-saved)
    move $s0, $a0

    # base cases
    li   $t0, 0
    beq  $s0, $t0, fib_base0
    li   $t0, 1
    beq  $s0, $t0, fib_base1

    # compute fib(n-1)
    addi $a0, $s0, -1
    jal  fib
    move $s1, $v0       # s1 = fib(n-1)  (s1 is callee-saved so safe across calls)

    # compute fib(n-2)
    addi $a0, $s0, -2
    jal  fib            # result in $v0 = fib(n-2)

    add  $v0, $v0, $s1  # v0 = fib(n-2) + fib(n-1)

    # restore and return
    lw   $s0, 0($sp)
    lw   $s1, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra

fib_base0:
    li   $v0, 0
    lw   $s0, 0($sp)
    lw   $s1, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra

fib_base1:
    li   $v0, 1
    lw   $s0, 0($sp)
    lw   $s1, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra

# ======================================================
# assertEqual(expected, result, testLabelAddr)
# Properly preserves callee-saved registers and $ra
# ======================================================
assertEqual:
    # save callee-saved registers and ra (we'll use s0,s1,s2 here)
    addi $sp, $sp, -16
    sw   $s0, 0($sp)
    sw   $s1, 4($sp)
    sw   $s2, 8($sp)
    sw   $ra, 12($sp)

    # move inputs into s-registers so syscalls won't clobber them
    move $s0, $a0    # expected
    move $s1, $a1    # result
    move $s2, $a2    # label address

    # print test label (s2)
    li   $v0, 4
    move $a0, $s2
    syscall

    # print "  Expected = "
    li   $v0, 4
    la   $a0, labExpected
    syscall

    # print expected number (s0)
    li   $v0, 1
    move $a0, $s0
    syscall

    # newline
    li   $v0, 4
    la   $a0, newline
    syscall

    # print "  Result   = "
    li   $v0, 4
    la   $a0, labResult
    syscall

    # print result (s1)
    li   $v0, 1
    move $a0, $s1
    syscall

    # newline
    li   $v0, 4
    la   $a0, newline
    syscall

    # compare and print pass/fail
    beq  $s0, $s1, assert_pass
    li   $v0, 4
    la   $a0, failMsg
    syscall
    j    assert_done

assert_pass:
    li   $v0, 4
    la   $a0, passMsg
    syscall

assert_done:
    # restore saved regs and return
    lw   $s0, 0($sp)
    lw   $s1, 4($sp)
    lw   $s2, 8($sp)
    lw   $ra, 12($sp)
    addi $sp, $sp, 16
    jr   $ra

# ======================================================
# main: run tests and exit
# ======================================================
main:
    # Test 1: fib(0) expected 0
    li   $a0, 0
    jal  fib
    move $t0, $v0        # t0 = result
    li   $a0, 0          # expected
    move $a1, $t0        # result
    la   $a2, test1
    jal  assertEqual

    # Test 2: fib(1) expected 1
    li   $a0, 1
    jal  fib
    move $t0, $v0
    li   $a0, 1
    move $a1, $t0
    la   $a2, test2
    jal  assertEqual

    # Test 3: fib(2) expected 1
    li   $a0, 2
    jal  fib
    move $t0, $v0
    li   $a0, 1
    move $a1, $t0
    la   $a2, test3
    jal  assertEqual

    # Test 4: fib(3) expected 2
    li   $a0, 3
    jal  fib
    move $t0, $v0
    li   $a0, 2
    move $a1, $t0
    la   $a2, test4
    jal  assertEqual

    # Test 5: fib(4) expected 3
    li   $a0, 4
    jal  fib
    move $t0, $v0
    li   $a0, 3
    move $a1, $t0
    la   $a2, test5
    jal  assertEqual

    # Test 6: fib(5) expected 5
    li   $a0, 5
    jal  fib
    move $t0, $v0
    li   $a0, 5
    move $a1, $t0
    la   $a2, test6
    jal  assertEqual

    # Test 7: fib(6) expected 8
    li   $a0, 6
    jal  fib
    move $t0, $v0
    li   $a0, 8
    move $a1, $t0
    la   $a2, test7
    jal  assertEqual

    # exit
    li   $v0, 10
    syscall
