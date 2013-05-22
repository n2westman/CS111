
obj/schedos-kern:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4 bc                	in     $0xbc,%al

0010000c <multiboot_start>:
# The multiboot_start routine sets the stack pointer to the top of the
# SchedOS's kernel stack, then jumps to the 'start' routine in schedos-kern.c.

.globl multiboot_start
multiboot_start:
	movl $0x180000, %esp
  10000c:	bc 00 00 18 00       	mov    $0x180000,%esp
	pushl $0
  100011:	6a 00                	push   $0x0
	popfl
  100013:	9d                   	popf   
	call start
  100014:	e8 1b 02 00 00       	call   100234 <start>
  100019:	90                   	nop

0010001a <clock_int_handler>:
# Interrupt handlers
.align 2

	.globl clock_int_handler
clock_int_handler:
	pushl $0		// error code
  10001a:	6a 00                	push   $0x0
	pushl $32		// trap number
  10001c:	6a 20                	push   $0x20
	jmp _generic_int_handler
  10001e:	eb 40                	jmp    100060 <_generic_int_handler>

00100020 <sys_int48_handler>:

sys_int48_handler:
	pushl $0
  100020:	6a 00                	push   $0x0
	pushl $48
  100022:	6a 30                	push   $0x30
	jmp _generic_int_handler
  100024:	eb 3a                	jmp    100060 <_generic_int_handler>

00100026 <sys_int49_handler>:

sys_int49_handler:
	pushl $0
  100026:	6a 00                	push   $0x0
	pushl $49
  100028:	6a 31                	push   $0x31
	jmp _generic_int_handler
  10002a:	eb 34                	jmp    100060 <_generic_int_handler>

0010002c <sys_int50_handler>:

sys_int50_handler:
	pushl $0
  10002c:	6a 00                	push   $0x0
	pushl $50
  10002e:	6a 32                	push   $0x32
	jmp _generic_int_handler
  100030:	eb 2e                	jmp    100060 <_generic_int_handler>

00100032 <sys_int51_handler>:

sys_int51_handler:
	pushl $0
  100032:	6a 00                	push   $0x0
	pushl $51
  100034:	6a 33                	push   $0x33
	jmp _generic_int_handler
  100036:	eb 28                	jmp    100060 <_generic_int_handler>

00100038 <sys_int52_handler>:

sys_int52_handler:
	pushl $0
  100038:	6a 00                	push   $0x0
	pushl $52
  10003a:	6a 34                	push   $0x34
	jmp _generic_int_handler
  10003c:	eb 22                	jmp    100060 <_generic_int_handler>

0010003e <sys_int53_handler>:

sys_int53_handler:
	pushl $0
  10003e:	6a 00                	push   $0x0
	pushl $53
  100040:	6a 35                	push   $0x35
	jmp _generic_int_handler
  100042:	eb 1c                	jmp    100060 <_generic_int_handler>

00100044 <sys_int54_handler>:

sys_int54_handler:
	pushl $0
  100044:	6a 00                	push   $0x0
	pushl $54
  100046:	6a 36                	push   $0x36
	jmp _generic_int_handler
  100048:	eb 16                	jmp    100060 <_generic_int_handler>

0010004a <sys_int55_handler>:

sys_int55_handler:
	pushl $0
  10004a:	6a 00                	push   $0x0
	pushl $55
  10004c:	6a 37                	push   $0x37
	jmp _generic_int_handler
  10004e:	eb 10                	jmp    100060 <_generic_int_handler>

00100050 <sys_int56_handler>:

sys_int56_handler:
	pushl $0
  100050:	6a 00                	push   $0x0
	pushl $56
  100052:	6a 38                	push   $0x38
	jmp _generic_int_handler
  100054:	eb 0a                	jmp    100060 <_generic_int_handler>

00100056 <sys_int57_handler>:

sys_int57_handler:
	pushl $0
  100056:	6a 00                	push   $0x0
	pushl $57
  100058:	6a 39                	push   $0x39
	jmp _generic_int_handler
  10005a:	eb 04                	jmp    100060 <_generic_int_handler>

0010005c <default_int_handler>:

	.globl default_int_handler
default_int_handler:
	pushl $0
  10005c:	6a 00                	push   $0x0
	jmp _generic_int_handler
  10005e:	eb 00                	jmp    100060 <_generic_int_handler>

00100060 <_generic_int_handler>:
	# When we get here, the processor's interrupt mechanism has
	# pushed the old task status and stack registers onto the kernel stack.
	# Then one of the specific handlers pushed the trap number.
	# Now, we complete the 'registers_t' structure by pushing the extra
	# segment definitions and the general CPU registers.
	pushl %ds
  100060:	1e                   	push   %ds
	pushl %es
  100061:	06                   	push   %es
	pushal
  100062:	60                   	pusha  

	# Load the kernel's data segments into the extra segment registers
	# (although we don't use those extra segments!).
	movl $0x10, %eax
  100063:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds
  100068:	8e d8                	mov    %eax,%ds
	movw %ax, %es
  10006a:	8e c0                	mov    %eax,%es

	# Call the kernel's 'interrupt' function.
	pushl %esp
  10006c:	54                   	push   %esp
	call interrupt
  10006d:	e8 51 01 00 00       	call   1001c3 <interrupt>

00100072 <sys_int_handlers>:
  100072:	20 00                	and    %al,(%eax)
  100074:	10 00                	adc    %al,(%eax)
  100076:	26 00 10             	add    %dl,%es:(%eax)
  100079:	00 2c 00             	add    %ch,(%eax,%eax,1)
  10007c:	10 00                	adc    %al,(%eax)
  10007e:	32 00                	xor    (%eax),%al
  100080:	10 00                	adc    %al,(%eax)
  100082:	38 00                	cmp    %al,(%eax)
  100084:	10 00                	adc    %al,(%eax)
  100086:	3e 00 10             	add    %dl,%ds:(%eax)
  100089:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
  10008d:	00 4a 00             	add    %cl,0x0(%edx)
  100090:	10 00                	adc    %al,(%eax)
  100092:	50                   	push   %eax
  100093:	00 10                	add    %dl,(%eax)
  100095:	00 56 00             	add    %dl,0x0(%esi)
  100098:	10 00                	adc    %al,(%eax)
  10009a:	90                   	nop
  10009b:	90                   	nop

0010009c <schedule>:
 *****************************************************************************/

