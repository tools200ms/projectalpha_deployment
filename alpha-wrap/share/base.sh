#!/bin/bash
# Based on: https://wiki.alpinelinux.org/wiki/Alpine_Linux_in_a_chroot

[ -n "$PRETEND" ] && [[ $(echo "$PRETEND" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        RUN="echo" || RUN=

[ -n "$DEBUG" ] && [[ $(echo "$DEBUG" | tr '[:upper:]' '[:lower:]') =~ ^y|yes|1|on$ ]] && \
        set -xe || set -e

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

  if [ -n "$RUN" ]; then
    echo "PRETEND mode, skipping binding of a special directories."
    return
  fi

  mnt_path=$(realpath ${ch_root}/dev)
  if [ $(mount | grep "$mnt_path" | wc -l) -eq 0 ]; then
    $RUN mount -o bind /dev ${mnt_path}
  fi

  mnt_path=$(realpath ${ch_root}/proc)
  if [ $(mount | grep "$mnt_path" | wc -l) -eq 0 ]; then
    $RUN mount -t proc none ${mnt_path}
  fi

  mnt_path=$(realpath ${ch_root}/sys)
  if [ $(mount | grep "$mnt_path" | wc -l) -eq 0 ]; then
    $RUN mount -o bind /sys ${mnt_path}
  fi
}

function make_base() {
  targets_dir=$(realpath ./targets)

  # delpoy chrooted environment, and bind special file systems:
  for b_dir in ${build_dir}; do
    arch=$(echo $b_dir | cut -d'.' -f2)

    # if exists assume chrooted environment is stetup
    if [ ! -f "${b_dir}/etc/alpine-release" ]; then
      mkdir -p $b_dir
      deploy $b_dir $arch
    fi

    bind_with_host $b_dir

    if [ -n "$RUN" ]; then
      echo "PRETEND mode, skipping binding of a target directory."
      continue
    fi

    if [ $(mount | grep "$targets_dir" | wc -l) -eq 0 ]; then
      mount --bind $targets_dir ${b_dir}/usr/local/bin/
    fi
  done


  # perform image preparation:
  for b_dir in ${build_dir}; do
    arch=$(echo $b_dir | cut -d'.' -f2)

    chroot $b_dir base_preinstall.sh $arch
    # chroot, install and configure necessary stuf
    #$RUN chroot ${chroot_dir} /usr/local/bin/base_install.sh $arch

  # unbind
  done
}

case $1 in
  make)
    make_base
  ;;

  enter)
    chroot $2 /bin/ash -l
  ;;

  build)

  ;;

  unbind)

  ;;

  purge)

  ;;

  help|-h|--help)

  ;;
esac

exit 0
