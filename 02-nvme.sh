#!/bin/bash
# 2 Support NVME
match='# Uncomment some or all of these to enable the optional hardware interfaces'
insert='dtparam=pciex1_gen=3'
file='/boot/firmware/config.txt'

sudo sed -i.bak "s/$match/$match\n$insert/" $file

# 3 Mount NVME

sudo parted --script /dev/nvme0n1 \
mklabel gpt \
mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L data /dev/nvme0n1p1

file='/etc/fstab'
insert=$'$a\\\n/dev/nvme0n1p1  /data  ext4  defaults  0  0' 
[ -d /data ] || sudo mkdir /data
sudo sed -i.bak -e "$insert" $file 
if ! sudo mount -a
then
    echo 'fstab edit failed .. '
    echo 'reverting'
    sudo rm /etc/fstab
    sudo mv /etc/fstab.bak /etc/fstab
else 
    sudo systemctl daemon-reload
fi