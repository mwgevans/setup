#!/bin/bash

setup_reboot(){
OUTFILE=/etc/systemd/system/enablenvme.service
sudo tee "$OUTFILE" > /dev/null <<'EOF'
[Unit]
Description=Check Disk Space on /home directory at Startup
Requires=local-fs.target
After=local-fs.target

[Service]
ExecStart=/usr/local/bin/enablenvme.sh

[Install]
WantedBy=multi-user.target
EOF
SCRIPT_PATH="${BASH_SOURCE}"
sudo ln -s $SCRIPT_PATH /usr/local/bin/enablenvme.sh
sudo chmod 744 $SCRIPT_PATH
sudo chmod 664 /etc/systemd/system/enablenvme.service
sudo systemctl daemon-reload
sudo systemctl enable enablenvme
}

before_reboot(){
    # Do stuff
    match='# Uncomment some or all of these to enable the optional hardware interfaces'
    insert='dtparam=pciex1_gen=3'
    file='/boot/firmware/config.txt'

    sudo sed -i.bak "s/$match/$match\n$insert/" $file
}

after_reboot(){
    # Do stuff
    sudo parted --script /dev/nvme0n1 \
    mklabel gpt \
    mkpart primary ext4 0% 100%
    sudo mkfs.ext4 -L data /dev/nvme0n1p1 -F

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
    sudo touch /var/run/flag
}

if [ -f /var/run/rebooting-for-updates ]; then
    after_reboot
    sudo rm /var/run/rebooting-for-updates
    systemctl disable enablenvme
else
    setup_reboot
    before_reboot
    sudo touch /var/run/rebooting-for-updates
    sudo reboot
fi



# 2 Support NVME


# 3 Mount NVME

