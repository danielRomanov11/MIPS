        .globl main

        .data
pEnter:     .asciiz "Please enter an integer: "
pBin:       .asciiz "The binary is: "
pHex:       .asciiz "The hexadecimal is: "
pAgain:     .asciiz "Would you like to convert another integer? (0 or 1) "
nl:         .asciiz "\n"
hexPrefix:  .asciiz "0x"
hexLookup:  .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

        .text
main:
outer_loop:
        # prompt for integer
        li      $v0, 4
        la      $a0, pEnter
        syscall

        li      $v0, 5
        syscall
        move    $t0, $v0           

        # ---- Print binary ----
        li      $v0, 4
        la      $a0, pBin
        syscall

        beq     $t0, $zero, print_bin_zero

        # Find highest set bit index in $t6 (31..0)
        li      $t6, 31             
find_high:
        bltz    $t6, print_bin_zero 
        li      $t7, 1
        sllv    $t7, $t7, $t6       
        and     $t8, $t0, $t7
        bne     $t8, $zero, have_high
        addiu   $t6, $t6, -1
        b       find_high

have_high:
        # print from bit $t6 down to 0
print_bits:
        li      $t7, 1
        sllv    $t7, $t7, $t6
        and     $t8, $t0, $t7
        beq     $t8, $zero, print_zero_bit
        li      $v0, 11
        li      $a0, '1'
        syscall
        b       next_bit

print_zero_bit:
        li      $v0, 11
        li      $a0, '0'
        syscall

next_bit:
        addiu   $t6, $t6, -1
        bgez    $t6, print_bits

        # newline
        li      $v0, 4
        la      $a0, nl
        syscall
        b       print_hex

print_bin_zero:
        # n == 0 case
        li      $v0, 11
        li      $a0, '0'
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        # ---- Print hex ----
print_hex:
        li      $v0, 4
        la      $a0, pHex
        syscall

        # print "0x"
        li      $v0, 4
        la      $a0, hexPrefix
        syscall

        beq     $t0, $zero, hex_zero

        # Find highest non-zero nibble (start at nibble 7 for 32-bit: bits 28..31)
        li      $t1, 7              
find_high_nib:
        bltz    $t1, hex_zero       
        li      $t2, 0xF            
        sll     $t3, $t2, 0         
        sll     $t3, $t2, 0         
        sll     $t4, $t1, 2        
        srlv    $t5, $t0, $t4      
        andi    $t5, $t5, 0xF       
        bne     $t5, $zero, have_high_nib
        addiu   $t1, $t1, -1
        b       find_high_nib

have_high_nib:
        # Print from nibble $t1 down to 0 using lookup
print_nibbles:
        srlv    $t5, $t0, $t4       
        andi    $t5, $t5, 0xF       
        la      $t6, hexLookup
        addu    $t6, $t6, $t5
        lb      $t7, 0($t6)

        li      $v0, 11
        move    $a0, $t7
        syscall

        addiu   $t1, $t1, -1
        sll     $t4, $t1, 2
        bgez    $t1, print_nibbles

        # newline
        li      $v0, 4
        la      $a0, nl
        syscall
        b       ask_again

hex_zero:
        # if n == 0 → print single 0
        li      $v0, 11
        li      $a0, '0'
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

ask_again:
        li      $v0, 4
        la      $a0, pAgain
        syscall

        li      $v0, 5
        syscall
        beq     $v0, $zero, done    
        b       outer_loop          

done:
        li      $v0, 10
        syscall
