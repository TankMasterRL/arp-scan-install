#!/usr/bin/env bash
# TODO: Fix compiler for RPi, long long support.
# Configuration variables
LIBPCAP_VERSION="1.6.1"


# Functions
rpicompiler()
{
	OPTION=$1
	if [ "$OPTION" = "true" ]; then
		echo "Downloading RPi compatible compiler"
		echo
		sudo apt-get install linux-compiler-gcc-4.7-arm
		echo
	fi
}

libpcap()
{
	OPTION=$1
	if [ "$OPTION" = "true" ] || [ "$OPTION" = "update" ]; then
		echo "Downloading/Updating libpcap"
		echo
		wget -N "http://www.tcpdump.org/release/libpcap-${LIBPCAP_VERSION}.tar.gz"
		echo
		tar -xf "libpcap-${LIBPCAP_VERSION}.tar.gz"
		cd "libpcap-${LIBPCAP_VERSION}"
	else
		cd "libpcap-${LIBPCAP_VERSION}"
		make dist-clean
	fi

	echo
	echo "Configurating libpcap"
	echo
	# Detect if RPi is build platform
	if [ "$(grep -o BCM2708 /proc/cpuinfo)" = "BCM2708" ]; then
		echo "Detected RPi as build platform"
		echo
		# CC=../tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/bin/gcc ./configure --build=arm-linux-gnueabihf
		CC=gcc-4.7 ./configure --build=arm-linux-gnueabihf
	else
		./configure
	fi
	echo
	echo "Making and installing libpcap"
	echo
	make && sudo make install
	echo
	echo "Latest libpcap installed!"
	echo
	cd ..
}

arpscan()
{
	OPTION=$1
	if [ "$OPTION" = "true" ]; then
		echo "Downloading arp-scan"
		echo
		git clone https://github.com/royhills/arp-scan.git --depth 1
		cd arp-scan
	elif [ "$OPTION" = "update" ]; then
		cd arp-scan
		echo "Pulling arp-scan repository updates"
		echo
		git pull
	else
		cd arp-scan
		make dist-clean
	fi
	
	echo
	echo "Configurating arp-scan"
	echo
	autoreconf --install
	echo
	# Detect if RPi is build platform
	if [ "$(grep -o BCM2708 /proc/cpuinfo)" = "BCM2708" ]; then
		echo "Detected RPi as build platform"
		echo
		# CC=../tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-gcc
		# CC=../tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/bin/gcc ./configure --build=arm-linux-gnueabihf
		CC=gcc-4.7 ./configure --build=arm-linux-gnueabihf
	else
		./configure
	fi
	echo
	echo "Making and installing arp-scan"
	echo
	make && sudo make install
	echo
	echo "Latest arp-scan installed!"
	echo
	cd ..
}

dependencies()
{
	echo
	# Installing/Updating dependencies
	sudo apt-get update -q
	echo
	sudo apt-get install git autoconf flex bison -q
	echo
}

sourcecode()
{
	# Download the source code, if the condiions are met,
	# and make the programs, and finally install
	if [ -d "libpcap-${LIBPCAP_VERSION}" ]; then
		libpcap "false"
	else
		libpcap "true"
	fi

	if [ -d "arp-scan" ]; then
		arpscan "false"
	else
		arpscan "true"
	fi
}

# MAIN PROGRAM

# PROGRAM MODE
UPDATE=$1
if [ "$#" = 1 ] && [ -d "temp" ]; then
	if [ "$UPDATE" = "update" ] || [ "$UPDATE" = "Update" ]; then
		cd temp
		echo "***UPDATE MODE***"
		echo "Updating dependencies"

		dependencies

		echo
		echo "Updating the source code for programs"
		echo
		libpcap "update"
		arpscan "update"
	fi

elif [ -d "temp" && "$#" = 0 ]; then
	echo "***RE-INSTALLTION MODE***"
	echo "Temporary directory exists"
	echo
	echo "Updating dependencies"
	cd temp

	dependencies

	sourcecode
else
	# Creating a temporary directory
	mkdir temp
	echo "***INSTALLATION MODE***"
	echo
	# Detect if RPi is build platform
	if [ "$(grep -o BCM2708 /proc/cpuinfo)" = "BCM2708" ]; then
		# Installing RPi compatible compiler
		echo "Detected RPi as build platform"
		echo
		rpicompiler "true"
	fi
	cd temp
	echo "Installing dependencies"
	dependencies

	sourcecode
fi

exit