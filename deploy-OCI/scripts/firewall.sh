#!/bin/sh

# Firewall Starging Rules
echo "Chain definition"
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT


if systemctl is-active --quiet docker.service; then
  echo  "Docker chains"
  iptables -N DOCKER-USER
  iptables -N DOCKER-ISOLATION-STAGE-1
  iptables -N DOCKER
  iptables -N DOCKER-ISOLATION-STAGE-2

  # Docker rules
  echo  "Docker rules"
  iptables -A FORWARD -j DOCKER-USER
  iptables -A FORWARD -j DOCKER-ISOLATION-STAGE-1
  iptables -A FORWARD -j DOCKER
  iptables -A FORWARD -j ACCEPT
  iptables -A FORWARD -j DROP
  iptables -A DOCKER-ISOLATION-STAGE-1 -j DOCKER-ISOLATION-STAGE-2
  iptables -A DOCKER-ISOLATION-STAGE-1 -j RETURN
  iptables -A DOCKER-ISOLATION-STAGE-2 -j DROP
  iptables -A DOCKER-ISOLATION-STAGE-2 -j RETURN
  iptables -A DOCKER-USER -j RETURN

  # Docker swarm
  iptables -A INPUT -p tcp --dport 2377 -j ACCEPT
  iptables -A INPUT -p tcp --dport 7946 -j ACCEPT
  iptables -A INPUT -p udp --dport 7946 -j ACCEPT
  iptables -A INPUT -p udp --dport 4789 -j ACCEPT

# Optional: Management docker
#sudo iptables -A INPUT -p tcp --dport 2376 -j ACCEPT
fi
# Wireguard rules
if systemctl is-active --quiet wg-quick@wg0; then
  echo "Wireguard rules"
  iptables -t nat -F
  iptables -t nat -X
  iptables -t mangle -F
  iptables -t mangle -X
  iptables -t nat -A POSTROUTING -o enp0s6 -j MASQUERADE
  iptables -A INPUT -p udp --dport 3389 -j ACCEPT
fi
# Everything only from your admin machine
# echo "Remote admin"
getent hosts <your remote admin machine fqdn>   | cut -d' ' -f1 | xargs iptables -A INPUT -m comment --comment "your remote admin connection"  -j ACCEPT -s
echo "Defaulting down on input"
iptables -A INPUT -j LOG --log-prefix "IPTables-INPUT-Dropped: "
iptables -P INPUT DROP

