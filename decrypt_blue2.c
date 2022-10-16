///////////////////////////////////////////////////////////////////////////
// Bluepoint test suite
///////////////////////////////////////////////////////////////////////////

#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#define DEF_DUMPHEX  1   // undefine this if you do not want bluepoint2_dumphex

char cyph[1000] = "";
char orig[1000] = "abcdefghijklmnopqrstuvwxyz";
char pass[128] = "1234";
int slen, plen;

int main(int argc, char *argv[])

{
    long hh;
    int len = sizeof(cyph);
    
    strncpy(cyph, orig, sizeof(cyph));
    slen = strlen(orig);  plen = strlen(pass);
    bluepoint2_encrypt(cyph, slen, pass, plen);
    
    if(argc > 1)
        {
        //printf("argv[1]=%s\n", argv[1]);
        bluepoint2_fromhex(argv[1], strlen(argv[1]), cyph, &len);
        //bluepoint2_tohex(orig, tmplen, tmp2, &tmplen2);
        //printf("undump %s\n",tmp2); 
        }
    if(argc > 2)
        {
        //printf("argv[2]=%s\n",argv[2]);
        strncpy(pass, argv[2], sizeof(pass));
        }
    slen = len; plen = strlen(pass);
    //memcpy(copy, tmp, sizeof(tmp));
    bluepoint2_decrypt(cyph, slen, pass, plen);
    printf("%s\n", cyph);
    
    return 0;
}



