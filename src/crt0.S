#include "csr.h"
#define PATTERN_LEN 20
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

    .globl _bioscall

    /*
     * -- stack layout --
     * 0(sp) - r0
     * 2(sp) - r1
     * 4(sp) - r2
     * 6(sp) - r3
     * 8(sp) - r4
     * 10(sp) - r5
     * 12(sp) - pc
     * 14(sp) - psw
     */
_bioscall:
    mov r5, -(r6)
    mov r4, -(r6)
    mov r3, -(r6)
    mov r2, -(r6)
    mov r1, -(r6)
    mov r0, -(r6)
    mov 12(sp), r0
    sub $2, r0
    cmpb (r0), $7
    ble .cont
    bis $1, 14(sp)
    br .sysret
.cont:
    bic $1, 14(sp)
    movb (r0), r0
    mov sp, -(sp)
    asl r0
    jsr pc, @_systable(r0)
.sysret:
    mov (r6)+, r0
    mov (r6)+, r1
    mov (r6)+, r2
    mov (r6)+, r3
    mov (r6)+, r4
    mov (r6)+, r5
    rti

    .globl _putc
_putc:
    tstb @$XSTAT
    bpl _putc
    movb 2(sp), @$XBUF
    rts pc

    .globl _timertick
_timertick:
    mov r0, -(sp)

    /* PDP-11 longs have mixed endian format, keep this in mind */
    inc @$_timer+2
    adc @$_timer
    swab @$_lightdebounce
    tstb @$_lightdebounce
    beq .1
    rolb @$_lightpattern+1
    rorb @$_lightpattern
    bcc .2
    bis $0b0000000110000000, @$_lightpattern
.2:
    mov @$_lightpattern, @$CONS
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
    .word 0b1111000000001111

    .globl _lightdebounce
_lightdebounce:
    .word 1

    .globl _systable
_systable:
    .word 0 /* TRAP 000 - return equipment list */
    .word 0 /* TRAP 001 - return conventional memory size */
    .word 0 /* TRAP 002 - disk services */
    .word 0 /* TRAP 003 - serial port services */
    .word 0 /* TRAP 004 - misc. services */
    .word 0 /* TRAP 005 - keyboard services */
    .word 0 /* TRAP 006 - boot fail*/
    .word 0 /* TRAP 007 - other */