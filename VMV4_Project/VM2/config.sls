#LAN1
eth1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.132
    - netmask: 255.255.255.240

#LAN2
eth2:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.162
    - netmask: 255.255.255.240

# Ne marche pas (encore) pour Debian avec salt stable
# # route par défaut (global)
# system:
#     network.system:
#       - enabled: True
#       - gateway: None
# => Commandes shell
# Pas de passerelle par défaut

#ip route del default:
#  cmd:
#    - run

# active le relai ipv4 
net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1
