#!/bin/sh

[ -n "$PRETEND" ] && [[ $(echo "$PRETEND" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        RUN="echo" || RUN=

[ -n "$DEBUG" ] && [[ $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        set -xe || set -e


AW_RUN="./alpha-wrap/alpha-wrap-run"

BUILD_DATE=$(date +%m-%Y_d%d%H%M)

IMAGE=images/alpbase-just_light-${BUILD_DATE}.iso

echo "Creating Just Light Edition"

${AW_RUN} extstore add ${IMAGE} 500MB
${AW_RUN} command "/bin/ash -l -c 'chroot_master.sh exec chroot.aarch64 alpbase_builder.sh jl /dev/sda'"

# test

# ${AW_RUN} --device raspi3b ${IMAGE} --imgboot y vmlinuz-rpi initramfs-rpi

gzip ${IMAGE}

exit 0
