# ========================================================================
# Makefile for bluepoint

bin_PROGRAMS =   benc2 bdec2 test_blue2 encrypt_blue2 decrypt_blue2

all: tools

help:
	@echo Targets: git build test

build: tools
	gcc -c bluepoint.c
	gcc -c bluepoint2.c
	gcc -c bluepoint3.c

tools: benc2 bdec2 test_blue test_blue2 test_blue3 encrypt_blue2 decrypt_blue2

test: tools
	@./test_blue2 > tempfile
	@diff test_blue2.org tempfile
	@rm tempfile

benc2:  benc2.c hs_crypt.c bluepoint2.o  bluepoint3.o
	gcc  ${CFLAGS} bluepoint2.o  bluepoint3.o benc2.c -o benc2

bdec2:  bdec2.c hs_crypt.c  bluepoint2.o  bluepoint3.o
	gcc  ${CFLAGS} bluepoint2.o  bluepoint3.o bdec2.c -o bdec2

test_blue: test_blue.c  bluepoint.o hs_crypt.c  bluepoint3.o
	gcc  bluepoint.o test_blue.c -o test_blue

test_blue2: test_blue2.c  bluepoint2.o hs_crypt.c  bluepoint3.o
	gcc  bluepoint2.o  bluepoint3.o test_blue2.c -o test_blue2

test_blue3: test_blue3.c hs_crypt.c  bluepoint3.o
	gcc  bluepoint3.o  test_blue3.c -o test_blue3

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
	@-rm -f test_blue test_blue2 block_blue > /dev/null 2>&1
	@-rm -f study/tread2 benc2 bdec2 > /dev/null 2>&1

# EOF