FROM ubuntu:17.04

# Base packages
RUN apt-get update -qq -y && apt-get install -y net-tools nmap curl tzdata ruby ppp iptables ca-certificates update-ca-certificates

# Timezone
RUN echo 'America/Chicago' | tee /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Setup ppp device
RUN mknod /dev/ppp c 108 0

# Setup dir and client
RUN mkdir /vpntools
ADD ./tools/vpn.tgz /vpntools
ADD ./tools/watcher.rb /vpntools
WORKDIR /vpntools
RUN ./Install.sh

# Init and loop
CMD ./watcher.rb
