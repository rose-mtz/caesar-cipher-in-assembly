.section .text

# PURPOSE: function to encrypt/decrypt a buffer of bytes using CAESAR CIPHER
#
# INPUT:
#	offset - encryption offset (signed long int)
#	buffer - buffer that contains bytes to encrypt/decrypt
#	size   - size of buffer
#
# OUTPUT:
#	buffer - buffer will be overwritten

# Constants
.equ ST_KEY, 4			# stack position offset of key to encrypt/decrypt buffer
.equ ST_BUFFER, 8		# stack position offset of buffer
.equ ST_BUFFER_SIZE, 12		# stack position offset of buffer size

.globl caesar_cipher
.type caesar_cipher, @function
caesar_cipher:

movl ST_KEY(%esp), %ebx			# edx holds encryption key
movl ST_BUFFER(%esp), %ecx		# ecx holds buffer ptr
movl ST_BUFFER_SIZE(%esp), %edx		# edx holds buffer size
movl $0, %edi				# edi holds index for current byte

cmpl $0, %edx				# zero length buffer
je end_loop

start_loop:

movl $0, %eax			# zero out register
movb (%ecx,%edi,1), %al		# current char

addl %ebx, %eax			# add key to byte
movb %al, (%ecx,%edi,1)		# store encrypted byte

inc %edi			# next index
cmpl %edx, %edi
jl start_loop

end_loop:

ret


