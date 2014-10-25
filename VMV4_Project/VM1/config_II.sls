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

#eth2:
#  network.managed:
#    - enabled: False
#    - type: eth
#    - proto: none
#    - ipaddr: 172.16.2.131
#    - netmask: 255.255.255.240
#    - gateway: 172.16.2.132
#    - dns:
#      - 139.124.5.132
#      - 139.124.5.131

ip route change default via 172.16.2.156 dev eth1:
  cmd:
    - run

# active le relai ipv4 
#net.ipv4.ip_forward:
#  sysctl:
#    - present
#    - value: 1
