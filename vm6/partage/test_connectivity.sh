#!/bin/bash
###################################################
# Script connectivity test                        #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################

test_funct()
{
if [ $? -ne 0 ]; 
then
	echo "[Error] $1"
    	echo "Exiting process" 
   	exit 0
else
	echo "$1 ... Done"	
fi
}

###################################################
# Reseau IpV4                                     #
###################################################

vm1_test_eth1()
{
	echo "Try to ping vm1 eth1 ..."
	ping -c2 172.16.2.151
	test_funct "ping vm1 eth1"
}

vm1_test_eth2()
{
	echo "Try to ping vm1 eth2 ..."
	ping -c2 172.16.2.131
	test_funct "ping vm1 eth2"
}

vm2_test_eth1()
{
	echo "Try to ping vm2 eth1 ..."
	ping -c2 172.16.2.132
	test_funct "ping vm2 eth1"
}

vm2_test_eth2()
{
	echo "Try to ping vm2 eth2 ..."
	ping -c2 172.16.2.162
	test_funct "ping vm2 eth2"
}

vm3_test_eth1()
{
	echo "Try to ping vm3 eth1 ..."
	ping -c2 172.16.2.163
	test_funct "ping vm3 eth1"
}

vm3_test_eth2()
{
	echo "Try to ping vm3 eth2 ..."
	ping -c2 172.16.2.183
	test_funct "ping vm3 eth2"
}

###################################################
# Reseau IpV6                                     #
###################################################

vm16_test_eth1()
{
	echo "Try to ping vm1 eth1 ..."
	ping -c2 172.16.2.156
	test_funct "ping vm16 eth1"
}

vm16_test_eth2()
{
	echo "Try to ping vm1 eth2 ..."
	ping6 -c2 fc00:1234:1::16
	test_funct "ping6 vm16 eth2"
}

vm26_test_eth1()
{
	echo "Try to ping vm2 eth1 ..."
	ping6 -c2 fc00:1234:1::26
	test_funct "ping6 vm26 eth1"
}

vm26_test_eth2()
{
	echo "Try to ping vm2 eth2 ..."
	ping6 -c2 fc00:1234:2::26
	test_funct "ping6 vm26 eth2"
}

vm36_test_eth1()
{
	echo "Try to ping vm3 eth1 ..."
	ping6 -c2 fc00:1234:2::36
	test_funct "ping6 vm36 eth1"
}

vm36_test_eth2()
{
	echo "Try to ping vm3 eth2 ..."
	ping -c2 172.16.2.186
	test_funct "ping6 vm36 eth2"
}


###################################################
# Connect all LAN                                 #
###################################################


connect_lan1_toleft()
{
	echo "Try to connect LAN1"
	vm1_test_eth2
}

connect_lan1_torigth()
{
	echo "Try to connect LAN1"
	vm2_test_eth1
}

connect_lan2_toleft()
{
	echo "Try to connect LAN2"
	vm2_test_eth2
}

connect_lan2_torigth()
{
	echo "Try to connect LAN2"
	vm3_test_eth1
}

connect_lan3_toleft()
{
	echo "Try to connect LAN3"
	vm16_test_eth1
}

connect_lan3_torigth()
{
	echo "Try to connect LAN3"
	vm1_test_eth1
}

connect_lan4_toleft()
{
	echo "Try to connect LAN4"
	vm3_test_eth2
}

connect_lan4_torigth()
{
	echo "Try to connect LAN4"
	vm36_test_eth2
}

connect_lan16_toleft()
{
	echo "Try to connect LAN16"
	vm16_test_eth2
}

connect_lan16_torigth()
{
	echo "Try to connect LAN16"
	vm26_test_eth1
}

connect_lan26_toleft()
{
	echo "Try to connect LAN26"
	vm26_test_eth2
}

connect_lan26_torigth()
{
	echo "Try to connect LAN26"
	vm36_test_eth1
}

###################################################
# Test phase 1                                    #
###################################################

