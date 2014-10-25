#!/bin/bash

ip addr add 172.16.1.1/28 dev tun0

ip link set dev tun0 up
