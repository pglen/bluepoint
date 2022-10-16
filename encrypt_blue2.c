///////////////////////////////////////////////////////////////////////////
// Bluepoint test suite
///////////////////////////////////////////////////////////////////////////

#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#define DEF_DUMPHEX  1   // undefine this if you do not want bluepoint2_dumphex

#include "bluepoint2.h"

char copy[1000] = "";
char cyph[1000] = "";

char orig[1000] = "abcdefghijklmnopqrstuvwxyz";
char tmp[1000] = "";

char pass[128] = "1234";
int slen, plen;

int main(int argc, char *argv[])

{
    long hh;
    int tmplen = sizeof(tmp);
    
    strncpy(copy, orig, sizeof(copy));
    strncpy(cyph, orig, sizeof(copy));
   
    if(argc > 1)
        {
        //printf("argv[1]=%s\n", argv[1]);
        strncpy(orig, argv[1], sizeof(orig));
        strncpy(copy, argv[1], sizeof(copy));
        strncpy(cyph, argv[1], sizeof(cyph));
        }
    if(argc > 2)
        {
        //printf("argv[2]=%s\n",argv[2]);
        strncpy(pass, argv[2], sizeof(pass));
        }
    //printf("orig='%s' pass='%s'\n", orig, pass);
    slen = strlen(orig); plen = strlen(pass);
    bluepoint2_encrypt(cyph, slen, pass, plen);
    memcpy(copy, cyph, sizeof(cyph));
    
    bluepoint2_tohex(cyph, slen, tmp, &tmplen);
    printf("%s\n", tmp);
    bluepoint2_decrypt(copy, slen, pass, plen);
    //printf("copy='%s' pass='%s'\n", copy, pass);
    //printf("'%s' '%s'", orig, copy);
    if(strcmp(copy, orig) != 0)
        {
        printf("Error on enc / dec cycle\n");
        }
    return 0;
}