test_phase1()
{
	echo "Choose what machine want you make out a test :"
	echo " (1) : vm1 "
	echo " (2) : vm2 "
	echo " (3) : vm3 "
	echo " (4) : vm16 "
	echo " (5) : vm26 "
	echo " (6) : vm36 "
	read str

	case "$str" in
	1)  connect_lan1_torigth
	    test_funct "connect_lan1_torigth"
	    connect_lan3_toleft
	    test_funct "connect_lan3_toleft"
	    connect_lan2_torigth
	    test_funct "connect_lan2_torigth"
	    connect_lan4_torigth
	    test_funct "connect_lan4_torigth"
	    echo "connectivity is OK !"
    	    ;;
	2)  connect_lan1_toleft
	    test_funct "connect_lan1_toleft"
	    connect_lan3_toleft
	    test_funct "connect_lan3_toleft"
	    connect_lan2_torigth
	    test_funct "connect_lan2_torigth"
	    connect_lan4_torigth
	    test_funct "connect_lan4_torigth"
	    echo "connectivity is OK !"
    	    ;;
	3)  connect_lan2_toleft
	    test_funct "connect_lan2_toleft"
	    connect_lan4_torigth
	    test_funct "connect_lan4_torigth"
	    connect_lan1_toleft
	    test_funct "connect_lan1_toleft"
	    connect_lan3_toleft
	    test_funct "connect_lan3_toleft"
            echo "connectivity is OK !"
    	    ;;
	4)  connect_lan16_torigth
	    test_funct "connect_lan16_torigth"
	    connect_lan26_torigth
	    test_funct "connect_lan26_torigth"
            echo "connectivity is OK !"
   	    ;;
	5)  connect_lan16_toleft
	    test_funct "connect_lan16_toleft"
	    connect_lan26_torigth
	    test_funct "connect_lan26_torigth"
            echo "connectivity is OK !"
   	    ;;
	6)  connect_lan16_toleft
	    test_funct "connect_lan16_toleft"
	    connect_lan26_toleft
	    test_funct "connect_lan26_toleft"
            echo "connectivity is OK !"
   	    ;;
	*)  echo "this command is not avaible"
            echo "exiting process"
            exit 0
            ;;
	esac
}

###################################################
# Test phase 2                                    #
###################################################

test_phase2()
{
	echo "Choose what machine want you make out a test :"
	echo " (1) : vm1 "
	echo " (2) : vm3 "
	echo " (3) : vm16 "
	echo " (4) : vm26 "
	echo " (5) : vm36 "
	read str

	case "$str" in
	1)  connect_lan3_toleft
	    test_funct "connect_lan3_toleft"
	    connect_lan4_toleft
	    test_funct "connect_lan4_toleft"
	    echo "connectivity is OK !"
    	    ;;
	2)  connect_lan4_torigth
	    test_funct "connect_lan4_torigth"
	    connect_lan3_torigth
	    test_funct "connect_lan3_toleft"
            echo "connectivity is OK !"
    	    ;;
	3)  connect_lan16_torigth
	    test_funct "connect_lan16_torigth"
	    connect_lan26_torigth
	    test_funct "connect_lan26_torigth"
            echo "connectivity is OK !"
   	    ;;
	4)  connect_lan16_toleft
	    test_funct "connect_lan16_toleft"
	    connect_lan26_torigth
	    test_funct "connect_lan26_torigth"
            echo "connectivity is OK !"
   	    ;;
	5)  connect_lan16_toleft
	    test_funct "connect_lan16_toleft"
	    connect_lan26_toleft
	    test_funct "connect_lan26_toleft"
            echo "connectivity is OK !"
   	    ;;
	*)  echo "this command is not avaible"
            echo "exiting process"
            exit 0
            ;;
	esac
}


###################################################
# MAIN                                            #
###################################################

echo "###################################################
# Script connectivity test             		  #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################"

echo "Choose the phase :"
echo " (1) : phase 1 "
echo " (2) : phase 2 "
read phase

case "$phase" in

1)  test_phase1
    ;;
2)  test_phase2
    ;;
*) echo "this command is not avaible"
   echo "exiting process"
   exit 0
   ;;
esac



