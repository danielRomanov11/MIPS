# program.asm
.data
prompt1: .asciiz "Enter the first number: "
prompt2: .asciiz "Enter the length of the sequence: "
result: .asciiz "The sum is: "

.text
.globl main
main:
    # Prompt for the first number
    li $v0, 4
    la $a0, prompt1
    syscall

    # Read the first number
    li $v0, 5
    syscall
    move $t0, $v0  # Store the first number in $t0

    # Prompt for the length of the sequence
    li $v0, 4
    la $a0, prompt2
    syscall

    # Read the length of the sequence
    li $v0, 5
    syscall
    move $t1, $v0  # Store the length in $t1

    # Initialize the sum
    li $t2, 0  # $t2 will hold the sum

    # Loop to calculate the sum
    li $t3, 0  # $t3 is the loop counter
    loop:
        add $t2, $t2, $t0  # Add the current number to the sum
        addi $t0, $t0, 1  # Increment the number
        addi $t3, $t3, 1  # Increment the loop counter
        blt $t3, $t1, loop  # Continue if the loop counter is less than the length

    # Print the result
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    # Exit
    li $v0, 10
    syscall

