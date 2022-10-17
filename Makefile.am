# ========================================================================
# Makefile for bluepoint

bin_PROGRAMS =   benc2 bdec2 test_blue2 encrypt_blue2 decrypt_blue2

all: tools

help:
	@echo Targets: git build test

build: tools
	gcc -c bluepoint2.c

tools: benc2 bdec2 test_blue2 encrypt_blue2 decrypt_blue2

test: tools
	@./test_blue2 > tempfile
	diff test_blue2.org tempfile
	@rm tempfile
	@echo This should print \'1234\':
	./decrypt_blue2 `./encrypt_blue2 1234`

benc2:  benc2.c hs_crypt.c bluepoint2.o  bluepoint3.o
	gcc  ${CFLAGS} bluepoint2.o  bluepoint3.o benc2.c -o benc2

bdec2:  bdec2.c hs_crypt.c  bluepoint2.o  bluepoint3.o
	gcc  ${CFLAGS} bluepoint2.o  bluepoint3.o bdec2.c -o bdec2

test_blue2: test_blue2.c  bluepoint2.o hs_crypt.c  bluepoint3.o
	gcc  bluepoint2.o  bluepoint3.o test_blue2.c -o test_blue2

encrypt_blue2:  encrypt_blue2.c  bluepoint2.o bluepoint3.o hs_crypt.c
	gcc  ${CFLAGS} bluepoint2.o bluepoint3.o  encrypt_blue2.c -o encrypt_blue2

decrypt_blue2:  decrypt_blue2.c  bluepoint2.o bluepoint3.o hs_crypt.c
	gcc  ${CFLAGS} bluepoint2.o bluepoint3.o decrypt_blue2.c -o decrypt_blue2

git:
	git add .
	git commit -m autocheck
	git push

clean:
	@-rm -f *~
	@-rm -f \#*
	@-rm -f *.o
	@-rm -f *.exe
	@-rm -f a.out
	@-rm -f aa bb cc *.o  > /dev/null 2>&1
	@-rm -f test_blue2 block_blue > /dev/null 2>&1
	@-rm -f study/tread2 benc2 bdec2 > /dev/null 2>&1


# EOF