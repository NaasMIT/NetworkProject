# Configuration de l'interface eth1 VM3-6 LAN2-6
eth1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.2.3 # nécessaire mais bidon
    - enable_ipv6: True
    - ipv6proto: static 
    - ipv6addr: fc00:1234:2::36
    - netmask: 64

# Configuration de l'interface eth2 VM3-6 LAN4
eth2:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.186
    - netmask: 255.255.255.240

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
