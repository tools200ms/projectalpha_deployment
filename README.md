# projectalpha_deployment

# setup basic system: 
## update /etc/apk/repositories
apk update
apk upgrade

apk add bash nano ncurses-terminfo

# conf. RTC
https://raspberrypi.stackexchange.com/questions/90315/how-can-i-get-dev-i2c-devices-to-appear-on-alpine-linux

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

apk add dnsmasq networkmanager wpa_supplicant networkmanager-wifi networkmanager-cli networkmanager-tui

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
nmcli dev wifi

nmcli dev wifi connect abracadabra password

# if dhcp ip range is the same at two interfaces,
# remove doubled default gateway
route del -net 0.0.0.0 gw 10.0.0.1 netmask 0.0.0.0 dev eth0
route del -net 10.0.0.0 gw 0.0.0.0 netmask 255.255.0.0 dev eth0

# add shared connection
nmcli connection add con-name shared type ethernet ifname eth0 ipv4.method shared ipv6.method ignore
# set cloudflare DNS
# nmcli con mod abracadabra ipv4.dns "1.1.1.1"


