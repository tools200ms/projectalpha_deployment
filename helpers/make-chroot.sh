#!/bin/bash

[ -n "$PRETEND" ] && [[ $(echo "$PRETEND" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        RUN="echo" || RUN=

[ -n "$DEBUG" ] && [[ $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        set -xe || set -e

# Based on: https://wiki.alpinelinux.org/wiki/Alpine_Linux_in_a_chroot

mirror="http://alpine.sakamoto.pl/alpine"

build_dir="chroot.armhf chroot.aarch64"

function deploy() {
  ch_root="$1"
  arch=$2

  if [ -z $RUN ]; then
    temp_dir=$(mktemp -d)
  else
    temp_dir=$(mktemp -du)
  fi

  branch=$(curl -s ${mirror}/ | sed -n 's/.*href="\(.*\)".*/\1/p' | grep -e "v[0-9]\.[0-9][0-9]" | sort -V | tail -n 1)
  branch=$(basename ${branch})

  apk_tools_url=$(curl -s ${mirror}/${branch}/main/${arch}/ | \
                  sed -n 's/.*href="\(.*\)".*/\1/p' | grep -e "apk-tools-static-.*.apk")
  apk_tools_url=$(basename "$apk_tools_url")

  $RUN curl -sL ${mirror}/${branch}/main/${arch}/${apk_tools_url} \
            -o ${temp_dir}/apk-tools-static.apk
  $RUN tar -xzf ${temp_dir}/apk-tools-static.apk -C $ch_root
  $RUN rm $temp_dir/apk-tools-static.apk
  $RUN rmdir $temp_dir

  $RUN ./${ch_root}/sbin/apk.static -X ${mirror}/${branch}/main -U --allow-untrusted -p ${ch_root} --initdb add alpine-base

  # Basic configuration
  if [ -z $RUN ]; then
    echo -e 'nameserver 8.8.8.8\nnameserver 2620:0:ccc::2' > ${ch_root}/etc/resolv.conf
    mkdir -p ${ch_root}/etc/apk
    echo "${mirror}/${branch}/main" > ${ch_root}/etc/apk/repositories
    echo "${mirror}/${branch}/community" >> ${ch_root}/etc/apk/repositories
  else
    echo "Pretending that working hard on a basic system configuration ..."
    sleep 1 # o-<-<
  fi
}

function bind_with_host() {
  ch_root="$1"

  mount -o bind /dev ${ch_root}/dev
  mount -t proc none ${ch_root}/proc
  mount -o bind /sys ${ch_root}/sys
}

for b_dir in ${build_dir}; do
  arch=$(echo $b_dir | cut -d'.' -f2)
  deploy $b_dir $arch
done

exit 0



# chroot
chroot ${chroot_dir} /bin/ash -l
rc-update add devfs sysinit
rc-update add dmesg sysinit
rc-update add mdev sysinit

rc-update add hwclock boot
rc-update add modules boot
rc-update add sysctl boot
rc-update add hostname boot
rc-update add bootmisc boot
rc-update add syslog boot

rc-update add mount-ro shutdown
rc-update add killprocs shutdown
rc-update add savecache shutdown


exit 0
