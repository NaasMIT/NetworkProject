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

ip route add 172.16.2.144/28 via 172.16.2.131:
  cmd:
    - run

ip route add 172.16.2.176/28 via 172.16.2.163:
  cmd:
    - run

# active le relai ipv4 
net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1
