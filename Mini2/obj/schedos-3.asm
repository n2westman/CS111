
obj/schedos-3:     file format elf32-i386


Disassembly of section .text:

00400000 <start>:
			: "cc", "memory");
}

void
start(void)
{
  400000:	31 d2                	xor    %edx,%edx
#endif

static inline void
print(uint16_t toPrint)
{
	asm volatile("int %0\n"
  400002:	b8 33 09 00 00       	mov    $0x933,%eax
  400007:	cd 34                	int    $0x34
sys_yield(void)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_YIELD.
	asm volatile("int %0\n"
  400009:	cd 30                	int    $0x30
void
start(void)
{
	int i;
	
	for (i = 0; i < RUNCOUNT; i++) {
  40000b:	42                   	inc    %edx
  40000c:	81 fa 40 01 00 00    	cmp    $0x140,%edx
  400012:	75 f3                	jne    400007 <start+0x7>
	// the kernel can look up that register value to read the argument.
	// Here, the status is loaded into register %eax.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.
	asm volatile("int %0\n"
  400014:	31 c0                	xor    %eax,%eax
  400016:	cd 31                	int    $0x31
  400018:	eb fe                	jmp    400018 <start+0x18>
