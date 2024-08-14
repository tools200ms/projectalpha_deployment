# projectalpha_deployment

## USB Ethernet Gadget

```bash
# /boot/firmware/config.txt

dtoverlay=dwc2

enable_uart=1
```

# setup basic system: 
## update /etc/apk/repositories
apk update
apk upgrade

apk add bash nano ncurses-terminfo

# conf. RTC
https://raspberrypi.stackexchange.com/questions/90315/how-can-i-get-dev-i2c-devices-to-appear-on-alpine-linux
https://wiki.alpinelinux.org/wiki/Saving_time_with_Hardware_Clock

apk add i2c-tools
echo 'i2c-dev' > /etc/modules-load.d/0_i2c.conf
echo 'i2c-bcm2708' >> /etc/modules-load.d/0_i2c.conf
echo 'rtc-pcf8563' > /etc/modules-load.d/1_rtc.conf

echo pcf8563 0x51 > /sys/class/i2c-adapter/i2c-1/new_device

hwclock: ioctl 0x80247009 failed: Invalid argument
dmesg | grep -i rtc
[  200.295670] rtc-pcf8563 1-0051: low voltage detected, date/time is not reliable.
[  200.296039] rtc-pcf8563 1-0051: registered as rtc0
[  200.297601] rtc-pcf8563 1-0051: low voltage detected, date/time is not reliable.
[  200.297621] rtc-pcf8563 1-0051: hctosys: unable to read the hardware clock
[  203.581514] rtc-pcf8563 1-0051: low voltage detected, date/time is not reliable.

# setuo NetworkManager

# setup udev (mdev not sufficient): 
setup-devd udev

apk add dnsmasq networkmanager wpa_supplicant networkmanager-wifi networkmanager-cli 

# text based network manager: nmtui
networkmanager-tui

## Netbooting: 
```
sudo wget -O /var/tftpboot/undionly.kpxe https://boot.netboot.xyz/ipxe/netboot.xyz-undionly.kpxe
sudo wget -O /var/tftpboot/ipxe.efi https://boot.netboot.xyz/ipxe/netboot.xyz.efi

apk add tftp-hpa

in.tftpd start

enable: /etc/dnsmasq.conf
conf-dir=/etc/dnsmasq.d

chown dnsmasq:dnsmasq ipxe.efi undionly.kpxe

```


rc-update del networking boot
rc-update add networkmanager

adduser master plugdev

# update NetworkManager.conf

mkdir -p /etc/NetworkManager/conf.d
cat /etc/NetworkManager/conf.d/any-user.conf <<
[main]
auth-polkit=false
EOF


echo "nameserver 1.1.1.1" > /etc/resolv-cf.conf
echo "resolv-file=/etc/resolv-cf.conf" > /etc/NetworkManager/dnsmasq-shared.d/cloudflare.conf


rc-service wpa_supplicant start
rc-service networkmanager start


# setup firewall
apk add nftables jq python3


# setup networking

# rfkill don't run on startup,
# while nmcli does not seem to
# have option to switch off
# bluetooth
# checkout bluetooth rf killing
# methods
rfkill block bluetooth


# check on/off status
nmcli radio

# scann WI-FI networks
```
# scann for networks:
nmcli dev wifi

# connect: 
nmcli dev wifi connect <wifi name> password <pass>
```

# WireGuard connection

apt-get install curl jq openresolv wireguard

https://raw.githubusercontent.com/mullvad/mullvad-wg.sh/main/mullvad-wg.sh


nmcli connection import type wireguard file /path/to/wg0.conf
nmcli connection up wg0

nmcli con add type ethernet ifname usb0 con-name router ipv4.method shared
nmcli connection modify router ipv6.method ignore
nmcli connection up router

https://mullvad.net/en/help/wireguard-and-mullvad-vpn

```ini

[Interface]
PrivateKey = 
ListenPort = 51820

# Pick peers from: 
# https://mullvad.net/en/servers

[Peer]
# pl-waw-wg-103 
PublicKey = 07eUtSNhiJ9dQXBmUqFODj0OqhmbKQGbRikIq9f90jM=
Endpoint = 45.134.212.92:51820
AllowedIPs = 0.0.0.0/0


```

# if dhcp ip range is the same at two interfaces,
# remove doubled default gateway
route del -net 0.0.0.0 gw 10.0.0.1 netmask 0.0.0.0 dev eth0
route del -net 10.0.0.0 gw 0.0.0.0 netmask 255.255.0.0 dev eth0

# add shared connection
nmcli connection add con-name shared type ethernet ifname eth0 ipv4.method shared ipv6.method ignore
# set cloudflare DNS
# nmcli con mod abracadabra ipv4.dns "1.1.1.1"


