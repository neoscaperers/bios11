#include "csr.h"
#define PATTERN_LEN 24
    .text
    .even
    .globl _start
    .extern _main

_start:
    reset
    clr @$PSW
    mov $0xa000, sp
    mov $_timertick, @$0100
    clr @$0102
    mov $_trap, @$0004
    mov $003400, @$0006
    mov $0100, @$LKS
    jsr pc, _main
    halt

    .text

    .globl _putc
_putc:
    tstb @$XSTAT
    bpl _putc
    movb 2(sp), @$XBUF
    rts pc

    .globl _timertick
_timertick:
    mov r0, -(sp)
    inc @$_timer+2
    adc @$_timer
    swab @$_lightdebounce
    tstb @$_lightdebounce
    beq .1
    mov $_lightpattern, r0
    add @$_lightcycle, r0
    add $2, @$_lightcycle
    mov (r0), @$CONS
    cmp $(PATTERN_LEN*2)-2, @$_lightcycle
    bge .1
    clr @$_lightcycle
.1:
    mov (sp)+, r0
    rti

    .globl _trap
_trap:
    halt

    .globl ___main
___main:
    rts pc

    .data
    .globl _timer
_timer:
    .long 0

    .globl _lightpattern
_lightpattern:
    .word 0b1000000000000000
    .word 0b1000000000000000
    .word 0b1100000000000000
    .word 0b1100000000000000
    .word 0b0110000000000000
    .word 0b0001100000000000
    .word 0b0000011100000000
    .word 0b0000000011100000
    .word 0b0000000000011000
    .word 0b0000000000000110
    .word 0b0000000000000011
    .word 0b0000000000000011
    .word 0b0000000000000001
    .word 0b0000000000000001
    .word 0b0000000000000011
    .word 0b0000000000000011
    .word 0b0000000000000110
    .word 0b0000000000011000
    .word 0b0000000011100000
    .word 0b0000011100000000
    .word 0b0001100000000000
    .word 0b0110000000000000
    .word 0b1100000000000000
    .word 0b1100000000000000

    .globl _lightcycle
    .globl _lightdebounce
_lightcycle:
    .word 0
_lightdebounce:
    .word 1
