#!/bin/bash

[ -n "$DEBUG" ] && [[ $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        set -xe || set -e


TAR_FILE=alpine-rpi-3.19.1-aarch64.tar.gz
ISO_ROOT=/root/iso


if [ ! -e $ISO_ROOT/$TAR_FILE ] ; then
    wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/aarch64/$TAR_FILE \
        -O $ISO_ROOT/$TAR_FILE
elif [ ! -f $ISO_ROOT/$TAR_FILE ] ; then
    echo "Something wrong with a file: $ISO_ROOT/$TAR_FILE"
    exit 1
fi

if [ -d $ISO_ROOT/build ] ; then
    # rm build directory, for fresh start
    rm -rf $ISO_ROOT/build
elif [ -e $ISO_ROOT/build ] ; then
    echo "'$ISO_ROOT/build' should be a directory"
    exit 1
fi

mkdir $ISO_ROOT/build

# unpack
tar -xzvf $ISO_ROOT/$TAR_FILE -C $ISO_ROOT/build


# calculate image size
DU_M=$(du -sm iso/build/ | sed -E 's/^([0-9]{1,5})\s{1,8}.*$/\1/g')
# add size margin
MB_SIZE=$(($DU_M + 16))

# validate if 'MB_SIZE' holds OK data
if [ $MB_SIZE -gt 200 ] && [ $MB_SIZE -lt 20 ] ; then
    echo "Too large size ..."
    exit 1
fi

# create image, and partition table
dd if=/dev/zero of=$ISO_ROOT/image.iso bs=1048576 count=$MB_SIZE

fdisk $ISO_ROOT/image.iso <<EOF
n
p
1
8192

t
c
w
EOF

losetup -o ... /dev/loop0 image.iso
# mount
#dd if=/dev/zero of=$ISO_ROOT/image.iso1 bs=512 count=194560
#mkfs.vfat image.iso1


# add: 
/boot/usercfg.txt <<
dtparam=i2c_arm=on
dtoverlay=i2c-rtc,param=pcf8563
EOF

exit 0
