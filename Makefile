# Makefile

test_blue: test_blue.c bluepoint.c bluepoint.h
	cc -g test_blue.c bluepoint.c -o test_blue -lefence

clean:
	rm test_blue;





