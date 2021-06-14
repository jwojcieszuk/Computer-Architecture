all: rpn

main.o: main.c
	cc -m32 -std=c99 -c main.c
rpn.o: rpn.s
	nasm -f elf32 rpn.s
rpn: main.o rpn.o
	cc -m32 -o rpn main.o rpn.o
clean:
	rm main.o rpn.o
.INTERMEDIATE: rpn.o