void
schedule(void)
{
	pid_t pid = current->p_pid;
  10009c:	a1 58 7a 10 00       	mov    0x107a58,%eax
 *
 *****************************************************************************/

void
schedule(void)
{
  1000a1:	57                   	push   %edi
  1000a2:	56                   	push   %esi
  1000a3:	53                   	push   %ebx
	pid_t pid = current->p_pid;
  1000a4:	8b 08                	mov    (%eax),%ecx
	uint32_t priority = current->p_priority;
  1000a6:	8b 70 04             	mov    0x4(%eax),%esi
	
	if (scheduling_algorithm == 0)
  1000a9:	a1 5c 7a 10 00       	mov    0x107a5c,%eax
  1000ae:	85 c0                	test   %eax,%eax
  1000b0:	75 1e                	jne    1000d0 <schedule+0x34>
		while (1) {
			pid = (pid + 1) % NPROCS;
  1000b2:	bb 05 00 00 00       	mov    $0x5,%ebx
  1000b7:	8d 41 01             	lea    0x1(%ecx),%eax
  1000ba:	99                   	cltd   
  1000bb:	f7 fb                	idiv   %ebx

			// Run the selected process, but skip
			// non-runnable processes.
			// Note that the 'run' function does not return.
			if (proc_array[pid].p_state == P_RUNNABLE)
  1000bd:	6b c2 5c             	imul   $0x5c,%edx,%eax
	pid_t pid = current->p_pid;
	uint32_t priority = current->p_priority;
	
	if (scheduling_algorithm == 0)
		while (1) {
			pid = (pid + 1) % NPROCS;
  1000c0:	89 d1                	mov    %edx,%ecx

			// Run the selected process, but skip
			// non-runnable processes.
			// Note that the 'run' function does not return.
			if (proc_array[pid].p_state == P_RUNNABLE)
  1000c2:	83 b8 78 70 10 00 01 	cmpl   $0x1,0x107078(%eax)
  1000c9:	75 ec                	jne    1000b7 <schedule+0x1b>
  1000cb:	e9 ba 00 00 00       	jmp    10018a <schedule+0xee>
				run(&proc_array[pid]);
		}
	
	else if(scheduling_algorithm == 1)
  1000d0:	83 f8 01             	cmp    $0x1,%eax
  1000d3:	75 37                	jne    10010c <schedule+0x70>
  1000d5:	ba 01 00 00 00       	mov    $0x1,%edx
		while(1) {
			for(pid = 1; pid < NPROCS; pid++) {
				if (proc_array[pid].p_state == P_RUNNABLE)
  1000da:	6b c8 5c             	imul   $0x5c,%eax,%ecx
  1000dd:	83 b9 78 70 10 00 01 	cmpl   $0x1,0x107078(%ecx)
  1000e4:	75 12                	jne    1000f8 <schedule+0x5c>
				{
					run(&proc_array[pid]);
  1000e6:	6b d2 5c             	imul   $0x5c,%edx,%edx
  1000e9:	83 ec 0c             	sub    $0xc,%esp
  1000ec:	81 c2 24 70 10 00    	add    $0x107024,%edx
  1000f2:	52                   	push   %edx
  1000f3:	e8 25 04 00 00       	call   10051d <run>
				run(&proc_array[pid]);
		}
	
	else if(scheduling_algorithm == 1)
		while(1) {
			for(pid = 1; pid < NPROCS; pid++) {
  1000f8:	40                   	inc    %eax
  1000f9:	83 f8 04             	cmp    $0x4,%eax
			// Note that the 'run' function does not return.
			if (proc_array[pid].p_state == P_RUNNABLE)
				run(&proc_array[pid]);
		}
	
	else if(scheduling_algorithm == 1)
  1000fc:	89 c2                	mov    %eax,%edx
		while(1) {
			for(pid = 1; pid < NPROCS; pid++) {
  1000fe:	7e da                	jle    1000da <schedule+0x3e>
  100100:	ba 01 00 00 00       	mov    $0x1,%edx
  100105:	b8 01 00 00 00       	mov    $0x1,%eax
  10010a:	eb ce                	jmp    1000da <schedule+0x3e>
					run(&proc_array[pid]);
				}
			}
		}
		
	else if(scheduling_algorithm == 2)
  10010c:	83 f8 02             	cmp    $0x2,%eax
  10010f:	75 40                	jne    100151 <schedule+0xb5>
  100111:	89 cb                	mov    %ecx,%ebx
		while(1) {
			while((pid = (pid+1)%NPROCS) != current->p_pid) {
  100113:	bf 05 00 00 00       	mov    $0x5,%edi
  100118:	eb 14                	jmp    10012e <schedule+0x92>
				if (proc_array[pid].p_state == P_RUNNABLE &&
  10011a:	6b c3 5c             	imul   $0x5c,%ebx,%eax
  10011d:	83 b8 78 70 10 00 01 	cmpl   $0x1,0x107078(%eax)
  100124:	75 08                	jne    10012e <schedule+0x92>
  100126:	39 b0 28 70 10 00    	cmp    %esi,0x107028(%eax)
  10012c:	74 5c                	je     10018a <schedule+0xee>
			}
		}
		
	else if(scheduling_algorithm == 2)
		while(1) {
			while((pid = (pid+1)%NPROCS) != current->p_pid) {
  10012e:	8d 43 01             	lea    0x1(%ebx),%eax
  100131:	99                   	cltd   
  100132:	f7 ff                	idiv   %edi
  100134:	39 ca                	cmp    %ecx,%edx
  100136:	89 d3                	mov    %edx,%ebx
  100138:	75 e0                	jne    10011a <schedule+0x7e>
					run(&proc_array[pid]);
				}
				
			}
	
			if(proc_array[pid].p_state == P_RUNNABLE)
  10013a:	6b c2 5c             	imul   $0x5c,%edx,%eax
  10013d:	83 b8 78 70 10 00 01 	cmpl   $0x1,0x107078(%eax)
  100144:	74 44                	je     10018a <schedule+0xee>
				run(&proc_array[pid]);
			//We have NPROCS unique priorities
			priority = (priority + 1) % NPROCS;
  100146:	8d 46 01             	lea    0x1(%esi),%eax
  100149:	31 d2                	xor    %edx,%edx
  10014b:	f7 f7                	div    %edi
  10014d:	89 d6                	mov    %edx,%esi
  10014f:	eb dd                	jmp    10012e <schedule+0x92>
		}
		
	else if(scheduling_algorithm == 3)
  100151:	83 f8 03             	cmp    $0x3,%eax
  100154:	75 4c                	jne    1001a2 <schedule+0x106>
				proc_array[pid].p_times_run < proc_array[pid].p_share)
			{
				proc_array[pid].p_times_run++;
				run(&proc_array[pid]);
			}
			pid = (pid + 1) % NPROCS;
  100156:	bb 05 00 00 00       	mov    $0x5,%ebx
			priority = (priority + 1) % NPROCS;
		}
		
	else if(scheduling_algorithm == 3)
		while(1) {
			if( proc_array[pid].p_state == P_RUNNABLE &&
  10015b:	6b c1 5c             	imul   $0x5c,%ecx,%eax
  10015e:	83 b8 78 70 10 00 01 	cmpl   $0x1,0x107078(%eax)
  100165:	75 31                	jne    100198 <schedule+0xfc>
				proc_array[pid].p_times_run == proc_array[pid].p_share)
  100167:	8b 90 30 70 10 00    	mov    0x107030(%eax),%edx
			priority = (priority + 1) % NPROCS;
		}
		
	else if(scheduling_algorithm == 3)
		while(1) {
			if( proc_array[pid].p_state == P_RUNNABLE &&
  10016d:	3b 90 2c 70 10 00    	cmp    0x10702c(%eax),%edx
  100173:	75 0c                	jne    100181 <schedule+0xe5>
				proc_array[pid].p_times_run == proc_array[pid].p_share)
				proc_array[pid].p_times_run = 0;
  100175:	c7 80 30 70 10 00 00 	movl   $0x0,0x107030(%eax)
  10017c:	00 00 00 
			priority = (priority + 1) % NPROCS;
		}
		
	else if(scheduling_algorithm == 3)
		while(1) {
			if( proc_array[pid].p_state == P_RUNNABLE &&
  10017f:	eb 17                	jmp    100198 <schedule+0xfc>
				proc_array[pid].p_times_run == proc_array[pid].p_share)
				proc_array[pid].p_times_run = 0;
			
			else if( proc_array[pid].p_state == P_RUNNABLE &&
  100181:	73 15                	jae    100198 <schedule+0xfc>
				proc_array[pid].p_times_run < proc_array[pid].p_share)
			{
				proc_array[pid].p_times_run++;
  100183:	42                   	inc    %edx
  100184:	89 90 30 70 10 00    	mov    %edx,0x107030(%eax)
				run(&proc_array[pid]);
  10018a:	83 ec 0c             	sub    $0xc,%esp
  10018d:	05 24 70 10 00       	add    $0x107024,%eax
  100192:	50                   	push   %eax
  100193:	e9 5b ff ff ff       	jmp    1000f3 <schedule+0x57>
			}
			pid = (pid + 1) % NPROCS;
  100198:	8d 41 01             	lea    0x1(%ecx),%eax
  10019b:	99                   	cltd   
  10019c:	f7 fb                	idiv   %ebx
  10019e:	89 d1                	mov    %edx,%ecx
		}
  1001a0:	eb b9                	jmp    10015b <schedule+0xbf>
	// If we get here, we are running an unknown scheduling algorithm.
	cursorpos = console_printf(cursorpos, 0x100, "\nUnknown scheduling algorithm %d\n", scheduling_algorithm);
  1001a2:	8b 15 00 80 19 00    	mov    0x198000,%edx
  1001a8:	50                   	push   %eax
  1001a9:	68 dc 0a 10 00       	push   $0x100adc
  1001ae:	68 00 01 00 00       	push   $0x100
  1001b3:	52                   	push   %edx
  1001b4:	e8 09 09 00 00       	call   100ac2 <console_printf>
  1001b9:	83 c4 10             	add    $0x10,%esp
  1001bc:	a3 00 80 19 00       	mov    %eax,0x198000
  1001c1:	eb fe                	jmp    1001c1 <schedule+0x125>

001001c3 <interrupt>:
 *
 *****************************************************************************/

void
interrupt(registers_t *reg)
{
  1001c3:	57                   	push   %edi
	// Save the current process's register state
	// into its process descriptor
	current->p_registers = *reg;
  1001c4:	a1 58 7a 10 00       	mov    0x107a58,%eax
  1001c9:	b9 11 00 00 00       	mov    $0x11,%ecx
 *
 *****************************************************************************/

void
interrupt(registers_t *reg)
{
  1001ce:	56                   	push   %esi
  1001cf:	53                   	push   %ebx
  1001d0:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	// Save the current process's register state
	// into its process descriptor
	current->p_registers = *reg;
  1001d4:	8d 78 10             	lea    0x10(%eax),%edi
  1001d7:	89 de                	mov    %ebx,%esi
  1001d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	switch (reg->reg_intno) {
  1001db:	8b 53 28             	mov    0x28(%ebx),%edx
  1001de:	83 fa 31             	cmp    $0x31,%edx
  1001e1:	74 1f                	je     100202 <interrupt+0x3f>
  1001e3:	77 0c                	ja     1001f1 <interrupt+0x2e>
  1001e5:	83 fa 20             	cmp    $0x20,%edx
  1001e8:	74 43                	je     10022d <interrupt+0x6a>
  1001ea:	83 fa 30             	cmp    $0x30,%edx
  1001ed:	74 0e                	je     1001fd <interrupt+0x3a>
  1001ef:	eb 41                	jmp    100232 <interrupt+0x6f>
  1001f1:	83 fa 32             	cmp    $0x32,%edx
  1001f4:	74 23                	je     100219 <interrupt+0x56>
  1001f6:	83 fa 33             	cmp    $0x33,%edx
  1001f9:	74 29                	je     100224 <interrupt+0x61>
  1001fb:	eb 35                	jmp    100232 <interrupt+0x6f>

	case INT_SYS_YIELD:
		// The 'sys_yield' system call asks the kernel to schedule
		// the next process.
		schedule();
  1001fd:	e8 9a fe ff ff       	call   10009c <schedule>
		// The application stored its exit status in the %eax register
		// before calling the system call.  The %eax register has
		// changed by now, but we can read the application's value
		// out of the 'reg' argument.
		// (This shows you how to transfer arguments to system calls!)
		current->p_state = P_ZOMBIE;
  100202:	a1 58 7a 10 00       	mov    0x107a58,%eax
		current->p_exit_status = reg->reg_eax;
  100207:	8b 53 1c             	mov    0x1c(%ebx),%edx
		// The application stored its exit status in the %eax register
		// before calling the system call.  The %eax register has
		// changed by now, but we can read the application's value
		// out of the 'reg' argument.
		// (This shows you how to transfer arguments to system calls!)
		current->p_state = P_ZOMBIE;
  10020a:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		current->p_exit_status = reg->reg_eax;
  100211:	89 50 58             	mov    %edx,0x58(%eax)
		schedule();
  100214:	e8 83 fe ff ff       	call   10009c <schedule>

	case INT_SYS_USER1:
		// 'sys_user*' are provided for your convenience, in case you
		// want to add a system call.
		/* Your code here (if you want). */
		run(current);
  100219:	83 ec 0c             	sub    $0xc,%esp
  10021c:	ff 35 58 7a 10 00    	pushl  0x107a58
  100222:	eb 04                	jmp    100228 <interrupt+0x65>

	case INT_SYS_USER2:
		/* Your code here (if you want). */
		run(current);
  100224:	83 ec 0c             	sub    $0xc,%esp
  100227:	50                   	push   %eax
  100228:	e8 f0 02 00 00       	call   10051d <run>

	case INT_CLOCK:
		// A clock interrupt occurred (so an application exhausted its
		// time quantum).
		// Switch to the next runnable process.
		schedule();
  10022d:	e8 6a fe ff ff       	call   10009c <schedule>
  100232:	eb fe                	jmp    100232 <interrupt+0x6f>

00100234 <start>:
 *
 *****************************************************************************/

void
start(void)
{
  100234:	55                   	push   %ebp
  100235:	57                   	push   %edi
  100236:	56                   	push   %esi
  100237:	53                   	push   %ebx
  100238:	83 ec 0c             	sub    $0xc,%esp
	int i;

	// Set up hardware (schedos-x86.c)
	segments_init();
  10023b:	e8 bc 00 00 00       	call   1002fc <segments_init>
	interrupt_controller_init(0);
  100240:	83 ec 0c             	sub    $0xc,%esp
  100243:	6a 00                	push   $0x0
  100245:	e8 ad 01 00 00       	call   1003f7 <interrupt_controller_init>
	console_clear();
  10024a:	e8 31 02 00 00       	call   100480 <console_clear>

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
  10024f:	83 c4 0c             	add    $0xc,%esp
  100252:	68 cc 01 00 00       	push   $0x1cc
  100257:	6a 00                	push   $0x0
  100259:	68 24 70 10 00       	push   $0x107024
  10025e:	e8 fd 03 00 00       	call   100660 <memset>
  100263:	ba 24 70 10 00       	mov    $0x107024,%edx
  100268:	31 c0                	xor    %eax,%eax
  10026a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
	
		// Initialize priority
		proc_array[i].p_priority = NPROCS - i;
  10026d:	b9 05 00 00 00       	mov    $0x5,%ecx
  100272:	89 cb                	mov    %ecx,%ebx
  100274:	29 c3                	sub    %eax,%ebx
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  100276:	89 02                	mov    %eax,(%edx)
	interrupt_controller_init(0);
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  100278:	40                   	inc    %eax
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  100279:	c7 42 54 00 00 00 00 	movl   $0x0,0x54(%edx)
	
		// Initialize priority
		proc_array[i].p_priority = NPROCS - i;
  100280:	89 5a 04             	mov    %ebx,0x4(%edx)
	interrupt_controller_init(0);
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  100283:	83 c2 5c             	add    $0x5c,%edx
  100286:	83 f8 05             	cmp    $0x5,%eax
  100289:	75 e7                	jne    100272 <start+0x3e>
  10028b:	bb 88 70 10 00       	mov    $0x107088,%ebx
  100290:	bf 00 00 30 00       	mov    $0x300000,%edi
  100295:	be 04 00 00 00       	mov    $0x4,%esi
		
		// Set ESP
		proc->p_registers.reg_esp = stack_ptr;

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);
  10029a:	bd 04 00 00 00       	mov    $0x4,%ebp
	interrupt_controller_init(0);
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  10029f:	8d 43 f8             	lea    -0x8(%ebx),%eax
	for (i = 1; i < NPROCS; i++) {
		process_t *proc = &proc_array[i];
		uint32_t stack_ptr = PROC1_START + i * PROC_SIZE;

		// Initialize the process descriptor
		special_registers_init(proc);
  1002a2:	83 ec 0c             	sub    $0xc,%esp
  1002a5:	50                   	push   %eax
  1002a6:	e8 89 02 00 00       	call   100534 <special_registers_init>

		proc_array[i].p_times_run = proc_array[i].p_share = NPROCS - i;
  1002ab:	89 33                	mov    %esi,(%ebx)
  1002ad:	89 73 04             	mov    %esi,0x4(%ebx)
		
		// Set ESP
		proc->p_registers.reg_esp = stack_ptr;
  1002b0:	89 7b 44             	mov    %edi,0x44(%ebx)

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);

		// Mark the process as runnable!
		proc->p_state = P_RUNNABLE;
  1002b3:	81 c7 00 00 10 00    	add    $0x100000,%edi
		
		// Set ESP
		proc->p_registers.reg_esp = stack_ptr;

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);
  1002b9:	58                   	pop    %eax
  1002ba:	5a                   	pop    %edx
  1002bb:	8d 43 38             	lea    0x38(%ebx),%eax
  1002be:	50                   	push   %eax
  1002bf:	89 e8                	mov    %ebp,%eax
  1002c1:	29 f0                	sub    %esi,%eax
  1002c3:	50                   	push   %eax
  1002c4:	e8 a7 02 00 00       	call   100570 <program_loader>
	
	//The two loops differ upon instantiation, the second loop never looks at i == 0
	//Thus this program never uses proc_array[0].

	// Set up process descriptors (the proc_array[])
	for (i = 1; i < NPROCS; i++) {
  1002c9:	83 c4 10             	add    $0x10,%esp

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);

		// Mark the process as runnable!
		proc->p_state = P_RUNNABLE;
  1002cc:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
  1002d3:	83 c3 5c             	add    $0x5c,%ebx
	
	//The two loops differ upon instantiation, the second loop never looks at i == 0
	//Thus this program never uses proc_array[0].

	// Set up process descriptors (the proc_array[])
	for (i = 1; i < NPROCS; i++) {
  1002d6:	4e                   	dec    %esi
  1002d7:	75 c6                	jne    10029f <start+0x6b>

	// Initialize the scheduling algorithm.
	scheduling_algorithm = 3;

	// Switch to the first process.
	run(&proc_array[1]);
  1002d9:	83 ec 0c             	sub    $0xc,%esp
  1002dc:	68 80 70 10 00       	push   $0x107080
		proc->p_state = P_RUNNABLE;
	}

	// Initialize the cursor-position shared variable to point to the
	// console's first character (the upper left).
	cursorpos = (uint16_t *) 0xB8000;
  1002e1:	c7 05 00 80 19 00 00 	movl   $0xb8000,0x198000
  1002e8:	80 0b 00 

	// Initialize the scheduling algorithm.
	scheduling_algorithm = 3;
  1002eb:	c7 05 5c 7a 10 00 03 	movl   $0x3,0x107a5c
  1002f2:	00 00 00 

	// Switch to the first process.
	run(&proc_array[1]);
  1002f5:	e8 23 02 00 00       	call   10051d <run>
  1002fa:	90                   	nop
  1002fb:	90                   	nop

001002fc <segments_init>:
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002fc:	b8 f0 71 10 00       	mov    $0x1071f0,%eax
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100301:	b9 5c 00 10 00       	mov    $0x10005c,%ecx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100306:	89 c2                	mov    %eax,%edx
  100308:	c1 ea 10             	shr    $0x10,%edx
extern void default_int_handler(void);


void
segments_init(void)
{
  10030b:	53                   	push   %ebx
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  10030c:	bb 5c 00 10 00       	mov    $0x10005c,%ebx
  100311:	c1 eb 10             	shr    $0x10,%ebx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100314:	66 a3 3a 10 10 00    	mov    %ax,0x10103a
  10031a:	c1 e8 18             	shr    $0x18,%eax
  10031d:	88 15 3c 10 10 00    	mov    %dl,0x10103c
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100323:	ba 58 72 10 00       	mov    $0x107258,%edx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100328:	a2 3f 10 10 00       	mov    %al,0x10103f
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  10032d:	31 c0                	xor    %eax,%eax
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  10032f:	66 c7 05 38 10 10 00 	movw   $0x68,0x101038
  100336:	68 00 
  100338:	c6 05 3e 10 10 00 40 	movb   $0x40,0x10103e
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
			sizeof(taskstate_t), 0);
	segments[SEGSEL_TASKSTATE >> 3].sd_s = 0;
  10033f:	c6 05 3d 10 10 00 89 	movb   $0x89,0x10103d

	// Set up kernel task descriptor, so we can receive interrupts
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
  100346:	c7 05 f4 71 10 00 00 	movl   $0x180000,0x1071f4
  10034d:	00 18 00 
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;
  100350:	66 c7 05 f8 71 10 00 	movw   $0x10,0x1071f8
  100357:	10 00 

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100359:	66 89 0c c5 58 72 10 	mov    %cx,0x107258(,%eax,8)
  100360:	00 
  100361:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  100368:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  10036d:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  100372:	66 89 5c c2 06       	mov    %bx,0x6(%edx,%eax,8)
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
  100377:	40                   	inc    %eax
  100378:	3d 00 01 00 00       	cmp    $0x100,%eax
  10037d:	75 da                	jne    100359 <segments_init+0x5d>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// The clock interrupt gets special handling
	SETGATE(interrupt_descriptors[INT_CLOCK], 0,
  10037f:	b8 1a 00 10 00       	mov    $0x10001a,%eax

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_YIELD; i < INT_SYS_YIELD + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  100384:	ba 58 72 10 00       	mov    $0x107258,%edx
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// The clock interrupt gets special handling
	SETGATE(interrupt_descriptors[INT_CLOCK], 0,
  100389:	66 a3 58 73 10 00    	mov    %ax,0x107358
  10038f:	c1 e8 10             	shr    $0x10,%eax
  100392:	66 a3 5e 73 10 00    	mov    %ax,0x10735e
  100398:	b8 30 00 00 00       	mov    $0x30,%eax
  10039d:	66 c7 05 5a 73 10 00 	movw   $0x8,0x10735a
  1003a4:	08 00 
  1003a6:	c6 05 5c 73 10 00 00 	movb   $0x0,0x10735c
  1003ad:	c6 05 5d 73 10 00 8e 	movb   $0x8e,0x10735d

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_YIELD; i < INT_SYS_YIELD + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  1003b4:	8b 0c 85 b2 ff 0f 00 	mov    0xfffb2(,%eax,4),%ecx
  1003bb:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  1003c2:	66 89 0c c5 58 72 10 	mov    %cx,0x107258(,%eax,8)
  1003c9:	00 
  1003ca:	c1 e9 10             	shr    $0x10,%ecx
  1003cd:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  1003d2:	c6 44 c2 05 ee       	movb   $0xee,0x5(%edx,%eax,8)
  1003d7:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
		SEGSEL_KERN_CODE, clock_int_handler, 0);

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_YIELD; i < INT_SYS_YIELD + 10; i++)
  1003dc:	40                   	inc    %eax
  1003dd:	83 f8 3a             	cmp    $0x3a,%eax
  1003e0:	75 d2                	jne    1003b4 <segments_init+0xb8>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, sys_int_handlers[i - INT_SYS_YIELD], 3);

	// Reload segment pointers
	asm volatile("lgdt global_descriptor_table\n\t"
  1003e2:	b0 28                	mov    $0x28,%al
  1003e4:	0f 01 15 00 10 10 00 	lgdtl  0x101000
  1003eb:	0f 00 d8             	ltr    %ax
  1003ee:	0f 01 1d 08 10 10 00 	lidtl  0x101008
		     "lidt interrupt_descriptor_table"
		     : : "r" ((uint16_t) SEGSEL_TASKSTATE));

	// Convince compiler that all symbols were used
	(void) global_descriptor_table, (void) interrupt_descriptor_table;
}
  1003f5:	5b                   	pop    %ebx
  1003f6:	c3                   	ret    

001003f7 <interrupt_controller_init>:
#define	TIMER_FREQ	1193182
#define TIMER_DIV(x)	((TIMER_FREQ+(x)/2)/(x))

void
interrupt_controller_init(bool_t allow_clock_interrupt)
{
  1003f7:	55                   	push   %ebp
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1003f8:	b0 ff                	mov    $0xff,%al
  1003fa:	57                   	push   %edi
  1003fb:	56                   	push   %esi
  1003fc:	53                   	push   %ebx
  1003fd:	bb 21 00 00 00       	mov    $0x21,%ebx
  100402:	89 da                	mov    %ebx,%edx
  100404:	ee                   	out    %al,(%dx)
  100405:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  10040a:	89 ca                	mov    %ecx,%edx
  10040c:	ee                   	out    %al,(%dx)
  10040d:	be 11 00 00 00       	mov    $0x11,%esi
  100412:	bf 20 00 00 00       	mov    $0x20,%edi
  100417:	89 f0                	mov    %esi,%eax
  100419:	89 fa                	mov    %edi,%edx
  10041b:	ee                   	out    %al,(%dx)
  10041c:	b0 20                	mov    $0x20,%al
  10041e:	89 da                	mov    %ebx,%edx
  100420:	ee                   	out    %al,(%dx)
  100421:	b0 04                	mov    $0x4,%al
  100423:	ee                   	out    %al,(%dx)
  100424:	b0 03                	mov    $0x3,%al
  100426:	ee                   	out    %al,(%dx)
  100427:	bd a0 00 00 00       	mov    $0xa0,%ebp
  10042c:	89 f0                	mov    %esi,%eax
  10042e:	89 ea                	mov    %ebp,%edx
  100430:	ee                   	out    %al,(%dx)
  100431:	b0 28                	mov    $0x28,%al
  100433:	89 ca                	mov    %ecx,%edx
  100435:	ee                   	out    %al,(%dx)
  100436:	b0 02                	mov    $0x2,%al
  100438:	ee                   	out    %al,(%dx)
  100439:	b0 01                	mov    $0x1,%al
  10043b:	ee                   	out    %al,(%dx)
  10043c:	b0 68                	mov    $0x68,%al
  10043e:	89 fa                	mov    %edi,%edx
  100440:	ee                   	out    %al,(%dx)
  100441:	be 0a 00 00 00       	mov    $0xa,%esi
  100446:	89 f0                	mov    %esi,%eax
  100448:	ee                   	out    %al,(%dx)
  100449:	b0 68                	mov    $0x68,%al
  10044b:	89 ea                	mov    %ebp,%edx
  10044d:	ee                   	out    %al,(%dx)
  10044e:	89 f0                	mov    %esi,%eax
  100450:	ee                   	out    %al,(%dx)

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	// mask all interrupts again, except possibly for clock interrupt
	outb(IO_PIC1+1, (allow_clock_interrupt ? 0xFE : 0xFF));
  100451:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
  100456:	89 da                	mov    %ebx,%edx
  100458:	19 c0                	sbb    %eax,%eax
  10045a:	f7 d0                	not    %eax
  10045c:	05 ff 00 00 00       	add    $0xff,%eax
  100461:	ee                   	out    %al,(%dx)
  100462:	b0 ff                	mov    $0xff,%al
  100464:	89 ca                	mov    %ecx,%edx
  100466:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, 0xFF);

	// if the clock interrupt is allowed, initialize the clock
	if (allow_clock_interrupt) {
  100467:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
  10046c:	74 0d                	je     10047b <interrupt_controller_init+0x84>
  10046e:	b2 43                	mov    $0x43,%dl
  100470:	b0 34                	mov    $0x34,%al
  100472:	ee                   	out    %al,(%dx)
  100473:	b0 9c                	mov    $0x9c,%al
  100475:	b2 40                	mov    $0x40,%dl
  100477:	ee                   	out    %al,(%dx)
  100478:	b0 2e                	mov    $0x2e,%al
  10047a:	ee                   	out    %al,(%dx)
		outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
		outb(IO_TIMER1, TIMER_DIV(HZ) % 256);
		outb(IO_TIMER1, TIMER_DIV(HZ) / 256);
	}
}
  10047b:	5b                   	pop    %ebx
  10047c:	5e                   	pop    %esi
  10047d:	5f                   	pop    %edi
  10047e:	5d                   	pop    %ebp
  10047f:	c3                   	ret    

00100480 <console_clear>:
 *
 *****************************************************************************/

void
console_clear(void)
{
  100480:	56                   	push   %esi
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  100481:	31 c0                	xor    %eax,%eax
 *
 *****************************************************************************/

void
console_clear(void)
{
  100483:	53                   	push   %ebx
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  100484:	c7 05 00 80 19 00 00 	movl   $0xb8000,0x198000
  10048b:	80 0b 00 

	for (i = 0; i < 80 * 25; i++)
		cursorpos[i] = ' ' | 0x0700;
  10048e:	8b 15 00 80 19 00    	mov    0x198000,%edx
  100494:	66 c7 04 02 20 07    	movw   $0x720,(%edx,%eax,1)
  10049a:	83 c0 02             	add    $0x2,%eax
console_clear(void)
{
	int i;
	cursorpos = (uint16_t *) 0xB8000;

	for (i = 0; i < 80 * 25; i++)
  10049d:	3d a0 0f 00 00       	cmp    $0xfa0,%eax
  1004a2:	75 ea                	jne    10048e <console_clear+0xe>
  1004a4:	be d4 03 00 00       	mov    $0x3d4,%esi
  1004a9:	b0 0e                	mov    $0xe,%al
  1004ab:	89 f2                	mov    %esi,%edx
  1004ad:	ee                   	out    %al,(%dx)
  1004ae:	31 c9                	xor    %ecx,%ecx
  1004b0:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  1004b5:	88 c8                	mov    %cl,%al
  1004b7:	89 da                	mov    %ebx,%edx
  1004b9:	ee                   	out    %al,(%dx)
  1004ba:	b0 0f                	mov    $0xf,%al
  1004bc:	89 f2                	mov    %esi,%edx
  1004be:	ee                   	out    %al,(%dx)
  1004bf:	88 c8                	mov    %cl,%al
  1004c1:	89 da                	mov    %ebx,%edx
  1004c3:	ee                   	out    %al,(%dx)
		cursorpos[i] = ' ' | 0x0700;
	outb(0x3D4, 14);
	outb(0x3D5, 0 / 256);
	outb(0x3D4, 15);
	outb(0x3D5, 0 % 256);
}
  1004c4:	5b                   	pop    %ebx
  1004c5:	5e                   	pop    %esi
  1004c6:	c3                   	ret    

001004c7 <console_read_digit>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  1004c7:	ba 64 00 00 00       	mov    $0x64,%edx
  1004cc:	ec                   	in     (%dx),%al
int
console_read_digit(void)
{
	uint8_t data;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  1004cd:	a8 01                	test   $0x1,%al
  1004cf:	74 45                	je     100516 <console_read_digit+0x4f>
  1004d1:	b2 60                	mov    $0x60,%dl
  1004d3:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);
	if (data >= 0x02 && data <= 0x0A)
  1004d4:	8d 50 fe             	lea    -0x2(%eax),%edx
  1004d7:	80 fa 08             	cmp    $0x8,%dl
  1004da:	77 05                	ja     1004e1 <console_read_digit+0x1a>
		return data - 0x02 + 1;
  1004dc:	0f b6 c0             	movzbl %al,%eax
  1004df:	48                   	dec    %eax
  1004e0:	c3                   	ret    
	else if (data == 0x0B)
  1004e1:	3c 0b                	cmp    $0xb,%al
  1004e3:	74 35                	je     10051a <console_read_digit+0x53>
		return 0;
	else if (data >= 0x47 && data <= 0x49)
  1004e5:	8d 50 b9             	lea    -0x47(%eax),%edx
  1004e8:	80 fa 02             	cmp    $0x2,%dl
  1004eb:	77 07                	ja     1004f4 <console_read_digit+0x2d>
		return data - 0x47 + 7;
  1004ed:	0f b6 c0             	movzbl %al,%eax
  1004f0:	83 e8 40             	sub    $0x40,%eax
  1004f3:	c3                   	ret    
	else if (data >= 0x4B && data <= 0x4D)
  1004f4:	8d 50 b5             	lea    -0x4b(%eax),%edx
  1004f7:	80 fa 02             	cmp    $0x2,%dl
  1004fa:	77 07                	ja     100503 <console_read_digit+0x3c>
		return data - 0x4B + 4;
  1004fc:	0f b6 c0             	movzbl %al,%eax
  1004ff:	83 e8 47             	sub    $0x47,%eax
  100502:	c3                   	ret    
	else if (data >= 0x4F && data <= 0x51)
  100503:	8d 50 b1             	lea    -0x4f(%eax),%edx
  100506:	80 fa 02             	cmp    $0x2,%dl
  100509:	77 07                	ja     100512 <console_read_digit+0x4b>
		return data - 0x4F + 1;
  10050b:	0f b6 c0             	movzbl %al,%eax
  10050e:	83 e8 4e             	sub    $0x4e,%eax
  100511:	c3                   	ret    
	else if (data == 0x53)
  100512:	3c 53                	cmp    $0x53,%al
  100514:	74 04                	je     10051a <console_read_digit+0x53>
  100516:	83 c8 ff             	or     $0xffffffff,%eax
  100519:	c3                   	ret    
  10051a:	31 c0                	xor    %eax,%eax
		return 0;
	else
		return -1;
}
  10051c:	c3                   	ret    

0010051d <run>:
 *
 *****************************************************************************/

void
run(process_t *proc)
{
  10051d:	8b 44 24 04          	mov    0x4(%esp),%eax
	current = proc;
  100521:	a3 58 7a 10 00       	mov    %eax,0x107a58

	asm volatile("movl %0,%%esp\n\t"
  100526:	83 c0 10             	add    $0x10,%eax
  100529:	89 c4                	mov    %eax,%esp
  10052b:	61                   	popa   
  10052c:	07                   	pop    %es
  10052d:	1f                   	pop    %ds
  10052e:	83 c4 08             	add    $0x8,%esp
  100531:	cf                   	iret   
  100532:	eb fe                	jmp    100532 <run+0x15>

00100534 <special_registers_init>:
 *
 *****************************************************************************/

void
special_registers_init(process_t *proc)
{
  100534:	53                   	push   %ebx
  100535:	83 ec 0c             	sub    $0xc,%esp
  100538:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	memset(&proc->p_registers, 0, sizeof(registers_t));
  10053c:	6a 44                	push   $0x44
  10053e:	6a 00                	push   $0x0
  100540:	8d 43 10             	lea    0x10(%ebx),%eax
  100543:	50                   	push   %eax
  100544:	e8 17 01 00 00       	call   100660 <memset>
	proc->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
  100549:	66 c7 43 44 1b 00    	movw   $0x1b,0x44(%ebx)
	proc->p_registers.reg_ds = SEGSEL_APP_DATA | 3;
  10054f:	66 c7 43 34 23 00    	movw   $0x23,0x34(%ebx)
	proc->p_registers.reg_es = SEGSEL_APP_DATA | 3;
  100555:	66 c7 43 30 23 00    	movw   $0x23,0x30(%ebx)
	proc->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
  10055b:	66 c7 43 50 23 00    	movw   $0x23,0x50(%ebx)
	// Enable interrupts
	proc->p_registers.reg_eflags = EFLAGS_IF;
  100561:	c7 43 48 00 02 00 00 	movl   $0x200,0x48(%ebx)
}
  100568:	83 c4 18             	add    $0x18,%esp
  10056b:	5b                   	pop    %ebx
  10056c:	c3                   	ret    
  10056d:	90                   	nop
  10056e:	90                   	nop
  10056f:	90                   	nop

00100570 <program_loader>:
		    uint32_t filesz, uint32_t memsz);
static void loader_panic(void);

void
program_loader(int program_id, uint32_t *entry_point)
{
  100570:	55                   	push   %ebp
  100571:	57                   	push   %edi
  100572:	56                   	push   %esi
  100573:	53                   	push   %ebx
  100574:	83 ec 1c             	sub    $0x1c,%esp
  100577:	8b 44 24 30          	mov    0x30(%esp),%eax
	struct Proghdr *ph, *eph;
	struct Elf *elf_header;
	int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);

	if (program_id < 0 || program_id >= nprograms)
  10057b:	83 f8 03             	cmp    $0x3,%eax
  10057e:	7f 04                	jg     100584 <program_loader+0x14>
  100580:	85 c0                	test   %eax,%eax
  100582:	79 02                	jns    100586 <program_loader+0x16>
  100584:	eb fe                	jmp    100584 <program_loader+0x14>
		loader_panic();

	// is this a valid ELF?
	elf_header = (struct Elf *) ramimages[program_id].begin;
  100586:	8b 34 c5 40 10 10 00 	mov    0x101040(,%eax,8),%esi
	if (elf_header->e_magic != ELF_MAGIC)
  10058d:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  100593:	74 02                	je     100597 <program_loader+0x27>
  100595:	eb fe                	jmp    100595 <program_loader+0x25>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  100597:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	eph = ph + elf_header->e_phnum;
  10059a:	0f b7 6e 2c          	movzwl 0x2c(%esi),%ebp
	elf_header = (struct Elf *) ramimages[program_id].begin;
	if (elf_header->e_magic != ELF_MAGIC)
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  10059e:	01 f3                	add    %esi,%ebx
	eph = ph + elf_header->e_phnum;
  1005a0:	c1 e5 05             	shl    $0x5,%ebp
  1005a3:	8d 2c 2b             	lea    (%ebx,%ebp,1),%ebp
	for (; ph < eph; ph++)
  1005a6:	eb 3f                	jmp    1005e7 <program_loader+0x77>
		if (ph->p_type == ELF_PROG_LOAD)
  1005a8:	83 3b 01             	cmpl   $0x1,(%ebx)
  1005ab:	75 37                	jne    1005e4 <program_loader+0x74>
			copyseg((void *) ph->p_va,
  1005ad:	8b 43 08             	mov    0x8(%ebx),%eax
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  1005b0:	8b 7b 10             	mov    0x10(%ebx),%edi
	memsz += va;
  1005b3:	8b 53 14             	mov    0x14(%ebx),%edx
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  1005b6:	01 c7                	add    %eax,%edi
	memsz += va;
  1005b8:	01 c2                	add    %eax,%edx
	va &= ~(PAGESIZE - 1);		// round to page boundary
  1005ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
	memsz += va;
  1005bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  1005c3:	52                   	push   %edx
  1005c4:	89 fa                	mov    %edi,%edx
  1005c6:	29 c2                	sub    %eax,%edx
  1005c8:	52                   	push   %edx
  1005c9:	8b 53 04             	mov    0x4(%ebx),%edx
  1005cc:	01 f2                	add    %esi,%edx
  1005ce:	52                   	push   %edx
  1005cf:	50                   	push   %eax
  1005d0:	e8 27 00 00 00       	call   1005fc <memcpy>
  1005d5:	83 c4 10             	add    $0x10,%esp
  1005d8:	eb 04                	jmp    1005de <program_loader+0x6e>

	// clear bss segment
	while (end_va < memsz)
		*((uint8_t *) end_va++) = 0;
  1005da:	c6 07 00             	movb   $0x0,(%edi)
  1005dd:	47                   	inc    %edi

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);

	// clear bss segment
	while (end_va < memsz)
  1005de:	3b 7c 24 0c          	cmp    0xc(%esp),%edi
  1005e2:	72 f6                	jb     1005da <program_loader+0x6a>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
  1005e4:	83 c3 20             	add    $0x20,%ebx
  1005e7:	39 eb                	cmp    %ebp,%ebx
  1005e9:	72 bd                	jb     1005a8 <program_loader+0x38>
			copyseg((void *) ph->p_va,
				(const uint8_t *) elf_header + ph->p_offset,
				ph->p_filesz, ph->p_memsz);

	// store the entry point from the ELF header
	*entry_point = elf_header->e_entry;
  1005eb:	8b 56 18             	mov    0x18(%esi),%edx
  1005ee:	8b 44 24 34          	mov    0x34(%esp),%eax
  1005f2:	89 10                	mov    %edx,(%eax)
}
  1005f4:	83 c4 1c             	add    $0x1c,%esp
  1005f7:	5b                   	pop    %ebx
  1005f8:	5e                   	pop    %esi
  1005f9:	5f                   	pop    %edi
  1005fa:	5d                   	pop    %ebp
  1005fb:	c3                   	ret    

001005fc <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  1005fc:	56                   	push   %esi
  1005fd:	31 d2                	xor    %edx,%edx
  1005ff:	53                   	push   %ebx
  100600:	8b 44 24 0c          	mov    0xc(%esp),%eax
  100604:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  100608:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  10060c:	eb 08                	jmp    100616 <memcpy+0x1a>
		*d++ = *s++;
  10060e:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  100611:	4e                   	dec    %esi
  100612:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  100615:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  100616:	85 f6                	test   %esi,%esi
  100618:	75 f4                	jne    10060e <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  10061a:	5b                   	pop    %ebx
  10061b:	5e                   	pop    %esi
  10061c:	c3                   	ret    

0010061d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  10061d:	57                   	push   %edi
  10061e:	56                   	push   %esi
  10061f:	53                   	push   %ebx
  100620:	8b 44 24 10          	mov    0x10(%esp),%eax
  100624:	8b 7c 24 14          	mov    0x14(%esp),%edi
  100628:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  10062c:	39 c7                	cmp    %eax,%edi
  10062e:	73 26                	jae    100656 <memmove+0x39>
  100630:	8d 34 17             	lea    (%edi,%edx,1),%esi
  100633:	39 c6                	cmp    %eax,%esi
  100635:	76 1f                	jbe    100656 <memmove+0x39>
		s += n, d += n;
  100637:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  10063a:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  10063c:	eb 07                	jmp    100645 <memmove+0x28>
			*--d = *--s;
  10063e:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  100641:	4a                   	dec    %edx
  100642:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  100645:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  100646:	85 d2                	test   %edx,%edx
  100648:	75 f4                	jne    10063e <memmove+0x21>
  10064a:	eb 10                	jmp    10065c <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  10064c:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  10064f:	4a                   	dec    %edx
  100650:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  100653:	41                   	inc    %ecx
  100654:	eb 02                	jmp    100658 <memmove+0x3b>
  100656:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  100658:	85 d2                	test   %edx,%edx
  10065a:	75 f0                	jne    10064c <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  10065c:	5b                   	pop    %ebx
  10065d:	5e                   	pop    %esi
  10065e:	5f                   	pop    %edi
  10065f:	c3                   	ret    

00100660 <memset>:

void *
memset(void *v, int c, size_t n)
{
  100660:	53                   	push   %ebx
  100661:	8b 44 24 08          	mov    0x8(%esp),%eax
  100665:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  100669:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  10066d:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  10066f:	eb 04                	jmp    100675 <memset+0x15>
		*p++ = c;
  100671:	88 1a                	mov    %bl,(%edx)
  100673:	49                   	dec    %ecx
  100674:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  100675:	85 c9                	test   %ecx,%ecx
  100677:	75 f8                	jne    100671 <memset+0x11>
		*p++ = c;
	return v;
}
  100679:	5b                   	pop    %ebx
  10067a:	c3                   	ret    

0010067b <strlen>:

size_t
strlen(const char *s)
{
  10067b:	8b 54 24 04          	mov    0x4(%esp),%edx
  10067f:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  100681:	eb 01                	jmp    100684 <strlen+0x9>
		++n;
  100683:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  100684:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100688:	75 f9                	jne    100683 <strlen+0x8>
		++n;
	return n;
}
  10068a:	c3                   	ret    

0010068b <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  10068b:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10068f:	31 c0                	xor    %eax,%eax
  100691:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  100695:	eb 01                	jmp    100698 <strnlen+0xd>
		++n;
  100697:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  100698:	39 d0                	cmp    %edx,%eax
  10069a:	74 06                	je     1006a2 <strnlen+0x17>
  10069c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  1006a0:	75 f5                	jne    100697 <strnlen+0xc>
		++n;
	return n;
}
  1006a2:	c3                   	ret    

001006a3 <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  1006a3:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  1006a4:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  1006a9:	53                   	push   %ebx
  1006aa:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  1006ac:	76 05                	jbe    1006b3 <console_putc+0x10>
  1006ae:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  1006b3:	80 fa 0a             	cmp    $0xa,%dl
  1006b6:	75 2c                	jne    1006e4 <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  1006b8:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  1006be:	be 50 00 00 00       	mov    $0x50,%esi
  1006c3:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  1006c5:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  1006c8:	99                   	cltd   
  1006c9:	f7 fe                	idiv   %esi
  1006cb:	89 de                	mov    %ebx,%esi
  1006cd:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  1006cf:	eb 07                	jmp    1006d8 <console_putc+0x35>
			*cursor++ = ' ' | color;
  1006d1:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  1006d4:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  1006d5:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  1006d8:	83 f8 50             	cmp    $0x50,%eax
  1006db:	75 f4                	jne    1006d1 <console_putc+0x2e>
  1006dd:	29 d0                	sub    %edx,%eax
  1006df:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  1006e2:	eb 0b                	jmp    1006ef <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1006e4:	0f b6 d2             	movzbl %dl,%edx
  1006e7:	09 ca                	or     %ecx,%edx
  1006e9:	66 89 13             	mov    %dx,(%ebx)
  1006ec:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  1006ef:	5b                   	pop    %ebx
  1006f0:	5e                   	pop    %esi
  1006f1:	c3                   	ret    

001006f2 <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  1006f2:	56                   	push   %esi
  1006f3:	53                   	push   %ebx
  1006f4:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  1006f8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1006fb:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  1006ff:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  100704:	75 04                	jne    10070a <fill_numbuf+0x18>
  100706:	85 d2                	test   %edx,%edx
  100708:	74 10                	je     10071a <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  10070a:	89 d0                	mov    %edx,%eax
  10070c:	31 d2                	xor    %edx,%edx
  10070e:	f7 f1                	div    %ecx
  100710:	4b                   	dec    %ebx
  100711:	8a 14 16             	mov    (%esi,%edx,1),%dl
  100714:	88 13                	mov    %dl,(%ebx)
			val /= base;
  100716:	89 c2                	mov    %eax,%edx
  100718:	eb ec                	jmp    100706 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  10071a:	89 d8                	mov    %ebx,%eax
  10071c:	5b                   	pop    %ebx
  10071d:	5e                   	pop    %esi
  10071e:	c3                   	ret    

0010071f <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  10071f:	55                   	push   %ebp
  100720:	57                   	push   %edi
  100721:	56                   	push   %esi
  100722:	53                   	push   %ebx
  100723:	83 ec 38             	sub    $0x38,%esp
  100726:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  10072a:	8b 7c 24 54          	mov    0x54(%esp),%edi
  10072e:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  100732:	e9 60 03 00 00       	jmp    100a97 <console_vprintf+0x378>
		if (*format != '%') {
  100737:	80 fa 25             	cmp    $0x25,%dl
  10073a:	74 13                	je     10074f <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  10073c:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100740:	0f b6 d2             	movzbl %dl,%edx
  100743:	89 f0                	mov    %esi,%eax
  100745:	e8 59 ff ff ff       	call   1006a3 <console_putc>
  10074a:	e9 45 03 00 00       	jmp    100a94 <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  10074f:	47                   	inc    %edi
  100750:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  100757:	00 
  100758:	eb 12                	jmp    10076c <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  10075a:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  10075b:	8a 11                	mov    (%ecx),%dl
  10075d:	84 d2                	test   %dl,%dl
  10075f:	74 1a                	je     10077b <console_vprintf+0x5c>
  100761:	89 e8                	mov    %ebp,%eax
  100763:	38 c2                	cmp    %al,%dl
  100765:	75 f3                	jne    10075a <console_vprintf+0x3b>
  100767:	e9 3f 03 00 00       	jmp    100aab <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  10076c:	8a 17                	mov    (%edi),%dl
  10076e:	84 d2                	test   %dl,%dl
  100770:	74 0b                	je     10077d <console_vprintf+0x5e>
  100772:	b9 00 0b 10 00       	mov    $0x100b00,%ecx
  100777:	89 d5                	mov    %edx,%ebp
  100779:	eb e0                	jmp    10075b <console_vprintf+0x3c>
  10077b:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  10077d:	8d 42 cf             	lea    -0x31(%edx),%eax
  100780:	3c 08                	cmp    $0x8,%al
  100782:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100789:	00 
  10078a:	76 13                	jbe    10079f <console_vprintf+0x80>
  10078c:	eb 1d                	jmp    1007ab <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  10078e:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  100793:	0f be c0             	movsbl %al,%eax
  100796:	47                   	inc    %edi
  100797:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  10079b:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  10079f:	8a 07                	mov    (%edi),%al
  1007a1:	8d 50 d0             	lea    -0x30(%eax),%edx
  1007a4:	80 fa 09             	cmp    $0x9,%dl
  1007a7:	76 e5                	jbe    10078e <console_vprintf+0x6f>
  1007a9:	eb 18                	jmp    1007c3 <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  1007ab:	80 fa 2a             	cmp    $0x2a,%dl
  1007ae:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  1007b5:	ff 
  1007b6:	75 0b                	jne    1007c3 <console_vprintf+0xa4>
			width = va_arg(val, int);
  1007b8:	83 c3 04             	add    $0x4,%ebx
			++format;
  1007bb:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  1007bc:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  1007c3:	83 cd ff             	or     $0xffffffff,%ebp
  1007c6:	80 3f 2e             	cmpb   $0x2e,(%edi)
  1007c9:	75 37                	jne    100802 <console_vprintf+0xe3>
			++format;
  1007cb:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  1007cc:	31 ed                	xor    %ebp,%ebp
  1007ce:	8a 07                	mov    (%edi),%al
  1007d0:	8d 50 d0             	lea    -0x30(%eax),%edx
  1007d3:	80 fa 09             	cmp    $0x9,%dl
  1007d6:	76 0d                	jbe    1007e5 <console_vprintf+0xc6>
  1007d8:	eb 17                	jmp    1007f1 <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  1007da:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  1007dd:	0f be c0             	movsbl %al,%eax
  1007e0:	47                   	inc    %edi
  1007e1:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  1007e5:	8a 07                	mov    (%edi),%al
  1007e7:	8d 50 d0             	lea    -0x30(%eax),%edx
  1007ea:	80 fa 09             	cmp    $0x9,%dl
  1007ed:	76 eb                	jbe    1007da <console_vprintf+0xbb>
  1007ef:	eb 11                	jmp    100802 <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  1007f1:	3c 2a                	cmp    $0x2a,%al
  1007f3:	75 0b                	jne    100800 <console_vprintf+0xe1>
				precision = va_arg(val, int);
  1007f5:	83 c3 04             	add    $0x4,%ebx
				++format;
  1007f8:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  1007f9:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  1007fc:	85 ed                	test   %ebp,%ebp
  1007fe:	79 02                	jns    100802 <console_vprintf+0xe3>
  100800:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  100802:	8a 07                	mov    (%edi),%al
  100804:	3c 64                	cmp    $0x64,%al
  100806:	74 34                	je     10083c <console_vprintf+0x11d>
  100808:	7f 1d                	jg     100827 <console_vprintf+0x108>
  10080a:	3c 58                	cmp    $0x58,%al
  10080c:	0f 84 a2 00 00 00    	je     1008b4 <console_vprintf+0x195>
  100812:	3c 63                	cmp    $0x63,%al
  100814:	0f 84 bf 00 00 00    	je     1008d9 <console_vprintf+0x1ba>
  10081a:	3c 43                	cmp    $0x43,%al
  10081c:	0f 85 d0 00 00 00    	jne    1008f2 <console_vprintf+0x1d3>
  100822:	e9 a3 00 00 00       	jmp    1008ca <console_vprintf+0x1ab>
  100827:	3c 75                	cmp    $0x75,%al
  100829:	74 4d                	je     100878 <console_vprintf+0x159>
  10082b:	3c 78                	cmp    $0x78,%al
  10082d:	74 5c                	je     10088b <console_vprintf+0x16c>
  10082f:	3c 73                	cmp    $0x73,%al
  100831:	0f 85 bb 00 00 00    	jne    1008f2 <console_vprintf+0x1d3>
  100837:	e9 86 00 00 00       	jmp    1008c2 <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  10083c:	83 c3 04             	add    $0x4,%ebx
  10083f:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  100842:	89 d1                	mov    %edx,%ecx
  100844:	c1 f9 1f             	sar    $0x1f,%ecx
  100847:	89 0c 24             	mov    %ecx,(%esp)
  10084a:	31 ca                	xor    %ecx,%edx
  10084c:	55                   	push   %ebp
  10084d:	29 ca                	sub    %ecx,%edx
  10084f:	68 08 0b 10 00       	push   $0x100b08
  100854:	b9 0a 00 00 00       	mov    $0xa,%ecx
  100859:	8d 44 24 40          	lea    0x40(%esp),%eax
  10085d:	e8 90 fe ff ff       	call   1006f2 <fill_numbuf>
  100862:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  100866:	58                   	pop    %eax
  100867:	5a                   	pop    %edx
  100868:	ba 01 00 00 00       	mov    $0x1,%edx
  10086d:	8b 04 24             	mov    (%esp),%eax
  100870:	83 e0 01             	and    $0x1,%eax
  100873:	e9 a5 00 00 00       	jmp    10091d <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  100878:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  10087b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  100880:	8b 53 fc             	mov    -0x4(%ebx),%edx
  100883:	55                   	push   %ebp
  100884:	68 08 0b 10 00       	push   $0x100b08
  100889:	eb 11                	jmp    10089c <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  10088b:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  10088e:	8b 53 fc             	mov    -0x4(%ebx),%edx
  100891:	55                   	push   %ebp
  100892:	68 1c 0b 10 00       	push   $0x100b1c
  100897:	b9 10 00 00 00       	mov    $0x10,%ecx
  10089c:	8d 44 24 40          	lea    0x40(%esp),%eax
  1008a0:	e8 4d fe ff ff       	call   1006f2 <fill_numbuf>
  1008a5:	ba 01 00 00 00       	mov    $0x1,%edx
  1008aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1008ae:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  1008b0:	59                   	pop    %ecx
  1008b1:	59                   	pop    %ecx
  1008b2:	eb 69                	jmp    10091d <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  1008b4:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  1008b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1008ba:	55                   	push   %ebp
  1008bb:	68 08 0b 10 00       	push   $0x100b08
  1008c0:	eb d5                	jmp    100897 <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  1008c2:	83 c3 04             	add    $0x4,%ebx
  1008c5:	8b 43 fc             	mov    -0x4(%ebx),%eax
  1008c8:	eb 40                	jmp    10090a <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  1008ca:	83 c3 04             	add    $0x4,%ebx
  1008cd:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1008d0:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  1008d4:	e9 bd 01 00 00       	jmp    100a96 <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  1008d9:	83 c3 04             	add    $0x4,%ebx
  1008dc:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  1008df:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  1008e3:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  1008e8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  1008ec:	88 44 24 24          	mov    %al,0x24(%esp)
  1008f0:	eb 27                	jmp    100919 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  1008f2:	84 c0                	test   %al,%al
  1008f4:	75 02                	jne    1008f8 <console_vprintf+0x1d9>
  1008f6:	b0 25                	mov    $0x25,%al
  1008f8:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  1008fc:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  100901:	80 3f 00             	cmpb   $0x0,(%edi)
  100904:	74 0a                	je     100910 <console_vprintf+0x1f1>
  100906:	8d 44 24 24          	lea    0x24(%esp),%eax
  10090a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090e:	eb 09                	jmp    100919 <console_vprintf+0x1fa>
				format--;
  100910:	8d 54 24 24          	lea    0x24(%esp),%edx
  100914:	4f                   	dec    %edi
  100915:	89 54 24 04          	mov    %edx,0x4(%esp)
  100919:	31 d2                	xor    %edx,%edx
  10091b:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  10091d:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  10091f:	83 fd ff             	cmp    $0xffffffff,%ebp
  100922:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100929:	74 1f                	je     10094a <console_vprintf+0x22b>
  10092b:	89 04 24             	mov    %eax,(%esp)
  10092e:	eb 01                	jmp    100931 <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  100930:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  100931:	39 e9                	cmp    %ebp,%ecx
  100933:	74 0a                	je     10093f <console_vprintf+0x220>
  100935:	8b 44 24 04          	mov    0x4(%esp),%eax
  100939:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  10093d:	75 f1                	jne    100930 <console_vprintf+0x211>
  10093f:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  100942:	89 0c 24             	mov    %ecx,(%esp)
  100945:	eb 1f                	jmp    100966 <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  100947:	42                   	inc    %edx
  100948:	eb 09                	jmp    100953 <console_vprintf+0x234>
  10094a:	89 d1                	mov    %edx,%ecx
  10094c:	8b 14 24             	mov    (%esp),%edx
  10094f:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  100953:	8b 44 24 04          	mov    0x4(%esp),%eax
  100957:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  10095b:	75 ea                	jne    100947 <console_vprintf+0x228>
  10095d:	8b 44 24 08          	mov    0x8(%esp),%eax
  100961:	89 14 24             	mov    %edx,(%esp)
  100964:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  100966:	85 c0                	test   %eax,%eax
  100968:	74 0c                	je     100976 <console_vprintf+0x257>
  10096a:	84 d2                	test   %dl,%dl
  10096c:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  100973:	00 
  100974:	75 24                	jne    10099a <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  100976:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  10097b:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  100982:	00 
  100983:	75 15                	jne    10099a <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  100985:	8b 44 24 14          	mov    0x14(%esp),%eax
  100989:	83 e0 08             	and    $0x8,%eax
  10098c:	83 f8 01             	cmp    $0x1,%eax
  10098f:	19 c9                	sbb    %ecx,%ecx
  100991:	f7 d1                	not    %ecx
  100993:	83 e1 20             	and    $0x20,%ecx
  100996:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  10099a:	3b 2c 24             	cmp    (%esp),%ebp
  10099d:	7e 0d                	jle    1009ac <console_vprintf+0x28d>
  10099f:	84 d2                	test   %dl,%dl
  1009a1:	74 40                	je     1009e3 <console_vprintf+0x2c4>
			zeros = precision - len;
  1009a3:	2b 2c 24             	sub    (%esp),%ebp
  1009a6:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  1009aa:	eb 3f                	jmp    1009eb <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1009ac:	84 d2                	test   %dl,%dl
  1009ae:	74 33                	je     1009e3 <console_vprintf+0x2c4>
  1009b0:	8b 44 24 14          	mov    0x14(%esp),%eax
  1009b4:	83 e0 06             	and    $0x6,%eax
  1009b7:	83 f8 02             	cmp    $0x2,%eax
  1009ba:	75 27                	jne    1009e3 <console_vprintf+0x2c4>
  1009bc:	45                   	inc    %ebp
  1009bd:	75 24                	jne    1009e3 <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  1009bf:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1009c1:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  1009c4:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  1009c9:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1009cc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  1009cf:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  1009d3:	7d 0e                	jge    1009e3 <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  1009d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1009d9:	29 ca                	sub    %ecx,%edx
  1009db:	29 c2                	sub    %eax,%edx
  1009dd:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1009e1:	eb 08                	jmp    1009eb <console_vprintf+0x2cc>
  1009e3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  1009ea:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  1009eb:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  1009ef:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  1009f1:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  1009f5:	2b 2c 24             	sub    (%esp),%ebp
  1009f8:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  1009fd:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100a00:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  100a03:	29 c5                	sub    %eax,%ebp
  100a05:	89 f0                	mov    %esi,%eax
  100a07:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100a0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a0f:	eb 0f                	jmp    100a20 <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  100a11:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a15:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100a1a:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  100a1b:	e8 83 fc ff ff       	call   1006a3 <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100a20:	85 ed                	test   %ebp,%ebp
  100a22:	7e 07                	jle    100a2b <console_vprintf+0x30c>
  100a24:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  100a29:	74 e6                	je     100a11 <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  100a2b:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100a30:	89 c6                	mov    %eax,%esi
  100a32:	74 23                	je     100a57 <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  100a34:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  100a39:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a3d:	e8 61 fc ff ff       	call   1006a3 <console_putc>
  100a42:	89 c6                	mov    %eax,%esi
  100a44:	eb 11                	jmp    100a57 <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  100a46:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a4a:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  100a4f:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  100a50:	e8 4e fc ff ff       	call   1006a3 <console_putc>
  100a55:	eb 06                	jmp    100a5d <console_vprintf+0x33e>
  100a57:	89 f0                	mov    %esi,%eax
  100a59:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  100a5d:	85 f6                	test   %esi,%esi
  100a5f:	7f e5                	jg     100a46 <console_vprintf+0x327>
  100a61:	8b 34 24             	mov    (%esp),%esi
  100a64:	eb 15                	jmp    100a7b <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  100a66:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  100a6a:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  100a6b:	0f b6 11             	movzbl (%ecx),%edx
  100a6e:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a72:	e8 2c fc ff ff       	call   1006a3 <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  100a77:	ff 44 24 04          	incl   0x4(%esp)
  100a7b:	85 f6                	test   %esi,%esi
  100a7d:	7f e7                	jg     100a66 <console_vprintf+0x347>
  100a7f:	eb 0f                	jmp    100a90 <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  100a81:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a85:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  100a8a:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  100a8b:	e8 13 fc ff ff       	call   1006a3 <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  100a90:	85 ed                	test   %ebp,%ebp
  100a92:	7f ed                	jg     100a81 <console_vprintf+0x362>
  100a94:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  100a96:	47                   	inc    %edi
  100a97:	8a 17                	mov    (%edi),%dl
  100a99:	84 d2                	test   %dl,%dl
  100a9b:	0f 85 96 fc ff ff    	jne    100737 <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  100aa1:	83 c4 38             	add    $0x38,%esp
  100aa4:	89 f0                	mov    %esi,%eax
  100aa6:	5b                   	pop    %ebx
  100aa7:	5e                   	pop    %esi
  100aa8:	5f                   	pop    %edi
  100aa9:	5d                   	pop    %ebp
  100aaa:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100aab:	81 e9 00 0b 10 00    	sub    $0x100b00,%ecx
  100ab1:	b8 01 00 00 00       	mov    $0x1,%eax
  100ab6:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  100ab8:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100ab9:	09 44 24 14          	or     %eax,0x14(%esp)
  100abd:	e9 aa fc ff ff       	jmp    10076c <console_vprintf+0x4d>

00100ac2 <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  100ac2:	8d 44 24 10          	lea    0x10(%esp),%eax
  100ac6:	50                   	push   %eax
  100ac7:	ff 74 24 10          	pushl  0x10(%esp)
  100acb:	ff 74 24 10          	pushl  0x10(%esp)
  100acf:	ff 74 24 10          	pushl  0x10(%esp)
  100ad3:	e8 47 fc ff ff       	call   10071f <console_vprintf>
  100ad8:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  100adb:	c3                   	ret    
