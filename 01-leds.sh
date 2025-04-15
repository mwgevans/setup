#!/bin/bash
OUTFILE='/boot/firmware/config.txt'
sudo tee -a "$OUTFILE" > /dev/null <<-'EOF'
dtparam=pwr_led_trigger=default-on
dtparam=pwr_led_activelow=off
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off
dtparam=eth_led0=4
dtparam=eth_led1=4
EOF