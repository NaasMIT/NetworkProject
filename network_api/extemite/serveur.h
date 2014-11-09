/*
 ============================================================================
 Name        : extremite.h
 Author      : Abdelhak KHEMIRI, Nabil ADRAR, Nacer BELLIL
 Version     : 1.0
 Copyright   : Your copyright notice
 Description : bibliothèque qui gére le trafic entre extrémités du tunnel.
 ============================================================================
 */

#ifndef __SERVEUR_H__
#define __SERVEUR_H__

#include <asm-generic/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <unistd.h>

#include "client.h"


/* Nombre maximum de clients simultanées */
#define MAXCLIENT 10

/* taille maximale des lignes */
#define MAXLIGNE 80


typedef struct {
	int socket;
	int compteur;
	char hote[NI_MAXHOST];
	char port[NI_MAXSERV];
} TClient;

TClient *tableau[MAXCLIENT];


void init_client (TClient * client) {
	client->socket = -1;
	client->compteur = 0;
} /* init_client() */


void init_tableau (void) {
	int i = 0;
	for (i = 0; i < MAXCLIENT; ++i) {
		TClient * client = (TClient *) malloc (sizeof(TClient));
		init_client(client);
		tableau[i] = client;
	}
} /* init_tableau() */



TClient * trouve_dispo(void) {
	int i = 0;
	for (i = 0; i < MAXCLIENT; ++i)
		if (tableau[i]->socket == -1)
			return tableau[i];
	return NULL;
} /* trouve_dispo() */


int affiche_client(TClient * client) {

	struct sockaddr_in6 adresse;
	unsigned longueur = sizeof(adresse);
	int err;


	err = getpeername(client->socket, (struct sockaddr*) & adresse, &longueur);
	if (err<0){
		return -1;
	}


	/* Nom réseau du client */
	err = getnameinfo((struct sockaddr*) &adresse, longueur,
			client->hote, NI_MAXHOST, client->port, NI_MAXSERV,0);

	if (err < 0 ) {
		fprintf(stderr,"résolution client (%i): %s\n",client->socket, gai_strerror(err));
		return -1;
	} else {
		fprintf(stderr,"accept! (%i) ip=%s port=%s\n",client->socket, client->hote, client->port);
	}

	return 0;

} /* affiche_client() */



TClient * ajoute_client(int socket_client) {
	TClient *clientLibre = trouve_dispo();

	if (clientLibre == NULL) {
		fprintf(stderr,"Nombre de client max atteint de par le serveur (%d)!, \
				réesayer plus tard ! \n", MAXCLIENT);
		return NULL;
	}

	clientLibre->socket = socket_client;

	return clientLibre;
} /* ajoute_client() */


int max_client() {
	int max = -1,
		i   =  0;

	for (i = 0; i < MAXCLIENT; ++i)
		if(max < tableau[i]->socket)
			max = tableau[i]->socket;

	return max;
} /* max_client() */


/* Création d'une socket d'écoute pour le serveur */
int cree_socket_ecoute(char * port) {

	struct addrinfo hints;
	struct addrinfo *res, *p;
	int socket_ecoute = 0;
	int on = 1,
		err = -1;

	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_INET6;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE;


	err = getaddrinfo(NULL, port, &hints, &res);
	if (err != 0) {
		printf("erreur %s\n", gai_strerror(err));
		exit(EXIT_FAILURE);
	}

	for (p = res; p != NULL; p = p->ai_next) {
		socket_ecoute = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
		if (socket_ecoute < 0) continue;

		/* On rend le port réutilisable rapidement /!\ */
		if (setsockopt(socket_ecoute,SOL_SOCKET,SO_REUSEADDR,&on,sizeof(on)) < 0) {
			perror("option socket");
			exit(4);
		}

		fprintf(stderr,"Option(s) OK!\n");


		err = bind(socket_ecoute, p->ai_addr, p->ai_addrlen);
		if (err < 0) {
			close(socket_ecoute);
			continue;
		}

		break;
	}

	if (NULL == p) {
		printf("erreur\n");
		return -1;
	}

	freeaddrinfo(res);

	err = listen(socket_ecoute, MAXCLIENT);

	if (err < 0) {
		return -1;
	}

	fprintf(stderr,"Ecoute sur le port %s\n",port);

	return socket_ecoute;
} /* cree_socket_ecoute() */



