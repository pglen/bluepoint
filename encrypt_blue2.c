///////////////////////////////////////////////////////////////////////////
// Bluepoint test suite
///////////////////////////////////////////////////////////////////////////

#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#define DEF_DUMPHEX  1   // undefine this if you do not want bluepoint2_dumphex

#include "bluepoint.h"
#include "bluepoint2.h"

char copy[1000] = "";
char orig[1000] = "abcdefghijklmnopqrstuvwxyz";
char pass[128] = "1234";
int plen;

#include "hs_crypt.c"

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

    //int slen = strlen(orig); 
    int slen = sizeof(orig); 
    //int plen = strlen(pass);
    int plen = strlen(pass);
   
    bluepoint2_encrypt(orig, slen, pass, plen);
    memcpy(copy, orig, sizeof(orig));
    bluepoint2_decrypt(copy, slen, pass, plen);
    
    printf("decrypt='%s' pass='%s'\n", copy, pass);
    
}




