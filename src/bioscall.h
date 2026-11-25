#ifndef _BIOSCALL_H
#define _BIOSCALL_H

struct biosregs {
    int r0;
    int r1;
    int r2;
    int r3;
    int r4;
    int r5;
    int pc;
    int psw;
};

#define PSW_CARRY   1

#endif /*_BIOSCALL_H*/