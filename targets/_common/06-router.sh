#!/bin/sh

INT_MANAGED_BY_NM=0

INT_IF=usb0
EXT_IF=wlan0

INT_ADDR=

# If mimiminiadmin (one client over USB) use 31 bit network mask (RFC 3021) for 'usb0'
INT_ADDR=192.168.17.17/31
# else
# INT_ADDR=192.168.99.0/24

# setup internal connection
if [ $INT_MANAGED_BY_NM -ne 0 ]; then
  nmcli con add type ethernet con-name int_con ifname $INT_IF ipv4.addresses $INT_ADDR
  nmcli con modify int_con connection.autoconnect yes
  nmcli con modify int_con ipv4.method manual
  nmcli con modify int_con ipv4.gateway ""
  nmcli con modify int_con ipv4.dns ""
  nmcli con modify int_con ipv6.method ignore

  nmcli con up int_con
else
  nmcli device set $INT_IF managed no
  # We don't want NM to be in conflict with networking,
  # but $INT_IF is managed outside of NM, remove eny 'daefault'
  # networking configuration and drop what is not in conflict
  rm -rf /etc/network/*
  mkdir if-pre-up.d/
  if-up.d/
  cat /etc/network/interfaces.d/int_con.conf <<
auto usb0
allow-hotplug usb0

iface usb0 inet static
  address $INT_ADDR
EOF
  # enable 'networking' service
  # start (to bring interface up)
fi


# Setup dnsmasq
# We don't use NM in "spot" mode as we want to have control over firewall
# while NM does alter firewall to handle 'spot' working (forwarding rules)

/etc/dnsmasq.d/dhcp.conf
# NetworkManager

exit 0
