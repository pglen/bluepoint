///////////////////////////////////////////////////////////////////////////
// Bluepointx test encrypter. Outputs to stdout.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <getopt.h>

#include <linux/limits.h>

#include "bluepoint.h"
#include "bluepoint2.h"
#include "bluepoint3.h"

char buff[4096];
char pass[128];

//void    dump_buff(const char *ptr, int len)
//{
//    int olen = 3 * len;
//    char *ret = malloc(olen);
//    if(!ret) return;
//    bluepoint3_tohex(ptr, len, ret, &olen);
//    ret[olen] = '\0';
//    fprintf(stderr, "dump: %s\n", ret);
//    free(ret);
//}

int verbose = 0;
int alg     = 3;
int rounds  = 0;
int encdec  = 0;

char orig[1000] = ""; //abcdefghijklmnopqrstuvwxyz";
char pass[128] = "";
char file[PATH_MAX] = "";

static  int     docrypt(char *ptr, int len, const char *pass, int plen)
{
    if(verbose)
        fprintf(stderr, "mode=%d alg=%d len=%d pass: '%s' plen=%d\n",
                        encdec, alg, len, pass, plen);
    //dump_buff(ptr, len);

    if(encdec == 1)
        {
        if(alg == 3)
            {
            bluepoint3_encrypt(ptr, len, (char *)pass, plen);
            }
        if(alg == 2)
            {
            bluepoint2_encrypt(ptr, len, (char*)pass, plen);
            }
        if(alg == 1)
            {
            bluepoint_encrypt(ptr, len, (char*)pass, plen);
            }
        }
    else if(encdec == 2)
        {
        if(alg == 3)
            {
            bluepoint3_decrypt(ptr, len, (char*)pass, plen);
            }
        if(alg == 2)
            {
            bluepoint2_decrypt(ptr, len, (char*)pass, plen);
            }
        if(alg == 1)
            {
            bluepoint_decrypt(ptr, len, (char*)pass, plen);
            }
        }
    //dump_buff(ptr, len);
    //fprintf(stderr, "buff res: '%s'\n", ptr);
}

static  void    dohash64(char *ptr, int len, const char *pass, int plen)
{
    long long hhh  = 0;
    //printf("hash buff %s %d pass %s %d\n", ptr, len, pass, plen);
    if(alg == 3)
        {
        hhh = bluepoint3_crypthash64(ptr, len, (char*)pass, plen);
        }
    if(alg == 2)
        {
        hhh = bluepoint2_crypthash64(ptr, len, (char*)pass, plen);
        }
    if(alg == 1)
        {
        hhh = bluepoint_crypthash64(ptr, len, (char*)pass, plen);
        }
    printf("%llx\n", hhh);
}

static  void  dohash(char *ptr, int len, const char *pass, int plen)
{
    long hhh = 0;
    //printf("hash buff %s %d pass %s %d\n", ptr, len, pass, plen);
    if(alg == 3)
        {
        hhh = bluepoint3_crypthash(ptr, len, (char*)pass, plen);
        }
    if(alg == 2)
        {
        hhh = bluepoint2_crypthash(ptr, len, (char*)pass, plen);
        }
    if(alg == 1)
        {
        hhh = bluepoint_crypthash(ptr, len, (char*)pass, plen);
        }
    printf("%lx\n", hhh);
}

static  void    doall(char *ptr, int len, const char *pass, int plen)

{
    if(encdec == 4)
        {
        dohash64(ptr, len, pass, plen);
        }
    else if(encdec == 3)
        {
        dohash(ptr, len, pass, plen);
        }
    else
        {
        docrypt(ptr, len, pass, plen);
        for (int loop = 0; loop < len; loop++)
            printf("%c", ptr[loop]);
        fflush(stdout);
        }
}

void help()

