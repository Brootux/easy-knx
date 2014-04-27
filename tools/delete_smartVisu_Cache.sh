#!/bin/bash

cd /var/www/smartVISU/temp/

if [ "$(id -u)" != "0" ];
then
	echo
	echo "You have to run this script as root (sudo) !"
	echo
else
	for d in */.
	do
		rm -r ${d/.}
	done
fi
