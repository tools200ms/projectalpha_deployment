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


${AW_RUN} waitfor

# Build Editions:

echo "Creating Super Light Edition"
BUILD_DATE=$(date +%m-%Y_d%d%H%M)
IMAGE=images/alpbase-super_light-${BUILD_DATE}.iso

${AW_RUN} extstore add ${IMAGE} 450MB
${AW_RUN} command "/bin/ash -l -c '${CHROOTM_EXEC} exec chroot.armhf alpbase_builder.sh sl /dev/sda'"

# test

# ${AW_RUN} --device raspi3b ${IMAGE} --imgboot y vmlinuz-rpi initramfs-rpi
gzip -c ${IMAGE} > ${IMAGE}.gz
bzip2 -c ${IMAGE} > ${IMAGE}.bz2
xz -c ${IMAGE} > ${IMAGE}.xz


echo "Creating Just Light Edition"
BUILD_DATE=$(date +%m-%Y_d%d%H%M)
IMAGE=images/alpbase-just_light-${BUILD_DATE}.iso

${AW_RUN} extstore add ${IMAGE} 500MB
${AW_RUN} command "/bin/ash -l -c '${CHROOTM_EXEC} exec chroot.aarch64 alpbase_builder.sh jl /dev/sdb'"

# test

# ${AW_RUN} --device raspi3b ${IMAGE} --imgboot y vmlinuz-rpi initramfs-rpi
gzip -c ${IMAGE} > ${IMAGE}.gz
bzip2 -c ${IMAGE} > ${IMAGE}.bz2
xz -c ${IMAGE} > ${IMAGE}.xz

echo "Creating BeDesktop Edition"

BUILD_DATE=$(date +%m-%Y_d%d%H%M)
IMAGE=images/alpbase-bedesktop-${BUILD_DATE}.iso

${AW_RUN} extstore add ${IMAGE} 5200MB
${AW_RUN} command "/bin/ash -l -c '${CHROOTM_EXEC} exec chroot.aarch64 alpbase_builder.sh bd /dev/sdc'"

# test

gzip -c ${IMAGE} > ${IMAGE}.gz
bzip2 -c ${IMAGE} > ${IMAGE}.bz2
xz -c ${IMAGE} > ${IMAGE}.xz


${AW_RUN} stop

exit 0
