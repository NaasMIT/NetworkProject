vim:
  pkg:
    - installed
gdb:
  pkg:
    - installed

ifdown eth1 eth2:
  cmd:
    - run

eth1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 172.16.2.151
    - netmask: 255.255.255.240
    - gateway: 172.16.2.156
    - dns:
      - 139.124.5.132
      - 139.124.5.131

ip route add 172.16.2.176/28 via 172.16.2.156 dev eth1:
  cmd:
    - run

ifdown eth0 eth1 eth2:
  cmd:
    - run

ifup eth0 eth1 eth2:
  cmd:
    - run
