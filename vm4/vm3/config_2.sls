#ifdown eth1 eth2:
#  cmd:
#    - run

# Configuration eth1
# RAPPEL: eth0 est à vagrant, ne pas y toucher

vim:
  pkg:
    - installed

gdb:
  pkg:
    - installed

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

ip route add 172.16.2.144/28 via 172.16.2.186 dev eth2:
  cmd:
    - run

ifdown eth0 eth1 eth2:
  cmd:
    - run

ifup eth0 eth1 eth2:
  cmd:
    - run
