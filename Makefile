./bin/main.o : ./src/main.s
	as ./src/main.s -32 -o ./bin/main.o

./bin/read.o : ./src/read.s
	as ./src/read.s -32 -o ./bin/read.o

./bin/write.o : ./src/write.s
	as ./src/write.s -32 -o ./bin/write.o

./bin/string_to_signed_long_int.o : ./src/string_to_signed_long_int.s
	as ./src/string_to_signed_long_int.s -32 -o ./bin/string_to_signed_long_int.o

./bin/caesar_cipher.o : ./src/caesar_cipher.s
	as ./src/caesar_cipher.s -32 -o ./bin/caesar_cipher.o

main : ./bin/main.o ./bin/read.o ./bin/write.o ./bin/string_to_signed_long_int.o ./bin/caesar_cipher.o
	ld -m elf_i386 -o main ./bin/main.o ./bin/read.o ./bin/write.o ./bin/string_to_signed_long_int.o ./bin/caesar_cipher.o

all : main

clean:
	rm -f ./bin/*.o main