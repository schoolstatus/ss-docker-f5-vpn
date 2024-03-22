#!/bin/sh

# setup nginx config
sed -i "s/{{ vpn_remote_ip }}/$VPN_REMOTE_IP/" /etc/nginx/nginx.conf
sed -i "s/{{ vpn_remote_port }}/$VPN_REMOTE_PORT/" /etc/nginx/nginx.conf

# ensure nginx is stopped/started (`service nginx restart` can be wonky
service nginx stop
service nginx start

# login to vpn
echo $VPN_PASS | openconnect --protocol=f5 $VPN_SERVER -u $VPN_USER --passwd-on-stdin
