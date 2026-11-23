#define PSW     0177776
#define CONS    0177570

/*
 * mmu hardware csrs
 */
#define SSR0    0177572
#define SSR1    0177574
#define SSR2    0177576
#define SSR3    0177516

/*
 * pdr/par pairs for each privilege level
 */
#define SPDRB   0172200
#define SPARB   0172240
#define KPDRB   0172300
#define KPARB   0172340
#define UPDRB   0177600
#define UPARB   0177640
#define STKLIM  0177774 /* paired with mmu registers as stack management is related */

/*
 * cpu trap vectors
 */
#define TRAPBUS 0000004
#define TRAPILL 0000010
#define TRAPBPT 0000014
#define TRAPIOT 0000020
#define TRAPPWR 0000024
#define TRAPEMT 0000030
#define TRAPSYS 0000034

#define XSTAT   0177564
#define XBUF    0177566
#define LKS     0177546