#!/bin/bash
###################################################
# Script launcher VMs                             #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################

test_funct()
{
if [ $? -ne 0 ]; 
then
	echo "[Erreur] current function $1"
    	echo "Exiting process" 
   	exit 0
else
	echo "$1 ... Done"	
fi
}

echo "###################################################
# Script launcher VMs                 		  #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################"

echo "Necessary obtaining of the rights ..."

chmod u+x build_script/build_vms_phase1.sh
test_funct "chmod"

chmod u+x build_script/build_vms_phase2.sh
test_funct "chmod"


echo "Choose option :"
echo " ''phase 1'' : for launch phase 1"
echo " ''phase 2'' : for launch phase 2"
read str
if [ "$str" = "phase 1" ]; then
	./build_script/build_vms_phase1.sh
	test_funct "build_vms_phase1"
	elif [ "$str" = "phase 2" ]; then
		./build_script/build_vms_phase2.sh
		test_funct "build_vms_phase2"
	else
		echo "this command is not avaible"
		echo "exiting process"
		exit 0;
fi
