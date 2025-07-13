.section .text

# PURPOSE:
#	Converts a signed integer from a string representation into a
#	signed long binary representation.
# INPUT:
#	string - a null-terminated string that represents the signed integer
# OUTPUT:
#	%eax - the signed long binary integer
# NOTE:
#	No error checking, so make sure input is valid.
#	Valid str should be made up of digits only, with optional prefix of
#	-, and a required endfix of null-terminator charcter (\0).
#	No empty strings.
#	No overflow checking.
# VARIABLES:
#	%eax - the current result
#	%ebx - current char from string
#	%ecx - pointer to string
#	%edi - index for current char
# PROCESS:
#	result = 0
#	for each digit in string
#		binary_digit = ascii_digit - '0'
#		result = (result * 10) + binary_digit
#	negate result if first char in string is '-'
#	return result

# Constants
.equ ST_STR, 4			# stack position of str ptr
.equ NULL, 0			# ascii null character

.globl string_to_signed_long_int
.type string_to_signed_long_int, @function
string_to_signed_long_int:

movl $0, %eax			# set current result to 0
movl ST_STR(%esp), %ecx		# set str ptr in ecx
movl $0, %edi			# set index to 0
movl $0, %ebx			# zero out ebx (for doing conversion of ascii digit to binary digit)

movb (%ecx), %bl		# get first char in string
cmpb $'-', %bl
jne  start_loop
movl $1, %edi			# first char was '-', so set index to 1 instead

start_loop:

movb (%ecx,%edi,1), %bl		# load current char to %bl
cmpb $NULL, %bl
je end_loop			# found end of string, end loop

imul $10, %eax			# multiply current result by 10
addl $-'0', %ebx		# convert ascii digit to binary digit
addl %ebx, %eax			# add binary digit to current result

inc %edi			# increment index to next char
jmp start_loop

end_loop:

movb (%ecx), %bl		# first character of string
cmpb $'-', %bl			# check if number is negative
jne return
negl %eax			# negate result

return:
ret


