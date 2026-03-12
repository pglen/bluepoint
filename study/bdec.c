///////////////////////////////////////////////////////////////////////////
// Bluepoint file decryption
///////////////////////////////////////////////////////////////////////////

#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#include "bluepoint2.h"

char buff[4096];
char pass[128];
int plen;

#include "hs_crypt.c"

int main(int argc, char *argv[])

{
    strcpy(pass, "1234");
    plen = strlen(pass);

    if(argc < 2)
        {
        fprintf(stderr, "Usage: bdec2 infile\n");
        exit(1);
        }

    FILE *fp = fopen(argv[1], "r");
    if (!fp)
        {
        fprintf(stderr, "File %s must exist.\n", argv[1]);
        exit(1);
        }
    while(1)
        {
        memset(buff, 0, sizeof(buff));
        int loop, len = fread(buff, 1, sizeof(buff), fp);
        if(len == 0)
            break;

        //#fprintf(stderr, "read len %d\n", len);
        hs_decrypt(buff, sizeof(buff), pass, plen);

        for (loop = 0; loop < sizeof(buff); loop++)
            putchar(buff[loop]);

        if(len < sizeof(buff))
            break;
        }
    exit(0);
}








