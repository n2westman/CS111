
obj/schedos-2:     file format elf32-i386


Disassembly of section .text:

00300000 <start>:
			: "cc", "memory");
}

void
start(void)
{
  300000:	31 d2                	xor    %edx,%edx
#endif

static inline void
print(uint16_t toPrint)
{
	asm volatile("int %0\n"
  300002:	b8 32 0a 00 00       	mov    $0xa32,%eax
  300007:	cd 34                	int    $0x34
sys_yield(void)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_YIELD.
	asm volatile("int %0\n"
  300009:	cd 30                	int    $0x30
void
start(void)
{
	int i;
	
	for (i = 0; i < RUNCOUNT; i++) {
  30000b:	42                   	inc    %edx
  30000c:	81 fa 40 01 00 00    	cmp    $0x140,%edx
  300012:	75 f3                	jne    300007 <start+0x7>
	// the kernel can look up that register value to read the argument.
	// Here, the status is loaded into register %eax.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.
	asm volatile("int %0\n"
  300014:	31 c0                	xor    %eax,%eax
  300016:	cd 31                	int    $0x31
  300018:	eb fe                	jmp    300018 <start+0x18>
