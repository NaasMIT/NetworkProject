#ifdown eth1 eth2:
#  cmd:
#    - run

eth1:
   network.managed:
     - enabled: True
     - type: eth
     - proto: none
     - ipaddr: 192.168.2.3     # nécessaire mais bidon
     - netmask: 255.255.255.0
     - enable_ipv6: True
     - ipv6proto: static
     - ipv6addr: fc00:1234:1::26
     - ipv6netmask: 64

# Configuration de l'interface eth2 VM2-6 LAN2-6
eth2:
   network.managed:
     - enabled: True
     - type: eth
     - proto: none
     - ipaddr: 192.168.2.3     # nécessaire mais bidon
     - netmask: 255.255.255.0
     - enable_ipv6: True
     - ipv6proto: static
     - ipv6addr: fc00:1234:2::26
     - ipv6netmask: 64

# Activer ipv6 forwarding
net.ipv6.conf.all.forwarding:
  sysctl:
    - present
    - value: 1

ifdown eth0 eth1 eth2:
  cmd:
    - run

ifup eth0 eth1 eth2:
  cmd:
    - run
