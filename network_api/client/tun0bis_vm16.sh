#!/bin/bash

echo "###################################################
# Script création tun0 lancement client           #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################"

echo "[MIT_Script] Redémarrage des paramètres réseaux"
/etc/init.d/networking restart

if [[ -f client ]]
then 
   echo "[MIT_Script] Client déjà compilé !"
else  
   echo "[MIT_Script] Compilation du programme de création du tunnel tun0 coté client ..."
   make
   if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Programme non compilé tun0 ne peut être créé" 
      exit 0
   fi
   echo "[MIT_Script] [OK]"
fi

echo "[MIT_Script] Lancement de tun0 et du client ..."
make run &
sleep 10
if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Erreur lors du lancement de tun0 et/ou de la connexion au serveur" 
      exit 0
fi
echo "[MIT_Script] [OK]"

echo "[MIT_Script] ajout de l'adresse 172.16.1.1 à tun0"
ip addr add 172.16.1.1/28 dev tun0
if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Erreur lors de l'ajout de l'adresse à l'interface tun0" 
fi
echo "[MIT_Script] [OK]"

echo "[MIT_Script] bring up tun0 ..."
ip link set dev tun0 up
if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Erreur lors du démarrage de  l'interface tun0" 
fi
echo "[MIT_Script] [OK]"

echo "[MIT_Script] Ajout de la route 172.16.2.176 via tun0 pour contacter le lan4\n"
ip route add 172.16.2.176/28 via 172.16.1.1 dev tun0
if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Erreur lors de l'ajout de la route de redirection vers LAN4" 
fi
echo "[MIT_Script] [OK]"

echo "[MIT_Script] Démarrage eth0"
ifup eth0
if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Erreur lors du démarrage de  l'interface eth0" 
fi
echo "[MIT_Script] [OK]"