{
    printf("Usage: bencbdec [options] [ORGTEXT] \n");
    printf("Options:\n");
    printf("       -p PASS    --pass PASS     -  the password. (quotes for embedded spaces)\n");
    printf("       -f FILE    --file FILE     -  the file to operate on ('-' for stdin)\n");
    printf("       -e         --enc           -  encrypt to stdout\n");
    printf("       -d         --dec           -  decrypt to stdout\n");
    printf("       -s         --hash          -  print hexadecimal hash\n");
    printf("       -S         --hash64        -  print 64-bit hex hash\n");
    printf("       -a ALG     --algo ALG      -  select algorythm (1 or 2 or 3) def=3\n");
    printf("       -r ROUNDS  --rounds ROUNDS -  number of rounds for algorythm \n");
    printf("       -v         --verbose       -  increase verbosity level (for tests)\n");
    printf("       -h         --help          -  help (this screen)\n");
    printf("Must specify one of -e -d -s -S. PASS is mandatory.\n");
    printf("Needs FILE or ORGTEXT to supply data to operate on. FILE has precedence.\n");
    exit(0);
}

static struct option long_options[] = {
   {"help",   0, 0, 0},
   {"enc",    0, 0, 0},
   {"dec",    0, 0, 0},
   {"hash",   0, 0, 0},
   {"hash64", 0, 0, 0},
   {"algo",   1, 0, 0},
   {"pass",   1, 0, 0},
   {"file",   1, 0, 0},
   {0,        0, 0, 0}
};
static char options[] = "vedsShp:a:r:f:";

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
                    }
                if(strcmp(long_options[opt_index].name, "pass") == 0)
                    {
                    strncpy(pass, optarg, sizeof(pass));
                    }
                if(strcmp(long_options[opt_index].name, "file") == 0)
                    {
                    strncpy(file, optarg, sizeof(file));
                    }
                if(strcmp(long_options[opt_index].name, "algo") == 0)
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
                if(strcmp(long_options[opt_index].name, "hash") == 0)
                    {
                    encdec = 3;
                    }
                if(strcmp(long_options[opt_index].name, "hash64") == 0)
                    {
                    encdec = 4;
                    }
            break;

            case 's':
                encdec = 3;
            break;

            case 'S':
                encdec = 4;
            break;

            case 'f':
                strncpy(file, optarg, sizeof(file));
            break;

            case 'v':
                verbose += 1;
            break;

            case 'e':
                encdec = 1;
            break;

            case 'd':
                encdec = 2;
            break;

            case 'a':
                alg = atoi(optarg);
            break;

            case 'h':
                help();
            break;

            case 'p':
                strncpy(pass, optarg, sizeof(pass));
            break;

            case 'r':
                rounds = atoi(optarg);
            break;

            case '?':
               //printf ("Invalid option ? %s\n", optarg);
               help();
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
        fprintf(stderr,
    "Must specify one of -e or -d or -s or -S (--enc / --dec / --hash / --hash64)\n");
        exit(1);
        }
    if(alg < 1 || alg > 3)
        {
        fprintf(stderr, "Must specify valid algorithm as -a 1 or -a 2 or -a 3\n");
        exit(1);
        }
    if(pass[0] == '\0')
        {
        fprintf(stderr, "Must specify password (-p or --pass)\n");
        exit(1);
        }
    //printf("alg=%d pass='%s' file='%s'\n", alg, pass, file);
    if(file[0] == '\0')
        {
        // Any comline strings?
        if(argc > optind)
            {
            if(verbose > 1)
                fprintf(stderr, "comline: argv[optind]='%s'\n", argv[optind]);
            strncpy(orig, argv[optind], sizeof(orig));
            int slen = strlen(orig), plen = strlen(pass);
            doall(orig, slen, pass, plen);
            exit(0);
            }
        else
            {
            fprintf(stderr, "Must specify file or string to operate on.\n");
            exit(1);
            }
        }
    FILE *fp;
    if (file[0] == '-')
        fp = stdin; //fdopen(0, "rb");
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
        int len = fread(buff, 1, sizeof(buff), fp);
        if(len <= 0)            // Nothing
            break;
        //printf("buff '%s'\n", buff);
        doall(buff, len, pass, plen);
        if(len < sizeof(buff))  // Done
            break;
        }
    fclose(fp);
    exit(0);
}

// EOF
