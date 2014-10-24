# Configuration de l'interface eth1 VM1-6 LAN3
eth1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.156
    - netmask: 255.255.255.240

# Configuration de l'interface eth2 VM1-6 LAN1-6
eth2:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.2.3 # nécessaire mais bidon
    - enable_ipv6: True
    - ipv6proto: static 
    - ipv6addr: fc00:1234:1::16
    - netmask: 64

# Activater ipv4 forwarding
net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1

# Activer ipv6 forwarding
net.ipv6.conf.all.forwarding:
  sysctl:
    - present
    - value: 1
