#!/bin/ash
# Based on: https://wiki.alpinelinux.org/wiki/Alpine_Linux_in_a_chroot

if [ "$(readlink /proc/1/root)" != "/" ]; then
  echo "Script is in a chrooted environment"
else
  echo "Script is not in a chrooted environment"
fi

#rc-update add devfs sysinit
#rc-update add dmesg sysinit
#rc-update add mdev sysinit

#rc-update add hwclock boot
#rc-update add modules boot
#rc-update add sysctl boot
#rc-update add hostname boot
#rc-update add bootmisc boot
#rc-update add syslog boot

#rc-update add mount-ro shutdown
#rc-update add killprocs shutdown
#rc-update add savecache shutdown

echo "Installation done."

exit 0
