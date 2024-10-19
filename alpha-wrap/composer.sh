#!/bin/sh

[ -n "$PRETEND" ] && [[ $(echo "$PRETEND" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        RUN="echo" || RUN=

if [ -n "$DEBUG" ] && [[ $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]]; then
  set -xe
  CHROOTM_EXEC="DEBUG=Y chroot_master.sh"
else
  set -e
  CHROOTM_EXEC="chroot_master.sh"
fi

AW_RUN="./alpha-wrap/alpha-wrap-run"


echo "Creating Just Light Edition"
BUILD_DATE=$(date +%m-%Y_d%d%H%M)
IMAGE=images/alpbase-just_light-${BUILD_DATE}.iso

${AW_RUN} extstore add ${IMAGE} 500MB
${AW_RUN} command "/bin/ash -l -c '${CHROOTM_EXEC} exec chroot.aarch64 alpbase_builder.sh jl /dev/sda'"

# test

# ${AW_RUN} --device raspi3b ${IMAGE} --imgboot y vmlinuz-rpi initramfs-rpi
gzip ${IMAGE}

echo "Creating BeDesktop Edition"

BUILD_DATE=$(date +%m-%Y_d%d%H%M)
IMAGE=images/alpbase-bedesktop-${BUILD_DATE}.iso

${AW_RUN} extstore add ${IMAGE} 700MB
${AW_RUN} command "/bin/ash -l -c '${CHROOTM_EXEC} exec chroot.aarch64 alpbase_builder.sh bd /dev/sdb'"

# test

gzip ${IMAGE}

exit 0
