

# create 'service' connection for Ethernet
nmcli con add type ethernet con-name service-link ifname eth0
nmcli connection modify service-link ipv4.method link-local
