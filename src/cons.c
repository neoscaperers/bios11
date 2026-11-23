#include "cons.h"

void puts(const char* s) {
    char c;
    while ((c = *s++) != 0) {
        putc(c);
    }
}