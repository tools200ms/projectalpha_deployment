#~/bin/bash

TAR_FILE=alpine-rpi-3.19.1-aarch64.tar.gz

mkdir -p iso/build

wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/aarch64/$TAR_FILE \
    -O ./iso/$TAR_FILE

tar -xzvf ./iso/$TAR_FILE -C ./iso/build/



DU_M=$(du -sm iso/build/ | sed -E 's/^([0-9]{1,5})\s{1,8}.*$/\1/g')

MB_SIZE=$(($DU_M + 16))

if [ $MB_SIZE -gt 200 ] && [ $MB_SIZE -lt 20 ] ; then
    echo "Too large size ..."
    exit 1
fi

dd if=/dev/zero of=./iso/image.iso bs=1048576 count=$MB_SIZE

fdisk ./iso/image.iso <<EOF
n
p
1
8192

t
c
w
EOF

exit 0
