# ========================================================================
# Makefile for bluepoint

all:
	@echo Targets: git tools test

tools:  benc2 bdec2 test_blue2 encrypt_blue2 decrypt_blue2 study/tread2

test:  check

check: tools
	@./test_blue2 > tempfile
	diff test_blue2.org tempfile
	@rm tempfile
	@echo This should print \'1234\':
	./decrypt_blue2 `./encrypt_blue2 1234`

study/tread2:  hs_crypt.c study/tread2.c bluepoint2.o
	gcc  ${CFLAGS} bluepoint2.o study/tread2.c -o study/tread2

benc2:  benc2.c hs_crypt.c bluepoint2.o
	gcc  ${CFLAGS} bluepoint2.o benc2.c -o benc2

bdec2:  bdec2.c hs_crypt.c  bluepoint2.o
	gcc  ${CFLAGS} bluepoint2.o bdec2.c -o bdec2

test_blue2: test_blue2.c  bluepoint2.o hs_crypt.c
	gcc  ${CFLAGS} bluepoint2.o test_blue2.c -o test_blue2

encrypt_blue2:  encrypt_blue2.c  bluepoint2.o hs_crypt.c
	gcc  ${CFLAGS} bluepoint2.o encrypt_blue2.c -o encrypt_blue2

decrypt_blue2:  decrypt_blue2.c  bluepoint2.o hs_crypt.c
	gcc  ${CFLAGS} bluepoint2.o decrypt_blue2.c -o decrypt_blue2

git:
	git add .
	git commit -m autocheck
	git push

clean:
	@-rm -f *~
	@-rm -f \#*
	@-rm -f a.out
	@-rm -f aa bb cc *.o  > /dev/null 2>&1
	@-rm -f test_blue2 block_blue > /dev/null 2>&1
	@-rm -f study/tread2 benc2 bdec2 > /dev/null 2>&1













