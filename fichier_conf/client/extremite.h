/*
 ============================================================================
 Name        : extremite.h
 Author      : Abdelhak KHEMIRI, Nabil ADRAR, Nacer BELLIL
 Version     : 1.0
 Copyright   : Your copyright notice
 Description : bibliothèque qui gére le trafic entre extrémités du tunnel.
 ============================================================================
 */


#ifndef __EXTREMITE_H__
#define __EXTREMITE_H__

#include "serveur.h"
#include "client.h"


/*
 * Lance le serveur ext-out en écoute sur le port 123 et
 * qui redige le trafic sur la sortie standard
 * */
void ext_out (void) {

	launch_serv("123");

} /* ext_out() */


void ext_in (char * host, char * port) {

	launch_client(host, port);

}



#endif /* __EXTREMITE_H__ */
