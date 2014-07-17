#!/bin/bash

# VMWare tools

yum -y install --setopt=tsflags=nodocs gcc make kernel-devel

# Installing the virtualbox guest additions
TOOLS_ISO=/root/vmware-tools.iso
cd /tmp
mkdir vmware-tools
mount -o loop $TOOLS_ISO vmware-tools
tar zxf /tmp/vmware-tools/VMwareTools*.tar.gz
umount vmware-tools
rm $TOOLS_ISO

cd /tmp/vmware-tools-distrib
./vmware-install.pl --default