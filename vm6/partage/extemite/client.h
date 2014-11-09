/*
 ============================================================================
 Name        : extremite.h
 Author      : Abdelhak KHEMIRI, Nabil ADRAR, Nacer BELLIL
 Version     : 1.0
 Copyright   : Your copyright notice
 Description : bibliothèque qui gére le trafic entre extrémités du tunnel.
 ============================================================================
 */

#ifndef __CLIENT_H__
#define __CLIENT_H__


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



#define BUF_SIZE 1500 // MTU


/* Création d'une socket pour communiquer avec le serveur */
int cree_socket_com(char * host, char * port) {

	struct addrinfo hints;
	struct addrinfo *result, *rp;
	int sfd, s;


	/* Obtain address(es) matching host/port */

	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family = AF_INET6;     /* Allow IPv4 or IPv6 */
	hints.ai_socktype = SOCK_STREAM; /* Datagram socket */
	hints.ai_protocol = 0;          /* Any protocol */

	s = getaddrinfo(host, port, &hints, &result);

	if (s != 0) {
		fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(s));
		exit(EXIT_FAILURE);
	}

	/* getaddrinfo() returns a list of address structures.
       Try each address until we successfully connect(2).
       If socket() (or connect()) fails, we (close the socket and) try the next address.
	 */

	for (rp = result; rp != NULL; rp = rp->ai_next) {
		sfd = socket(rp->ai_family, rp->ai_socktype,
				rp->ai_protocol);
		if (sfd == -1)
			continue;

		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
			break;                  /* Success */

		close(sfd);
	}

	if (rp == NULL) {               /* No address succeeded */
		fprintf(stderr, "Could not connect\n");
		exit(EXIT_FAILURE);
	}

	freeaddrinfo(result);           /* No longer needed */

	return sfd;
}



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
	char buff [BUF_SIZE];
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


int launch_client (char * host, char * port) {
	char * interfaceName = calloc(BUF_SIZE, sizeof(char));
	strcpy(interfaceName, "tun0");

	int sockfd = cree_socket_com(host, port);
	int tun0fd = tun_alloc (interfaceName);

	while (1)
		tun_read (tun0fd, sockfd);

	return EXIT_FAILURE;
}

int set_ip(char * iface_name, char * ip_addr)
{
   int sockfd;
   struct ifreq ifr;
   struct sockaddr_in sin;

   if (!iface_name) {
      return -1;
   }

   if ((sockfd = socket (AF_INET, SOCK_DGRAM, 0)) == -1) {
      fprintf (stderr, "socket: %s\n", strerror (errno));
      return -1;
   }

   /* get interface name */
   strncpy (ifr.ifr_name, iface_name, IFNAMSIZ);

   /* Read interface flags */
   if (ioctl (sockfd, SIOCGIFFLAGS, &ifr) < 0) {
      fprintf (stderr, "ifdown: shutdown ");
      perror (ifr.ifr_name);
      return -1;
   }

   /*
    * Expected in <net/if.h> according to "UNIX Network Programming".
    */
#ifdef ifr_flags
# define IRFFLAGS       ifr_flags
#else   /* Present on kFreeBSD */
# define IRFFLAGS       ifr_flagshigh
#endif

   // If interface is down, bring it up
   if (!(ifr.IRFFLAGS & IFF_UP)) {
      fprintf (stdout, "Device is currently down..setting up.-- %u\n",ifr.IRFFLAGS);
      ifr.IRFFLAGS |= IFF_UP;

      if (ioctl(sockfd, SIOCSIFFLAGS, &ifr) < 0) {
         fprintf (stderr, "ifup: failed ");
         perror (ifr.ifr_name);
         return -1;
      }
   }

   sin.sin_family = AF_INET;
   // Convert IP from numbers and dots to binary notation
   inet_aton(ip_addr,(struct in_addr *) &sin.sin_addr.s_addr);
   memcpy(&ifr.ifr_addr, &sin, sizeof(struct sockaddr));
   // Set interface address
   if (ioctl(sockfd, SIOCSIFADDR, &ifr) < 0) {
      fprintf (stderr, "Cannot set IP address. ");
      perror (ifr.ifr_name);
      return -1;
   }
#undef IRFFLAGS
   return 0;
}

void usage()
{
   const char * usage = { "./set_ip [interface] [ip address]\n" };
   fprintf (stderr, "%s", usage);
}


#endif /* __CLIENT_H__ */
