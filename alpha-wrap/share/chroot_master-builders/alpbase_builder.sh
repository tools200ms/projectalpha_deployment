#!/bin/bash
# Based on: https://wiki.alpinelinux.org/wiki/Alpine_Linux_in_a_chroot

[ -n "$PRETEND" ] && [[ $(echo "$PRETEND" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        RUN="echo" || RUN=

[ -n "$DEBUG" ] && [[ $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        set -xe || set -e


function print_help() {
  local indent_cnt=$(basename $0 | wc -c)
  local indent_p1=$(printf "%*s" "$indent_cnt" "")

  cat <<EOF
Usage:
$(basename $0) super_light | sl    <device>
${indent_p1}just_light  | jl    <device>
${indent_p1}be_desktop  | bd    <device>

  AlpBase edition for installation: Super Light, Just Light, BeDesktop
  <device> - block device for installation of a selected edition

$(basename $0) help
  Print this help and exit.

EOF
}

function require_root() {
  if [ -z $RUN ] && [ $(id -u) -ne 0 ]; then
    echo "Run it as root!"
    exit 0
  fi
}

# ensure tailing '/' is always here ending 'stat -c %i /proc/1/root/'
# '/proc/1/root' points to a symbolic link that is not what we check,
# we check inode of the directory that symbolic link is pointing to.
function require_chroot() {
  if [ -z $RUN ] && [ $(stat -c %i /) -eq $(stat -c %i /proc/1/root/) ]; then
    echo "We are not in chroot environment, nothing to do."
    exit 0
  fi
}

RES_DIR=$(dirname $0)/files

MODE=$1
BDEV=$2

if [[ "$MODE" == "-h" || "$MODE" == "--help" || "$MODE" == "help" ]]; then
    print_help
    exit 0
fi

require_root && require_chroot

# calidate parameters:
case $MODE in
  super_light|sl)
    EDITION=super_light
  ;;
  just_light|jl)
    EDITION=just_light
  ;;
  be_desktop|bd)
    EDITION=be_desktop
  ;;
  [a-zA-Z0-9_-]*)
    echo "Unknown edition: $MODE"
    exit 1
  ;;
  *)
    echo "Incorrect syntax, --help, for help"
    exit 2
  ;;
esac

if [ -z "${BDEV}" ] || [ ! -b "${BDEV}" ]; then
  echo "Provide block device"
  exit 3
fi

# set settings specific for setup:
case $EDITION in
  super_light)
    # for one CPU core
    DEVD=mdev

  ;;
  just_light)
    # multiple CPU cores:
    DEVD=mdevd
  ;;
  be_desktop)
    # fancy features
    DEVD=udevd
  ;;
  *)
    echo "This should not happen"
    exit 222
esac

echo "Installing: $EDITION edition"
echo ""

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


$RUN setup-disk $DEVICE <<EOF
sys
y
EOF


# at boot time
$RUN setup-devd <<EOF
$DEVD
EOF

$RUN mount
$RUN cp $RES_DIR/setup ...

$RUN sync

echo "Installation done."

exit 0

setup-hostname <<EOF
name
EOF

setup-user <<EOF
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


exit 0
