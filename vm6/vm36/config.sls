inetutils-inetd:
  pkg:
    - installed

update-inetd --add "echo stream tcp nowait nobody internal":
  cmd:
    - run

update-inetd --add "echo stream tcp6 nowait nobody internal":
  cmd:
    - run

ifdown eth1 eth2:
  cmd:
    - run

# Configuration de l'interface eth1 VM3-6 LAN2-6
eth1:            
   network.managed:                                                              
     - enabled: True           
     - type: eth                                                        
     - proto: none                                                   
     - ipaddr: 192.168.2.3     # nécessaire mais bidon                        
     - netmask: 255.255.255.0               
     - enable_ipv6: True                          
     - ipv6proto: static                       
     - ipv6addr: fc00:1234:2::36
     - ipv6netmask: 64
     - ipv6gateway: fc00:1234:2::26 

# Configuration de l'interface eth2 VM3-6 LAN4
eth2:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.186
    - netmask: 255.255.255.240
    - gateway: 172.16.2.183

# active le relai ipv4
net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1

ip route add 172.16.2.176/28 via 172.16.2.183:
  cmd:
    - run
