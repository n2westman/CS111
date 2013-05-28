#include "schedos-app.h"
#include "x86sync.h"

/*****************************************************************************
 * schedos-1
 *
 *   This tiny application prints red "1"s to the console.
 *   It yields the CPU to the kernel after each "1" using the sys_yield()
 *   system call.  This lets the kernel (schedos-kern.c) pick another
 *   application to run, if it wants.
 *
 *   The other schedos-* processes simply #include this file after defining
 *   PRINTCHAR appropriately.
 *
 *****************************************************************************/

#ifndef PRINTCHAR
#define PRINTCHAR	('1' | 0x0C00)
#endif

static inline void
print(uint16_t toPrint)
{
	asm volatile("int %0\n"
			: : "i" (INT_SYS_PRINTCHAR),
		            "a" (toPrint)
			: "cc", "memory");
}

void
start(void)
{
	int i;
	
	for (i = 0; i < RUNCOUNT; i++) {
		// Write characters to the console, yielding after each one.
		print((uint16_t)PRINTCHAR);
		sys_yield();
	}

	// Exit
	sys_exit(0);
}
