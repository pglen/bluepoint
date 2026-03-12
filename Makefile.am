# ========================================================================
# Makefile for bluepoint

#bin_PROGRAMS =   benc2 bdec2 test_blue2 encrypt_blue2 decrypt_blue2

BLUES = bluepoint.c bluepoint2.c bluepoint3.c
ONES = 11111111

all: tools

help:
	@echo Targets: git build test

build:  bluepoint.c bluepoint2.c bluepoint3.c
	@gcc -c bluepoint.c
	@gcc -c bluepoint2.c
	@gcc -c bluepoint3.c

tools: test_blue test_blue2 test_blue3              \
        bencbdec

        #encrypt_blue  decrypt_blue                  \
        #encrypt_blue2 decrypt_blue2                 \
        #encrypt_blue3 decrypt_blue3

test: tools
	@./test_blue2 > tempfile
	@echo "Tests pass if diff (below) is silent."
	@diff test_blue2.org tempfile
	@rm tempfile

test2:
	@echo ${ONES} >ones
	@./bencbdec -e -p 1234 -f ones > aa
	@./bencbdec -d -p 1234 -f aa > bb
	@echo "Tests pass if diff (below) is silent."
	@diff ones bb
	@rm -f ones aa bb

test3:
	@echo -n ${ONES} >ones
	@./bencbdec -e -p 1234 ${ONES} | ./bencbdec -d -p 1234 -f - > bb
	@echo "Tests pass if diff (below) is silent."
	@diff ones bb
	@rm -f ones aa bb

bencbdec: ${BLUES} hs_crypt.c bencbdec.c
	gcc  ${CFLAGS} ${BLUES} bencbdec.c -o bencbdec

test_blue: ${BLUES} test_blue.c hs_crypt.c
	gcc  bluepoint.c test_blue.c -o test_blue

test_blue2: ${BLUES} test_blue2.c  hs_crypt.c
	gcc  bluepoint2.c  bluepoint3.c test_blue2.c -o test_blue2

test_blue3: ${BLUES} test_blue3.c hs_crypt.c
	gcc  bluepoint3.c  test_blue3.c -o test_blue3

test_dump: test_dump.c hs_crypt.c  bluepoint3.c
	gcc  bluepoint3.c  test_dump.c -o test_dump

encrypt_blue:  encrypt_blue.c  bluepoint.c hs_crypt.c
	gcc  ${CFLAGS} bluepoint.c encrypt_blue.c -o encrypt_blue

decrypt_blue:  decrypt_blue.c  bluepoint.c hs_crypt.c
	gcc  ${CFLAGS} bluepoint.c decrypt_blue.c -o decrypt_blue

encrypt_blue2:  encrypt_blue2.c  bluepoint2.c hs_crypt.c
	gcc  ${CFLAGS} bluepoint2.c encrypt_blue2.c -o encrypt_blue2

decrypt_blue2:  decrypt_blue2.c  bluepoint2.c hs_crypt.c
	gcc  ${CFLAGS} bluepoint2.c decrypt_blue2.c -o decrypt_blue2

encrypt_blue3:  encrypt_blue3.c  bluepoint3.c hs_crypt.c
	gcc  ${CFLAGS} bluepoint3.c encrypt_blue3.c -o encrypt_blue3

decrypt_blue3:  decrypt_blue3.c  bluepoint3.c hs_crypt.c
	gcc  ${CFLAGS} bluepoint3.c decrypt_blue3.c -o decrypt_blue3

git:
	git add .
	git commit -m autocheck
	git push

clean:
	@-rm -f *~ \#* a.out
	@-rm -f *.o
	@-rm -f aa bb cc *.o  > /dev/null 2>&1
	@-rm -f test_blue test_blue2 test_blue3 block_blue > /dev/null 2>&1
	@-rm -f study/tread2  bencbdec > /dev/null 2>&1
	@-rm -f encrypt_blue  decrypt_blue  > /dev/null 2>&1
	@-rm -f encrypt_blue2 decrypt_blue2 > /dev/null 2>&1
	@-rm -f encrypt_blue3 decrypt_blue3 > /dev/null 2>&1
	@-rm -f block_blue2 > /dev/null 2>&1

md5sum:
	@rm md5sum.txt
	@find . -maxdepth 1 -type f -exec  md5sum {}  >> md5sum.txt \;

install:
	cp bencbdec /usr/local/bin


# EOF