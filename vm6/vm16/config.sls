ifdown eth1 eth2:
  cmd:
    - run

# Configuration de l'interface eth1 VM1-6 LAN3
eth1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.156
    - gateway: 172.16.2.151
    - netmask: 255.255.255.240

ip route add 172.16.2.128/28 via 172.16.2.151 dev eth1:
  cmd:
    - run

ip route add 172.16.2.176/28 via 172.16.2.151 dev eth1:
  cmd:
    - run

ip route add 172.16.2.160/28 via 172.16.2.151 dev eth1:
  cmd:
    - run

# Configuration de l'interface eth2 VM1-6 LAN1-6
#statique
eth2:            
   network.managed:                                                              
     - enabled: True           
     - type: eth                                                        
     - proto: none                                                   
     - ipaddr: 192.168.2.3     # nécessaire mais bidon                        
     - netmask: 255.255.255.0               
     - enable_ipv6: True                          
     - ipv6proto: static                       
     - ipv6addr: fc00:1234:1::16     
     - ipv6netmask: 64
     - ipv6gateway: fc00:1234:1::26

# active le relai ipv4
net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1

ifdown eth0 eth1 eth2:
  cmd:
    - run

ifup eth0 eth1 eth2:
  cmd:
    - run 
