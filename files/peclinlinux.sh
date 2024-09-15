#!/bin/sh

DEVICE=/dev/sda
CHROOT=/mnt/dist

#blkdiscard $DEVICE
#dd if=/dev/zero of=$DEVICE bs=4k


mkdir -p $CHROOT
mount ${DEVICE}2 $CHROOT

mount -o bind /dev $CHROOT/dev
mount -t proc none $CHROOT/proc
mount -o bind /sys $CHROOT/sys

chroot $CHROOT /bin/ash -l -c "/install"
# in chroot
setup-keymap EOF<<
us
us-intl
EOF

setup-timezone EOF<<
Europe/Warsaw
EOF

setup-hostname EOF<<
miniadmin
EOF

setup-user EOF<<
admin





EOF

# at boot time
setup-devd EOF<<
mdevd
EOF

setup-ntp EOF<<
busybox
EOF

exit

# end of chroot operations
umount $CHROOT
sync


setup-alpine $DEVICE EOF<<
miniadmin
eth1
Europe/Warsaw
EOF


