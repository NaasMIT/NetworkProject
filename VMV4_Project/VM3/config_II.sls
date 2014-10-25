ifdown eth1 eth2:
  cmd:
    - run

# Configuration eth1
# RAPPEL: eth0 est à vagrant, ne pas y toucher


inetutils-inetd:
  pkg:
    - installed


update-inetd --add "echo stream tcp nowait nobody internal":
  cmd:
    - run

eth2:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.183
    - gateway: 172.16.2.186
    - netmask: 255.255.255.240
    - dns:
      - 139.124.5.132
      - 139.124.5.131

ip route change default via 172.16.2.186 dev eth2:
  cmd:
    - run

# active le relai ipv4 
#net.ipv4.ip_forward:
#  sysctl:
#    - present
#    - value: 1
