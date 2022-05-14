#!/bin/bash
# Control the ELAN Touchpad in Linux Mint

# Find the xinput IDs and enable/disable them
func_enable (){
for id in `xinput | grep ELAN | awk -F"\t" '{ print $2 }' | sed s/id=//gi`
	do xinput enable $id
done
}

func_disable () {
for id in `xinput | grep ELAN | awk -F"\t" '{ print $2 }' | sed s/id=//gi`
        do xinput disable $id
done
}

# Read the command line argument and act upon it.
if [ $1 == 'enable' ]
then
	func_enable
elif [ $1 == 'disable' ]
then
	func_disable
else
	echo -e "Usage:\n\t$0 enable\n\t\tor\n\t$0 disable"
fi