ssize_t redirige_trafic_sur_stdout (TClient * client) {

	ssize_t lu; 				/* nb d'octets reçus */
	char msg[MAXLIGNE+1]; 		/* tampons pour les communications */
	char tampon[MAXLIGNE+1];
	int pid = getpid(); 		/* pid du processus -- pas de fork donc toujours le meme ! */

	/* Faire echo et logguer */
	lu = recv(client->socket, tampon, MAXLIGNE, 0);
	if ( lu > 0 )
	{
		client->compteur += 1;
		tampon[lu] = '\0';

		/* log */
		fprintf(stderr,"[%s:%s](%i): %3i :%s", client->hote, client->port,
				pid, client->compteur, tampon);

		snprintf(msg,MAXLIGNE,"> %s",tampon);
	}

	return lu;
}


void deconnexion_client (TClient * client) {

	int pid = getpid(); /* pid du processus -- pas de fork donc toujours le meme ! */

	/* le correspondant a quitté */
	close(client->socket);
	fprintf(stderr,"[%s:%s](%i): Terminée.\n", client->hote, client->port, pid);
}


/* La scrutation se fait seulement pour detecté
 * l'arrivée de nouveau message ou client donc en lecture uniquement */
int scrutation(int socket_ecoute) {
	int tun0fd = -1;
	char * interfaceName = calloc(BUF_SIZE, sizeof(char));
	strcpy(interfaceName, "tun0");

	tun0fd = tun_alloc(interfaceName);

	if (tun0fd < 0) return -1;

	printf("interface tun0 crée\n");

	while (1) {
		int i = 0;
		int nbSocketReady = 0;
		int nfds = max_client();
		fd_set readfs;

		nfds = (nfds < socket_ecoute) ? (socket_ecoute) : (nfds);

		FD_ZERO(&readfs);
		FD_SET(socket_ecoute, &readfs);

		for (i = 0; i < MAXCLIENT; ++i) {
			if (tableau[i]!= NULL) {
				if (tableau[i]->socket != -1)
					FD_SET(tableau[i]->socket, &readfs);
			}
		}

		nbSocketReady = select(nfds+1, &readfs, NULL, NULL, NULL);

		if (nbSocketReady < 0) return -1;

		printf("scrutation ...\n");

		for (i = 0; i < MAXCLIENT; ++i) {
			if (tableau[i]->socket != -1) {
				if(FD_ISSET(tableau[i]->socket, &readfs)) {
					if (redirect(tableau[i]->socket, tun0fd) <= 0) {
						/* Dialogue terminé on déconnecte */
						deconnexion_client(tableau[i]);
						init_client(tableau[i]);
					}
				}
			}
		}

		/* Si aucune socket client n'est prete en lecture donc
		 * aucun client n'a envoyer de msg, on vérifie que aucun client
		 * n'est en attente de connection sur la socket d'ecoute */
		if (FD_ISSET(socket_ecoute, &readfs)) {
			TClient * new_client = NULL;
			struct sockaddr_in6 distant;
			socklen_t sock_length = sizeof(distant);

			int new_socket = accept(socket_ecoute, (struct sockaddr *)&distant, &sock_length);
			if (new_socket < 0) return -1;

			new_client = ajoute_client(new_socket);

			affiche_client(new_client);
		}
	}

	free(interfaceName);
	return -1 ; /* jamais atteint en realité */
} /* scrutation() */


int launch_serv(char * port) {
	int socket_ecoute = -1;
	init_tableau();
	socket_ecoute = cree_socket_ecoute(port);

	if (socket_ecoute < 0) return -1;

	while (1)
		scrutation(socket_ecoute);

	return -1; /* jamais atteint en realité */
} /* launch_serv() */


#endif /* __SERVEUR_H__ */
