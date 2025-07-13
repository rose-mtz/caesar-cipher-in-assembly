# PURPOSE:
#	This program encrypts files using the simple caesar cipher encryption.
# INPUT:
#	key      - encryption key, should be a signed integer
#	filename - name of file to encrypt
# OUTPUT:
#	the given file will be overwritten and encrypted
# EXAMPLE:
#	To encrypt
#		./main  12 my_file.txt
#	To decrypt
#		./main -12 my_file.txt
#	Or you could do it in reverse to, negative number first then the positive one.
# NOTE:
#	Very little error checking, so make sure to follow examples and instructions, else
#	it may not work as expected.

.section .bss

.equ BUFFER_SIZE, 500
.lcomm BUFFER, BUFFER_SIZE

.section .text

# Local variable constantans
.equ ST_SIZE_RESERVE, 12	# 3 local variables
.equ ST_FD, -4
.equ ST_KEY, -8
.equ ST_DATA_SIZE, -12		# amount of data in buffer

# Parameters
.equ ST_KEY_STR, 8		# string input number ptr
.equ ST_FILENAME, 12		# input filename ptr

.equ O_RDWR, 0x2
.equ SYS_OPEN, 5
.equ SYS_LSEEK, 19		# for resetting offset pointer of fd
.equ SEEK_CUR, 1
.equ LINUX_SYSCALL, 0x80
.equ SYS_CLOSE, 6

.globl _start
_start:

movl %esp, %ebp				# set up base ptr
subl $ST_SIZE_RESERVE, %esp		# make space for local variables

# Open file to encrypt/decrypt
movl $SYS_OPEN, %eax
movl ST_FILENAME(%ebp), %ebx
movl $O_RDWR, %ecx
movl $0666, %edx
int  $LINUX_SYSCALL

# Error check for open call
cmpl $0, %eax
jl   exit_program

# Store file descriptor in local variable
movl %eax, ST_FD(%ebp)

# Parse user input encryption key
pushl ST_KEY_STR(%ebp)
call  string_to_signed_long_int
movl  %eax, ST_KEY(%ebp)
addl  $4, %esp				# store parsed key in %esp

read_loop:

# Read in block
pushl $BUFFER_SIZE
pushl $BUFFER
pushl ST_FD(%ebp)
call  read
addl  $12, %esp
movl  %eax, ST_DATA_SIZE(%ebp)		# size of data read in

# End of file or error check
cmpl  $0, %eax
je    done_loop

# Encrypt block
pushl ST_DATA_SIZE(%ebp)
pushl $BUFFER
pushl ST_KEY(%ebp)
call  caesar_cipher
addl  $12, %esp

# Restore offset file pointer
movl $SYS_LSEEK, %eax
movl ST_FD(%ebp), %ebx
movl ST_DATA_SIZE(%ebp), %ecx
negl %ecx
movl $SEEK_CUR, %edx
int  $LINUX_SYSCALL

# Write in block
pushl ST_DATA_SIZE(%ebp)
pushl $BUFFER
pushl ST_FD(%ebp)
call  write
addl  $12, %esp

jmp read_loop

done_loop:

# Close file
movl $SYS_CLOSE, %eax
movl ST_FD(%ebp), %ebx
int  $LINUX_SYSCALL

exit_program:

movl $1, %eax
movl $0, %ebx
int  $LINUX_SYSCALL


