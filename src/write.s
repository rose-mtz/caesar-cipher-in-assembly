.section .text

# PURPOSE: function to write in block of memory from file
#
# INPUT:
#	fd     - file descriptor
#	buffer - buffer to store read in bytes in
#	size   - size of buffer
#
# OUTPUT:
#	buffer - buffer will contain bytes to write
#	$eax   - will contain number of bytes written

# Constants
.equ ST_FD, 8			# stack position offset of fd
.equ ST_BUFFER, 12		# stack position offset of buffer addr
.equ ST_BUFFER_SIZE, 16		# stack position offset of buffer size

.equ SYS_WRITE, 4		# system call number for write
.equ LINUX_SYSCALL, 0x80

.globl write
.type write, @function
write:

pushl %ebp			# save old base ptr
movl  %esp, %ebp		# new base ptr

movl $SYS_WRITE, %eax
movl ST_FD(%ebp), %ebx
movl ST_BUFFER(%ebp), %ecx
movl ST_BUFFER_SIZE(%ebp), %edx
int  $LINUX_SYSCALL

popl %ebp			# restore old base ptr
ret


