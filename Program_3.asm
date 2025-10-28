# Function 3 – Decimal (0..15) -> Hexadecimal (single hex digit)

.data
prompt:      .asciiz "Enter an integer (0-15): "
err:         .asciiz "Invalid input. Try again.\n"
newline:     .asciiz "\n"

# Step 1: lookup table for hex digits
hexLookup:   .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

.text
.globl main
main:
read_input:
    # print prompt
    li   $v0, 4
    la   $a0, prompt
    syscall

    # Step 2: read int, save to $t0
    li   $v0, 5
    syscall
    move $t0, $v0                # $t0 = input

    # range check: 0 <= $t0 <= 15
    slti $t4, $t0, 16            # t4 = 1 if t0 < 16
    slti $t5, $t0, 0             # t5 = 1 if t0 < 0
    beq  $t4, $zero, bad_input   # if t0 >= 16 -> bad
    bne  $t5, $zero, bad_input   # if t0 < 0   -> bad

    # Step 3: output hex digit
    la   $t1, hexLookup          # base address of table
    addu $t2, $t1, $t0           # t2 = &hexLookup[t0]
    lb   $t3, 0($t2)             # t3 = byte (the hex character)

    # print the character
    li   $v0, 11                 # print_char
    move $a0, $t3
    syscall

    # newline
    li   $v0, 4
    la   $a0, newline
    syscall

    # exit
    li   $v0, 10
    syscall

bad_input:
    li   $v0, 4
    la   $a0, err
    syscall
    j    read_input
