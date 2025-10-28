        .globl main

        .data
prompt:         .asciiz "Enter hour (1-23, 12 = noon): "
msgMorning:     .asciiz "It is morning.\n"
msgNoon:        .asciiz "It is noon.\n"
msgAfternoon:   .asciiz "It is afternoon.\n"
msgInvalid:     .asciiz "Invalid hour.\n"

        .text
main:
        li      $v0, 4
        la      $a0, prompt
        syscall

        li      $v0, 5
        syscall
        move    $t1, $v0

        blt     $t1, 1, invalid
        bgt     $t1, 23, invalid

        li      $t0, 12
        beq     $t1, $t0, noon

        blt     $t1, 12, morning

        b       afternoon

morning:
        li      $v0, 4
        la      $a0, msgMorning
        syscall
        b       exit

noon:
        li      $v0, 4
        la      $a0, msgNoon
        syscall
        b       exit

afternoon:
        li      $v0, 4
        la      $a0, msgAfternoon
        syscall
        b       exit

invalid:
        li      $v0, 4
        la      $a0, msgInvalid
        syscall

exit:
        li      $v0, 10
        syscall
