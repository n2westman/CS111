
obj/schedos-4:     file format elf32-i386


Disassembly of section .text:

00500000 <start>:
			: "cc", "memory");
}

void
start(void)
{
  500000:	31 d2                	xor    %edx,%edx
#endif

static inline void
print(uint16_t toPrint)
{
	asm volatile("int %0\n"
  500002:	b8 34 0e 00 00       	mov    $0xe34,%eax
  500007:	cd 34                	int    $0x34
sys_yield(void)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_YIELD.
	asm volatile("int %0\n"
  500009:	cd 30                	int    $0x30
void
start(void)
{
	int i;
	
	for (i = 0; i < RUNCOUNT; i++) {
  50000b:	42                   	inc    %edx
  50000c:	81 fa 40 01 00 00    	cmp    $0x140,%edx
  500012:	75 f3                	jne    500007 <start+0x7>
	// the kernel can look up that register value to read the argument.
	// Here, the status is loaded into register %eax.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.
	asm volatile("int %0\n"
  500014:	31 c0                	xor    %eax,%eax
  500016:	cd 31                	int    $0x31
  500018:	eb fe                	jmp    500018 <start+0x18>
