#include <errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/socket.h>

#include <linux/if.h>
#include <linux/if_tun.h>

int tun_alloc(char * dev)
{
   int fd;
   int err;
   struct ifreq ifr;

   if ((fd = open ("/dev/net/tun", O_RDWR)) < 0) {
      perror("création tun");
      exit (EXIT_FAILURE);
   }

   memset (&ifr, 0, sizeof(ifr));

   /* Flags: IFF_TUN   - TUN device (no Ethernet headers)
    *        IFF_TAP   - TAP device
    *
    *        IFF_NO_PI - Do not provide packet information
    */
   ifr.ifr_flags = IFF_TUN;

   if (*dev) {
      strncpy(ifr.ifr_name, dev, IFNAMSIZ);
   }

   if ((err = ioctl(fd, TUNSETIFF, (void *) &ifr)) < 0 ) {
      close(fd);
      return err;
   }

   strcpy(dev, ifr.ifr_name);
   return fd;
}

void tun_read (int src, int dst)
{
   char buff [1024];
   memset (buff, 0, sizeof (buff));

   if (read (src, buff, sizeof (buff)) < 0) {
      fprintf (stderr, "read: %s\n", strerror (errno));
      exit (EXIT_FAILURE);
   }

   if (write (dst, buff, sizeof (buff)) < 0) {
      fprintf (stderr, "write: %s\n", strerror (errno));
      exit (EXIT_FAILURE);
   }
}

int main (int argc, char ** argv)
{
   int tun0fd;

   if (argc < 2) {
      fprintf (stderr, "Usage: %s interface\n", argv [0]);
      exit (EXIT_FAILURE);
   }

   tun0fd = tun_alloc (argv [1]);
   tun_read (tun0fd, 1);

   while (1);

   return EXIT_FAILURE;
}
