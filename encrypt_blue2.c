///////////////////////////////////////////////////////////////////////////
// Bluepoint test suite
///////////////////////////////////////////////////////////////////////////

#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "getopt.h"

#define DEF_DUMPHEX  1   // undefine this if you do not want bluepoint2_dumphex

#include "bluepoint2.h"
#include "bluepoint3.h"

int verbose = 0;
int alg_3   = 0;
int rounds  = 0;

char copy[1000] = "";
char cyph[1000] = "";

char orig[1000] = "abcdefghijklmnopqrstuvwxyz";
char tmp[1000] = "";

char pass[128] = "1234";
int slen, plen;

void help()

{
    printf("\nUsage: encrypt_blue [options] [orgtext] \n");
    printf("\nOptions: \n");
    printf("       -p password   --pass password | the password\n");
    printf("       -v            --verbose       | verbosity level\n");
    printf("       -3            --three         | select algorythm\n");
    printf("       -r rounds                     | rounds for algorythm\n");
    printf("\n");
}

static struct option long_options[] = {
   {"help", 0, 0, 0},
   {"pass", 1, 0, 0},
   {"file", 1, 0, 0},
   {0, 0, 0, 0}
	};

//static char options[] = "abcd:012fhio:lmnpqrstvy";
static char options[] = "p:v3r:";

int main(int argc, char *argv[])

{
    long hh;
    int tmplen = sizeof(tmp);

    strncpy(copy, orig, sizeof(copy));
    strncpy(cyph, orig, sizeof(copy));

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

            case '3':
                //printf ("option 3 %s\n", optarg);
                alg_3 = 1;
            break;

            case 'h':
                help();
                exit(1);
            break;

            case 'p':
                //printf ("option p %s\n", optarg);
                strncpy(pass, optarg, sizeof(pass));
            break;

            case 'r':
                rounds = atoi(optarg);
                //printf("rounds %d\n", rounds);
            break;

            case '?':
               //printf ("Invalid option ? %s\n", optarg);
               help();
               exit(1);
            break;
            }
        }
    if(argc > optind)
        {
        //printf("argv[optind]='%s'\n", argv[optind]);
        strncpy(orig, argv[optind], sizeof(orig));
        strncpy(copy, argv[optind], sizeof(copy));
        strncpy(cyph, argv[optind], sizeof(cyph));
        }

    //printf("orig='%s' pass='%s'\n", orig, pass);

    if(rounds)
        bluepoint3_set_rounds(rounds);

    slen = strlen(orig); plen = strlen(pass);

    //printf("plen %d\n", plen);

    if(alg_3)
        bluepoint3_encrypt(cyph, slen, pass, plen);
    else
        bluepoint2_encrypt(cyph, slen, pass, plen);

    memcpy(copy, cyph, sizeof(cyph));

    bluepoint2_tohex(cyph, slen, tmp, &tmplen);
    printf("%s\n", tmp);

    //printf("Cypher: %s\n", tmp);

    if(alg_3)
        bluepoint3_decrypt(copy, slen, pass, plen);
    else
        bluepoint2_decrypt(copy, slen, pass, plen);

    ////printf("copy='%s' pass='%s'\n", copy, pass);

    if(verbose)
        {
        printf("org: '%s'\n", orig);
        printf("dec: '%s'\n", copy);
        }

    if(strcmp(copy, orig) != 0)
        {
        printf("Error on enc / dec cycle\n");
        }
    return 0;
}

// EOF