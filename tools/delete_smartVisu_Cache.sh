#!/bin/bash
# Delete the temporary smartVisu files

# Check if the script is run as root
if [ "$(id -u)" != "0" ];
then
	echo
	echo "You have to run this script as root (sudo) !"
	echo
fi

# Change to installation path
cd /var/www/smartVISU/temp/

# Remove every folder inside of temp
for d in */.
do
	rm -r ${d/.}
done
