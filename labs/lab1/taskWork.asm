.data
    name: .asciiz "Name: Mohamed Abdelraziq Abdelraziq\n"
    id: .asciiz "ID: 20812021101323\n"
    course: .asciiz "Course: CSE321-Computer-Organization\n"

.text 
  main:
    li $v0, 4
    la $a0, name
    syscall

    li $v0, 4
    la $a0, id
    syscall

    li $v0, 4
    la $a0, course
    syscall

    li $v0, 10
    syscall   