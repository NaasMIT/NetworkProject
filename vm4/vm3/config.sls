# Configuration eth1
# RAPPEL: eth0 est à vagrant, ne pas y toucher


inetutils-inetd:
  pkg:
    - installed


update-inetd --add "echo stream tcp nowait nobody internal":
  cmd:
    - run

eth1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.163
    - gateway: 172.16.2.162
    - netmask: 255.255.255.240

eth2:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.183
    - gateway: 172.16.2.186
    - netmask: 255.255.255.240

ip route add 172.16.2.128/28 via 172.16.2.162 dev eth1:
  cmd:
    - run

ip route add 172.16.2.144/28 via 172.16.2.162 dev eth1:
  cmd:
    - run

ip route add 172.16.2.176/28 via 172.16.2.186 dev eth2:
  cmd:
    - run

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
