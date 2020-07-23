#!/bin/sh
ping -c1 10.0.0.6 >> /dev/null
if [ $? -eq 0 ]
    then
        sleep 5
        echo "waiting"
    else
        cd /etc/openvpn && /usr/sbin/openvpn --config client.conf
        echo "Ping Fail"
        #sleep 2
fi
