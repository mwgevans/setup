#!/bin/bash

#sudo apt-get install udevil
sudo sed -i.bak "/^allowed_media_dirs =/c\allowed_media_dirs = /media, /media/$USER, /run/media/$USER" /etc/udevil/udevil.conf
sudo sed -i '/exfat/s/, nonempty//g' /etc/udevil/udevil.conf
#default_options_exfat     = nosuid, noexec, nodev, noatime, uid=$UID, gid=$GID, iocharset=utf8, namecase=0
#allowed_options
sudo sed -i "/^default_options_exfat\s*=/c\default_options_exfat     = nosuid, noexec, nodev, noatime, fmask=0002, dmask=0002, uid=\$UID, gid=\$GID, iocharset=utf8, namecase=0" /etc/udevil/udevil.conf
sudo sed -i '/^allowed_options/s/fmask=0133/fmask=0002/g' /etc/udevil/udevil.conf
sudo sed -i '/^allowed_options/s/dmask=0022/dmask=0002/g' /etc/udevil/udevil.conf
#mount_point_mode = 0755
sudo sed -i "/^mount_point_mode\s*=/c\mount_point_mode = 0775" /etc/udevil/udevil.conf

id -u devmon &>/dev/null || sudo useradd -g users -M devmon
sudo usermod -L devmon

sudo systemctl enable devmon@devmon
sudo systemctl start devmon@devmon