easy-knx
========

Easy install script for KNX (Selfbus Harware, Eibd, LinKNX/Smarthome.py, KnxWeb2/SmartVisu, ...).

# Description

This project can be used to simply install everything needed for basic service of a Selfbus/Freebus-KNX system. The following things will be installed automatically:

  * Apache2
  * PHP
  * MySQL (You have to setup a password while installation)
  * Eibd for Freebus/Selfbus (FT1.2 Adapter)
  * Logic-Layers LinKNX and SmartHome.py (primary SmartHome.py)
  * Visualisations KnxWeb2 and SmartVisu (primary SmartVisu)

# Installation

## Prerequisites

  * This script(s) is assuming, that its running on a freh installed SD-Card-Image. So there is no guarantee to work on systems where i.e. an older Apache version is already running!
  * If you run this script a second time, be sure to backup your configuration-files before. They may be overwritten!
  * The Pi has to be connected to the internet.

## Hardware setup

You can use the "normal" Freebus/Selfbus KNX-Adapter (FT1.2 , http://selfbus.myxwiki.org/xwiki/bin/view/Selfbus/FT12_Raspi). Its an open-hardware project, so you could build an Adapter yourself (see Downloads for Circuit-Board, Firmware and so on).

## Software setup

* Clone this git-repository
  * `git clone https://github.com/Brootux/easy-knx.git`
  * change into the new directory `cd rc_switch_server.py`
* Setup what to install
  * You can comment-out what you do not want to install with a trailing `#` on a line inside the function `installTheFollwing`
  * i.e. you can skip installation of LinKNX by commenting-out via `#installLinknx`
  * You have to do this with your favourite text-editor! (i.e. nano, vi, vim)
* run the installRCS.sh bash-script (as root or with sudo)
  * `./easy_install.sh`
  * maybe you have to run `chmod 755 easy_install.sh` first!
* You should now open a browser and connect to your Raspberry Pi. You should see an overview page now!
* Do the last steps, recommended by the install script (At least reboot the pi `sudo shutdown -r now`)

# Tools

The scripts in the "tools" are meant to be little helper-scripts for creating your Home-Automation System. Currently there are:

* delete_smartVisu_Cache.sh - deletes the temporary files of SmartVisu to recreate the cached files on visit

# What now?

# SmartHome configuration

While the installation, there is a example configuration copied into the smarthome folder. You can find all configuration-files in the following folders:

  * `/usr/local/smarthome/...`
   * __etc/__: general smarthome configuration files
   * __items/__: configuration of items, you can use for example in SmartVisu

It is highly recommended to change the example configuration to match your needs. You can find more about the general and item configuration at http://mknx.github.io/smarthome/config.html and for plugins you can read more at .
http://mknx.github.io/smarthome/plugin.html.
# SmartVisu configuration

ToDo
