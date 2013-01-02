#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>

int
main (int argc, char **argv)
{
        int     ret = -1;
        if (argc != 1)
                printf ("Usage: ./a.out <dirabspath>");
        ret = opendir (argv[1]);
        if (ret)
                printf ("error opendir: %s reason: %s", argv[1], strerror (errno));
        while (1)
                sleep(5);
        return 0;
}
