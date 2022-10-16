///////////////////////////////////////////////////////////////////////////
// Bluepoint test suite
///////////////////////////////////////////////////////////////////////////

#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "getopt.h"

#define DEF_DUMPHEX  1   // undefine this if you do not want bluepoint2_dumphex
#include "bluepoint2.h"

int verbose = 0;

char tmp[1000] = "";
char cyph[1000] = "";
char orig[1000] = "abcdefghijklmnopqrstuvwxyz";
char pass[128] = "1234";

int  tmplen2 = 0;
int slen, plen;

void help()

{
    printf("\nUsage: decrypt_blue [options] [cyphertext] \n");
    printf("\nOptions: \n");
    printf("       -p password   --pass password\n");
    printf("       -v            --verbose\n");
    printf("\n");
}


static struct option long_options[] = {
   {"help", 0, 0, 0},
   {"pass", 1, 0, 0},
   {"file", 1, 0, 0},
   {0, 0, 0, 0}
	};

//static char options[] = "abcd:012fhio:lmnpqrstvy";
static char options[] = "p:v";

int     main(int argc, char *argv[])

{
    long hh;
    int len = sizeof(cyph);
    memset(tmp, '\0', sizeof(tmp));

    // Parse options
    while (1)
        {
        //int this_option_optind = optind ? optind : 1;
        int opt_index = 0;
        int cc = getopt_long (argc, argv, options, long_options, &opt_index);
        if (cc == -1)
           break;
        switch (cc)
           {
           case 0:
               //printf ("long option %s", long_options[opt_index].name);
               //if (optarg)
               //    printf (" with arg %s", optarg);
               //printf ("\n");

                if(strcmp(long_options[opt_index].name, "help") == 0)
                    {
                    help();
                    exit(0);
                    }
                if(strcmp(long_options[opt_index].name, "pass") == 0)
                    {
                    strncpy(pass, optarg, sizeof(pass));
                    }
            break;

            case 'v':
                //printf ("option v %s\n", optarg);
                verbose = 1;
            break;

            case 'p':
                strncpy(pass, optarg, sizeof(pass));
                //printf ("option p %s\n", optarg);
            break;

            case '?':
               //printf ("Invalid option ? %s\n", optarg);
               help();
               exit(1);
            break;
            }
        }

    int offs = 0;
    if(argc > optind)
        {
        //printf("argv[1]='%s'\n", argv[1]);
        strncpy(tmp, argv[optind], sizeof(tmp));
        }
    else
        {
        // We got pipe
        while(1)
            {
            if(offs >= sizeof(tmp))
                break;

            if(feof(stdin))
                break;
            char chh = 0;
            int ret = fread(&chh, 1, 1, stdin);
            if(chh != '\n')
                {
                tmp[offs] = chh;
                offs++;
                }
            }
        }

     offs = strlen(tmp);

     if(verbose)
        printf("in: %d '%s'\n", offs, tmp);

    bluepoint2_fromhex(tmp, offs, cyph, &len);
    slen = len; plen = strlen(pass);
    bluepoint2_decrypt(cyph, slen, pass, plen);
    printf("%s\n", cyph);

    return 0;
}

// EOF