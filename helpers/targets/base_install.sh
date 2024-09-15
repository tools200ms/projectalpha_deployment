#!/bin/bash
# Based on: https://wiki.alpinelinux.org/wiki/Alpine_Linux_in_a_chroot

[ -n "$PRETEND" ] && [[ $(echo "$PRETEND" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        RUN="echo" || RUN=

[ -n "$DEBUG" ] && [[ $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        set -xe || set -e


if [ $(id -u) -ne 0 ]; then
  echo "Run it as root!"
  exit 0
fi

# ensure tailing '/' is always here ending 'stat -c %i /proc/1/root/'
# '/proc/1/root' points to a symbolic link that is not what we check,
# we check inode of the directory that symbolic link is pointing to.
if [ $(stat -c %i /) -eq $(stat -c %i /proc/1/root/) ]; then
  echo "We are not in chrooted environment, nothing to do."
  exit 0
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

DEVICE=/dev/sda
# super light config
UDEV=mdev

# just light config
UDEV=mdevd

## standard config
#UDEV=udevd


setup-disk $DEVICE <<EOF
sys
y
EOF

# at boot time
setup-devd <<EOF
$UDEV
EOF

sync

exit 0

setup-hostname EOF<<
EOF

setup-user EOF<<
EOF

# /sbin/setup-acf # mini web server

/sbin/setup-apkcache
/sbin/setup-apkrepos


/sbin/setup-desktop

/sbin/setup-interfaces
/sbin/setup-dns

/sbin/setup-lbu
/sbin/setup-mta
/sbin/setup-ntp
/sbin/setup-proxy
/sbin/setup-sshd

# at first login:
setup-keymap
setup-timezone
/sbin/setup-hostname

/sbin/setup-wayland-base


echo "Installation done."

exit 0
