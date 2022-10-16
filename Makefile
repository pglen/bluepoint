# Makefile for console digibank client

all:    bluepoint2.o

test:   test_blue2.c block_blue2.c
	gcc -o test_blue2 test_blue2.c bluepoint2.c
	gcc -o block_blue2 block_blue2.c bluepoint2.c

clean:
	rm -f *~
	rm -f \#*
	rm -f a.out









