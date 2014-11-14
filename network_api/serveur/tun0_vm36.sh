#!/bin/bash

echo "###################################################
# Script création tun0 lancement serveur          #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################"

if [[ -f client ]]
then 
   echo "[MIT_Script] Serveur déjà compilé !"
else  
   echo "[MIT_Script] Compilation du programme de création du tunnel tun0 coté serveur ..."
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

./tun0bis_vm36.sh &

./serveur
if [ $? -ne 0 ]; 
   then
      echo "[MIT_Script] [Erreur]"
      echo "[MIT_Script] Erreur lors du lancement de tun0 et/ou de la connexion au serveur" 
      exit 0
fi
echo "[MIT_Script] [OK]"
