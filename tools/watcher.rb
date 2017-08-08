#!/usr/bin/env ruby

REMOTE_IP   = ENV['VPN_REMOTE_IP']
REMOTE_PORT = ENV['VPN_REMOTE_PORT']
VPN_SERVER  = ENV['VPN_SERVER']
VPN_USER    = ENV['VPN_USER']
VPN_PASS    = ENV['VPN_PASS']
F5_CLIENT   = '/usr/local/bin/f5fpc'

DEAD_THRESHOLD = 15
IDLE_TIME      = 15

def port_check
  `#{F5_CLIENT} -i | grep 'Tunnel Port'`
end

def setup_nat
  system "iptables -t nat -A PREROUTING -i eth0 -p tcp --dport #{REMOTE_PORT} -j DNAT --to #{REMOTE_IP}:#{REMOTE_PORT}"
  system "iptables -t nat -A POSTROUTING -p tcp -d #{REMOTE_IP} --dport #{REMOTE_PORT} -j MASQUERADE"
end

def connect_client
  system "#{F5_CLIENT} --nocheck --start -t #{VPN_SERVER} -u #{VPN_USER} -p #{VPN_PASS}"
end

def add_route
  system "route add -host #{REMOTE_IP} dev tun0"
end

def init_connection
  setup_nat
  connect_client
  add_route

  puts 'setup... sleeping before monitor.'
  sleep IDLE_TIME
end

def monitor
  failures = 0

  loop {
    if port_check.empty?
      failures += 1
    else
      failures = 0
    end

    if failures > DEAD_THRESHOLD
      exit(-1)
    else
      sleep IDLE_TIME
    end
  }
end

init_connection
monitor
