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



#define BUF_SIZE 1500 /* MTU */


/* Création d'une socket pour communiquer avec le serveur */
int cree_socket_com(char * host, char * port) {

	struct addrinfo hints;
	struct addrinfo *result, *rp;
	int sfd, s;


	/* Obtain address(es) matching host/port */

	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family 	= AF_INET6;     /* Allow IPv4 or IPv6 */
	hints.ai_socktype 	= SOCK_STREAM; 	/* Datagram socket */
	hints.ai_protocol 	= 0;          	/* Any protocol */

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


ssize_t redirect (int src, int dst)
{

	char buff [BUF_SIZE];
	ssize_t nbRcv = 0;
	memset (buff, 0, sizeof (buff));

	printf("redirect .. Read\n");

	if ((nbRcv = read (src, buff, sizeof (buff)) < 0)) {
		fprintf (stderr, "read: %s\n", strerror (errno));
		exit (EXIT_FAILURE);
	}

	printf("redirect .. Write\n");
	if (write (dst, buff, sizeof (buff)) < 0) {
		fprintf (stderr, "write: %s\n", strerror (errno));
		exit (EXIT_FAILURE);
	}

	printf("redirect .. End\n");
	return nbRcv;
}


int launch_client (char * host, char * port) {
	char * interfaceName = NULL;
	int sockfd = -1,
		tun0fd = -1;

	interfaceName = calloc(BUF_SIZE, sizeof(char));
	strcpy(interfaceName, "tun0");

	sockfd = cree_socket_com(host, port);
	tun0fd = tun_alloc (interfaceName);

	while (1)
		redirect (tun0fd, sockfd);

	free(interfaceName);

	return EXIT_FAILURE;
}


#endif /* __CLIENT_H__ */
