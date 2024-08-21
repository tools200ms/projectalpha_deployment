#!/bin/sh

apt-get install stubby
systemctl enable stubby



systemctl start stubby

exit 0
