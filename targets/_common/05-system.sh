#!/bin/sh

# Replace default login message with with the one
# that says about current setup
rc-update add info-gen boot

rm /etc/motd
ln -s /tmp/.info /etc/motd

apt install dnsmasq
