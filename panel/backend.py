from pprint import pprint

import nmcli

try:
    nmcli.disable_use_sudo()

    for con in nmcli.connection():
        pprint( con )

    for wnet in nmcli.device.wifi():
        pprint( wnet )

#    nmcli.device.wifi_connect('AP1', 'passphrase')
#    nmcli.connection.modify('AP1', {
#            'ipv4.addresses': '192.168.1.1/24',
#            'ipv4.gateway': '192.168.1.255',
#            'ipv4.method': 'manual'
#        })
#    nmcli.connection.down('AP1')
#    nmcli.connection.up('AP1')
#    nmcli.connection.delete('AP1')
except Exception as e:
    print(e)
