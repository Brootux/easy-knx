#!/bin/sh
#
# Bash-Script to install neccessary packets and files for house-automation
# This script is based on "selfbus_eib.sh" from https://github.com/selfbus/linux-bus-tools
#
#
# Author: Brootux 
#         (https://github.com/Brootux, http://brootux.wordpress.com/)

path=$(pwd)

installTheFollowing()
{
	# Neccesary steps (dont remove any)
	updateApt
	installPrerequisites
	
	# Setup from selfbus-script
	installEibd
	installLinknx
	installKnxWeb2

	# extended steps
	installSmartHomePy
	installSmartVISU
	setupNavigation
	freeTTYAMA0

	# Print some steps, the user has to do manually
	exitInformations
}

########################################################################
# You should not manipulate anything from here downwards!
# (Just if you know what u are doing)
########################################################################

checkRights()
{
	if [ $(id -u) -ne 0 ]
		then
			echo
			echo
			echo "##############################################################################"
			echo "# You should run this script as root (sudo)!!!"
			echo "##############################################################################"
			echo
			echo
			exit 1
	fi
}

updateApt()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Update Apt..."
	echo "##############################################################################"
	# Update apt
	apt-get -y update
	# Upgrade apt
	#apt-get -y upgrade
	# Install prerequisites
	apt-get -y install tmux vim
	apt-get -y install libmysqlclient-dev liblog4cpp5-dev libxml2-dev libesmtp-dev liblua5.1-0-dev libcurl4-openssl-dev
}

installPrerequisites()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Installing Prerequesites..."
	echo "##############################################################################"
	echo "#    - Installing apache2..."
	echo "##############################################################################"
	apt-get -y install apache2
	echo "##############################################################################"
	echo "#    - Installing php..."
	echo "##############################################################################"
	apt-get -y install php5
	echo "##############################################################################"
	echo "#    - Installing mysql..."
	echo "##############################################################################"
	apt-get -y install mysql-server mysql-client php5-mysql
}

installPthsem()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Load and install pthsem..."
	echo "##############################################################################"
	cd /tmp
	wget -N https://github.com/selfbus/linux-bus-tools/raw/master/raspberry/Packs/pthsem_2.0.8-1_armhf.deb
	dpkg -i pthsem_2.0.8-1_armhf.deb
	LD_LIBRARY_PATH="/usr/lib/"
	ldconfig
}

installEibd()
{
	installPthsem
	echo
	echo
	echo "##############################################################################"
	echo "# Load and install EIBD (BCUSDK)..."
	echo "##############################################################################"
	cd /tmp
	eibdDeb="eibd_0.0.5-1_armhf.deb"
	wget -N https://github.com/selfbus/linux-bus-tools/raw/master/raspberry/Packs/$eibdDeb
	dpkg -i $eibdDeb
	cd /etc/init.d
	wget -N https://github.com/selfbus/linux-bus-tools/raw/master/raspberry/Scripts/eibd
	chmod a+x eibd
	update-rc.d eibd defaults
	# Start eibd
	service eibd start
}

installLinknx()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Load and install Linknx..."
	echo "##############################################################################"
	cd /tmp
	wget -N https://github.com/selfbus/linux-bus-tools/raw/master/raspberry/Packs/linknx_0.0.1.30-1_armhf.deb 
	dpkg -i linknx_0.0.1.30-1_armhf.deb 
	cd /etc/init.d
	wget -N https://github.com/selfbus/linux-bus-tools/raw/master/raspberry/Scripts/linknx
	chmod a+x linknx
	update-rc.d linknx defaults
	mkdir /var/lib/linknx/
	mkdir /var/lib/linknx/persist/
	mkdir /var/lib/linknx/persistlog/
	touch /var/lib/linknx/logging.conf
	chmod a+rw /var/lib/linknx/logging.conf
	cd /etc
	wget -N https://github.com/selfbus/linux-bus-tools/raw/master/raspberry/Scripts/linknx.xml
	chmod a+rw linknx.xml
}

