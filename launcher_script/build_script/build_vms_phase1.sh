#!/bin/bash
###################################################
# Script building VMs phase 2                     #
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

###################################################
# BUILDING vm1, vm2, vm3                          #
###################################################
remove_and_create_vm4()
{
echo "Building vm4, search folder vm4 ..."
cd ../vm4
test_funct "cd"

for i in {1,2,3}
do

	echo "Search file ../vm$i ..."
	cd vm$i
	test_funct "cd"
	if [[ -d .vagrant ]] 
	then
		rm -r .vagrant/
		test_funct "rm"
   		echo ".vagrant/ has been removed!"
		echo "Launching vm$i ..."
		vagrant up
		test_funct "vagrant up"
	else
   		echo "Launching vm$i ..."
		vagrant up
		test_funct "vagrant up"
	fi
	echo "vm$i was successfully created !"
	echo "return in the directory vm4 ..."
	cd ..
	test_funct "cd"
done
echo "end building vm4 "
echo "return in the directory NetworkProject ..."
cd ..
test_funct "cd"
}

###################################################
# BUILDING vm16, vm26, vm36                       #
###################################################

remove_and_create_vm6()
{
echo -n "Lauching vm, search folder vm6 ..."
cd vm6
test_funct "cd"

for i in {16,26,36}
do

	echo "Search file ../vm$i"
	cd vm$i
	test_funct "cd"
	if [[ -d .vagrant ]] 
	then
		rm -r .vagrant/
		test_funct "rm"
   		echo ".vagrant/ has been removed!"
		echo "Launching vm$i ..."
		vagrant up
		test_funct "vagrant up"
	else
   		echo "Launching vm$i ..."
		vagrant up
		test_funct "vagrant up"
	fi
	echo "vm$i was successfully launched !"
	echo "return in the directory vm6 ..."
	cd ..
	test_funct "cd"
done
echo "end building vm6 "
}

simple_launch_vm4()
{
echo "Launching vm4, search folder vm4 ..."
cd ../vm4
test_funct "cd"

for i in {1,2,3}
do

	echo "Search file ../vm$i ..."
	cd vm$i
	test_funct "cd"
   	echo "Launching vm$i ..."
	vagrant up
	test_funct "vagrant up"
	echo "vm$i was successfully launched !"
	echo "return in the directory vm4 ..."
	cd ..
	test_funct "cd"
done
echo "end launch vm4 "
echo "return in the directory NetworkProject ..."
cd ..
test_funct "cd"
}

simple_launch_vm6()
{
echo -n "Launching vm, search folder vm6 ..."
cd vm6
test_funct "cd"

for i in {16,26,36}
do
	echo "Search file ../vm$i"
	cd vm$i
	test_funct "cd"
   	echo "Launching vm$i ..."
	vagrant up
	test_funct "vagrant up"
	echo "vm$i was successfully launched !"
	echo "return in the directory vm6 ..."
	cd ..
	test_funct "cd"
done
echo "end launch vm6 "
}

###################################################
# MAIN                                            #
###################################################

echo "###################################################
# Script building VMs phase 1                     #
# Version 1.0 // BELLIL | ADRAR | KHEMIRI         #
###################################################"

echo "Choose option :"
echo " ''create'' : for remove and create all vms"
echo " ''launch'' : for launch all vms"
read str
if [ "$str" = "create" ]; then
	remove_and_create_vm4
	remove_and_create_vm6
	elif [ "$str" = "launch" ]; then
		simple_launch_vm4
		simple_launch_vm6
	else
		echo "this command is not avaible"
		echo "exiting process"
		exit 0;
fi
