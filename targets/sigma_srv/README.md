

# create 'service' connection for Ethernet
> nmcli con add type ethernet con-name service-link ifname eth0
> nmcli connection modify service-link ipv4.method link-local

> nmcli con add type ethernet con-name service-static ifname eth0 ipv4.addresses 192.168.0.10/24

> nmcli con up id service-static

Make connection default: 
Higher priority, higher precedence (100 - first, 99 - secound)
> nmcli connection modify service-static connection.autoconnect-priority 100
> nmcli connection modify service-static connection.autoconnect yes

> ip addr add 192.168.0.1/24 dev enp0s20f0u5
