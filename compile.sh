#nasm -f elf prime.asm
#ld -s -melf_i386 -o prime.out prime.o
#./prime.out
nasm -f elf -l prime.lst -g prime.asm
gcc -g -m32 -o prime.out prime.o
./prime.out

