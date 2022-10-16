///////////////////////////////////////////////////////////////////////////
// Bluepoint test suite
///////////////////////////////////////////////////////////////////////////

#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#define DEF_DUMPHEX  1   // undefine this if you do not want bluepoint_dumphex

#include "bluepoint.h"


	char orig[128] = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz";
	char copy[128] = "";
	//char pass[128] = "01234456789";
	//char pass[128] = "0123445678901234456789012344567890";
	char pass[128] = "1";

int main(int argc, char *argv[])

{
	long hh;

	strncpy(copy, orig, sizeof(copy));

	if(argc > 1)
		{
		//printf("argv[1]=%s\n", argv[1]);
		strncpy(orig, argv[1], sizeof(orig));
		strncpy(copy, argv[1], sizeof(copy));
		}

	if(argc > 2)
		{
		//printf("argv[2]=%s\n",argv[2]);
		strncpy(pass, argv[2], sizeof(pass));
		}

	printf("orignal='%s' pass='%s'\n", orig, pass);

	int slen = strlen(orig);
	int plen = strlen(pass);

	bluepoint_encrypt(orig, slen, pass, plen);

	printf("ENCRYPTED: \n");
	printf("%s", bluepoint_dumphex(orig, slen));
	printf("\nEND ENCRYPTED\n");

	// exit(0);

	char   dumped[256];
	memset(dumped, 'x', sizeof(dumped));
    int olen = sizeof(dumped);

	bluepoint_tohex(orig, slen, dumped, &olen);

	printf("TOHEX: \n");
	printf("'%s'", dumped);
	printf("\nEND TOHEX\n");

	char   dumped2[256];
	memset(dumped2, 'y', sizeof(dumped2));
    int olen2 = sizeof(dumped2);
	bluepoint_fromhex(dumped, olen, dumped2, &olen2);

	//printf("FROMHEX: \n");
	//printf("'%s'", dumped2);
	//printf("\nEND FROMHEX\n");

	// printf("CYPHERHASH: \n");
	// hh = bluepoint_hash(orig, slen);
    // printf("%d 0x%08x\n", hh, hh);

	bluepoint_decrypt(dumped2, olen2, pass, plen);

	printf("decrypted='%s'\n", dumped2);

	//bluepoint_decrypt(orig, slen, pass, plen);
	//printf("decrypted='%s'\n", orig);

	printf("HASH:\n");
	hh = bluepoint_hash(copy, slen);
    printf("%d 0x%08x\n", hh, hh);

	printf("CRYPTHASH: \n");
	hh = bluepoint_crypthash(copy, slen, pass, plen);
    printf("%d 0x%08x\n", hh, hh);

}

