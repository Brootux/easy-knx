#!/bin/bash
# Updates the current smartHome installation via pulling updates from
# github.com

# Check if the script is run as root
if [ "$(id -u)" != "0" ];
then
	echo
	echo "You have to run this script as root (sudo) !"
	echo
fi

# Save the current path
path=$(pwd)

# Create folders for backup of config
mkdir smarthome_backup
cd smarthome_backup
mkdir etc
mkdir items
mkdir logics

# Go to the repository.
cd /usr/local/smarthome

# Backup the folders etc, items and logics
cp etc/* $path/smarthome_backup/etc
cp items/* $path/smarthome_backup/items
cp logics/* $path/smarthome_backup/logics

# Stop smarthome service
service smarthome stop

# Fetch and pull updates
git fetch
git pull

# Write the backup files back
cp $path/smarthome_backup/etc/* etc/
cp $path/smarthome_backup/items/* items/
cp $path/smarthome_backup/logics/* logics/

# Restart smarthome service
service smarthome start
