.section .text

# PURPOSE: function to read in block of memory from file
#
# INPUT:
#	fd     - file descriptor
#	buffer - buffer to store read in bytes in
#	size   - size of buffer
#
# OUTPUT:
#	buffer - buffer will contain read in bytes
#	$eax   - will contain number of bytes read in

# Constants
.equ ST_FD, 8			# stack position offset of fd
.equ ST_BUFFER, 12		# stack position offset of buffer addr
.equ ST_BUFFER_SIZE, 16		# stack position offset of buffer size

.equ SYS_READ, 3		# system call number for read
.equ LINUX_SYSCALL, 0x80

.globl read
.type read, @function
read:

pushl %ebp			# save old base ptr
movl  %esp, %ebp		# new base ptr

movl $SYS_READ, %eax
movl ST_FD(%ebp), %ebx
movl ST_BUFFER(%ebp), %ecx
movl ST_BUFFER_SIZE(%ebp), %edx
int  $LINUX_SYSCALL

popl %ebp			# restore old base ptr
ret


