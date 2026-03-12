///////////////////////////////////////////////////////////////////////////
// Bluepoint2 test encrypter. Outputs to stdout.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>

#include "bluepoint.h"
#include "bluepoint2.h"
#include "bluepoint3.h"

char buff[4096];
char pass[128];

int verbose = 0;
int alg     = 3;
int rounds  = 0;
int encdec  = 0;

//char copy[1000] = "";
//char cyph[1000] = "";

char orig[1000] = ""; //abcdefghijklmnopqrstuvwxyz";
char pass[128] = "";
char file[256] = "";

static struct option long_options[] = {
   {"help", 0, 0, 0},
   {"enc",  0, 0, 0},
   {"dec",  0, 0, 0},
   {"alg",  1, 0, 0},
   {"pass", 1, 0, 0},
   {"file", 1, 0, 0},
   {0,      0, 0, 0}
};

int     docrypt(char *ptr, int len, const char *pass, int plen)
{
    if(encdec == 1)
        {
        if(alg == 3)
            {
            //printf("enc buff %s %d pass %s %d\n", ptr, len, pass, plen);
            bluepoint3_encrypt(ptr, len, (char *)pass, plen);
            }
        if(alg == 2)
            {
            //printf("enc buff %s %d pass %s %d\n", ptr, len, pass, plen);
            bluepoint2_encrypt(ptr, len, (char*)pass, plen);
            }
        if(alg == 1)
            {
            //printf("enc buff %s %d pass %s %d\n", ptr, len, pass, plen);
            bluepoint_encrypt(ptr, len, (char*)pass, plen);
            }
        }
    if(encdec == 2)
        {
        if(alg == 3)
            {
            //printf("enc buff %s %d pass %s %d\n", ptr, len, pass, plen);
            bluepoint3_decrypt(ptr, len, (char*)pass, plen);
            }
        if(alg == 2)
            {
            //printf("enc buff %s %d pass %s %d\n", ptr, len, pass, plen);
            bluepoint2_decrypt(ptr, len, (char*)pass, plen);
            }
        if(alg == 1)
            {
            //printf("enc buff %s %d pass %s %d\n", ptr, len, pass, plen);
            bluepoint_decrypt(ptr, len, (char*)pass, plen);
            }
        }
}

static char options[] = "vedhp:a:r:f:";
void help()

{
    printf("\nUsage: bencbdec [options] [orgtext] \n");
    printf(" Options:\n");
    printf("       -p PASS    --pass PASS     -  the password.\n");
    printf("       -f FILE    --file FILE     -  the file to operate on ('-' for stdin).\n");
    printf("       -e         --enc           -  encrypt.\n");
    printf("       -d         --dec           -  decrypt.\n");
    printf("       -a ALG     --algo ALG      -  select algorythm (1 2 3) def: 3.\n");
    printf("       -r ROUNDS  --rounds ROUNDS -  number of rounds for algorythm.\n");
    printf("       -v         --verbose       -  verbosity level.\n");
    printf("       -h         --help          -  help (this screen)\n");
}
// Parse options
int     parse_comline(int argc, char *argv[])
{
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
                if(strcmp(long_options[opt_index].name, "file") == 0)
                    {
                    strncpy(file, optarg, sizeof(file));
                    }
                if(strcmp(long_options[opt_index].name, "alg") == 0)
                    {
                    alg = atoi(optarg);
                    }
                if(strcmp(long_options[opt_index].name, "enc") == 0)
                    {
                    encdec = 1;
                    }
                if(strcmp(long_options[opt_index].name, "dec") == 0)
                    {
                    encdec = 2;
                    }
            break;

            case 'f':
                //printf ("option f %s\n", optarg);
                strncpy(file, optarg, sizeof(file));
            break;

            case 'v':
                //printf ("option v %s\n", optarg);
                verbose = 1;
            break;

            case 'e':
                //printf ("option v %s\n", optarg);
                encdec = 1;
            break;

            case 'd':
                //printf ("option v %s\n", optarg);
                encdec = 2;
            break;

            case 'a':
                //printf ("option a %s\n", optarg);
                alg = atoi(optarg);
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
}

// -----------------------------------------------------------------------

int     main(int argc, char *argv[])

{
    parse_comline(argc, argv);

    if(encdec == 0)
        {
        fprintf(stderr, "Must specify one of -e or -d (--enc or --dec)\n");
        exit(1);
        }
    if(alg < 1 || alg > 3)
        {
        fprintf(stderr, "Must specify alorythm as 1 or 2 or 3\n");
        exit(1);
        }
    if(pass[0] == '\0')
        {
        fprintf(stderr, "Must specify password\n");
        exit(1);
        }
    //printf("alg=%d pass='%s' file='%s'\n", alg, pass, file);
    if(file[0] == '\0')
        {
        // Any comline strings?
        if(argc > optind)
            {
            //printf("comline: argv[optind]='%s'\n", argv[optind]);
            strncpy(orig, argv[optind], sizeof(orig));
            int slen = strlen(orig), plen = strlen(pass);
            docrypt(orig, slen, pass, plen);
            for (int loop = 0; loop < slen; loop++)
                {
                putchar(orig[loop]);
                }
            exit(0);
            }
        else
            {
            fprintf(stderr, "Must specify file or string to encrypt.\n");
            exit(1);
            }
        }
    FILE *fp;
    if (file[0] == '-')
        fp = stdin;
    else
        fp = fopen(file, "rb");

    if (!fp)
        {
        fprintf(stderr, "File '%s' must exist.\n", file);
        exit(1);
        }
    int plen = strlen(pass);
    memset(buff, 0, sizeof(buff));
    while(1)
        {
        int loop, len = fread(buff, 1, sizeof(buff), fp);
        if(len == 0)            // Nothing
            break;
        docrypt(buff, len, pass, plen);
        for (loop = 0; loop < len; loop++)
            putchar(buff[loop]);
        if(len < sizeof(buff))  // Done
            break;
        }
    exit(0);
}

// EOF
