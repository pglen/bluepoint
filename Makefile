# Makefile for console digibank client

all:    

test:   block_blue2 test_blue2 encrypt_blue2 

tools:  benc2 bdec2 tread2 

block_blue2: block_blue2.c  bluepoint2.o hs_crypt.c 
	gcc  ${CFLAGS} bluepoint2.o block_blue2.c -o block_blue2

test_blue2: test_blue2.c  bluepoint2.o hs_crypt.c 
	gcc  ${CFLAGS} bluepoint2.o test_blue2.c -o test_blue2

encrypt_blue2:  encrypt_blue2.c  bluepoint2.o hs_crypt.c 
	gcc  ${CFLAGS} bluepoint2.o encrypt_blue2.c -o encrypt_blue2

tread2:  hs_crypt.c tread2.c bluepoint2.o
	gcc  ${CFLAGS} bluepoint2.o tread2.c -o tread2

benc2:  benc2.c hs_crypt.c bluepoint2.o
	gcc  ${CFLAGS} bluepoint2.o benc2.c -o benc2

bdec2:  bdec2.c hs_crypt.c  bluepoint2.o
	gcc  ${CFLAGS} bluepoint2.o bdec2.c -o bdec2

clean:
	@-rm -f *~
	@-rm -f \#*
	@-rm -f a.out
	@-rm -f aa bb cc *.o  > /dev/null 2>&1
	@-rm -f test_blue2 encrypt_blue2 block_blue > /dev/null 2>&1
	@-rm -f tread2 benc2 bdec2 > /dev/null 2>&1
    










