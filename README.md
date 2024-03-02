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

apk add networkmanager wpa_supplicant networkmanager-wifi networkmanager-cli networkmanager-tui

rc-update del networking boot
rc-update add networkmanager

adduser master plugdev

mkdir -p /etc/NetworkManager/conf.d
cat /etc/NetworkManager/conf.d/any-user.conf <<
[main]
auth-polkit=false
EOF

# update NetworkManager.conf

rc-service networkmanager start
rc-service wpa_supplicant start

# setup firewall
apk add nftables jq python3

