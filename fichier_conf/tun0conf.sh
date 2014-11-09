#!/bin/bash

echo "ajout de l'adresse 172.16.1.1 à tun0"
ip addr add 172.16.1.1/28 dev tun0
echo "bring up tun0 ..."
ip link set dev tun0 up
echo "Ajout de la route 172.16.2.176 via tun0 pour contacter le lan4"
ip route add 172.16.2.176/28 via 172.16.1.1 dev tun0
