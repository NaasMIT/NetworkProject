#!/bin/bash

echo "###################################################
# Script création tun0 lancement client           #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################"

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

./tun0bis_vm16.sh &

./client
if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Erreur lors du lancement de tun0 et/ou de la connexion au serveur" 
      exit 0
fi
echo "[MIT_Script] [OK]"