installSmartHomePy()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Load and install SmartHome.py..."
	echo "##############################################################################"
	# Install the following packages
	#    - openntpd (for network time, normally replaces "ntp")
	#    - python with addtionally tools
	#    - ephem (for sunrise/sunset handling)
	apt-get -y install openntpd python3 python3-dev python3-setuptools
	easy_install3 pip
	pip3.2 install ephem
	# Download smarthome
	smarthomeVersion="1.0"
	wget https://github.com/mknx/smarthome/archive/${smarthomeVersion}.tar.gz -O /tmp/${smarthomeVersion}.tar.gz
	# Install smarthome in given path
	cd /usr/local
	tar xvzf /tmp/${smarthomeVersion}.tar.gz
	# Rename folder to just "smarthome"
	mv smarthome-${smarthomeVersion} smarthome
	# Copy example configuration into smarthome
	cp -f $path/res/smarthome.conf /usr/local/smarthome/etc
	cp -f $path/res/logic.conf /usr/local/smarthome/etc
	cp -f $path/res/plugin.conf /usr/local/smarthome/etc
	cp -f $path/res/knx.conf /usr/local/smarthome/items
	# Setup proper rights for user pi
	chgrp pi smarthome
	# Move startup-script to the right place (/etc/init.d/)
	cp -f $path/res/smarthome /etc/init.d/
	# Setup proper rights for startup script
	chmod 755 /etc/init.d/smarthome
	# Add startup-script to boot-process
	update-rc.d smarthome defaults
	# Start smarthome
	service smarthome start
}

installKnxWeb2()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Load and install KnxWeb2..."
	echo "##############################################################################"
	cd /tmp
	wget -O knxweb2.tar "http://linknx.cvs.sourceforge.net/viewvc/linknx/knxweb/knxweb2/?view=tar"
	tar xvf knxweb2.tar -C /var/www
	chown -R www-data /var/www/knxweb2/pictures/
	chown -R www-data /var/www/knxweb2/design/ 
	mkdir /var/www/knxweb2/template/template_c/ 
	chown -R www-data /var/www/knxweb2/template/template_c/
	chown -R www-data /var/www/knxweb2/include/ 
	rm /var/www/knxweb2/design/.empty
	cd /var/www
	chgrp -R www-data knxweb2
	chmod -R 775 knxweb2
}

installSmartVISU()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Load and install SmartVISU..."
	echo "##############################################################################"
	# Download smartVisu into "/var/www/"
	cd /var/www
	visuName="smartVISU_2.7.zip"
	wget https://smartvisu.googlecode.com/files/$visuName
	# Unzip smartVisu and remove zipped package
	unzip $visuName
	rm $visuName
	# Set the proper rights for user www-data
	chgrp -R www-data smartVISU
	chmod -R 775 smartVISU
}

setupNavigation()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Setting up navigation page..."
	echo "##############################################################################"
	# Copy delivered index.html into "/var/www/"
	cp -f $path/res/index.html /var/www/
}

freeTTYAMA0()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Freeing ttyAMA0..."
	echo "##############################################################################"
	# Free "/etc/inittab"
	sed '/getty.*ttyAMA0/s/^[^#]/#/' </etc/inittab >/tmp/x && mv /tmp/x /etc/inittab
	# Free "/boot/cmdline.txt"
	awk '{ printf $1 " " $4 " " $5 " " $6 " " $7 " " $8 }' </boot/cmdline.txt >/tmp/x && mv /tmp/x /boot/cmdline.txt
}

exitInformations()
{
	echo
	echo
	echo "##############################################################################"
	echo "# Important user informations"
	echo "##############################################################################"
	echo "#"
	echo "# You should at least do now (if you do not done this before):"
	echo "#     - run >raspi-config< and setup:"
	echo "#         - expand root-fs"
	echo "#         - setup password"
	echo "#         - setup locals (keyboar, language)"
	echo "#         - set GPU memory split to lowest"
	echo "#         - do not start X after pi bootup"
	echo "#         - enable ssh"
	echo "#         - setup overclocking as liked"
	echo "#     - RESTART this machine with >shutdown -r now< !!!!"
	echo "#"
	echo "##############################################################################"
}


# Check if the script is run as root
checkRights

# Start installation
installTheFollowing
