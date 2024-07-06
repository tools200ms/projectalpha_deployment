#!/bin/ash

cp ... /etc/network/interfaces

service networking start
service ntpd start

apk add openssh-server wpa_supplicant

adduser admin

service sshd start


setup-alpine


apk add e2fsprogs-extra f2fs-tools

e2fsck -f /dev/mmcblk0p2
resize2fs /dev/mmcblk0p2 5G

fdisk /dev/mmcblk0
d
2
n
p
2
616448
+6G

# add swap

fdisk /dev/mmcblk0
n
p
3
13199360
+8G
mkfs.f2fs /dev/mmcblk0p3

