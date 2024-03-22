FROM ubuntu:latest

# Base packages
RUN apt-get update -qq -y
RUN apt-get install -y net-tools nmap tzdata iptables rsyslog ca-certificates vim openconnect nginx
# update-ca-certificates

# Timezone
RUN echo 'America/Chicago' | tee /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Setup dir and client
RUN mkdir /vpntools
ADD ./tools/nginx.conf.sample /etc/nginx/nginx.conf
ADD ./tools/start_vpn.sh /vpntools
RUN chmod +x /vpntools/start_vpn.sh
WORKDIR /vpntools

# Init and loop
CMD ./start_vpn.sh
