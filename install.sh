#!/bin/bash

# Default attributes
WORKSPACE=~/.lense_devtools/install

# Must be root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Make sure the install directory is free
if [ -d ${WORKSPACE} ] && [ $(ls -A ${WORKSPACE}) ]; then
	echo "ERROR: Workspace directory <${WORKSPACE}> already exists"
	echo "INFO: Change the WORKSPACE variable or clear the directory"
	exit 1
fi
mkdir -p $WORKSPACE

# Get build packages
apt-get update
apt-get install build-essential devscripts git
	
# Github Python bindings
apt-get install python-pip
pip install GitPython

# Get the soource code
cd $WORKSPACE
git clone https://github.com/djtaylor/lense-devtools.git
cd lense_devtools

# Tar the source directory
tar czf lense-devtools_0.1.1.orig.tar.gz lense-devtools
cd lense-devtools

# Build the package without signing
debuild -uc -us

# Install the package
cd ..
dpkg -i lense-devtools_0.1.1-dev0_all.deb
which lense-devtools