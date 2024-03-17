#!/bin/bash
# A bash script to update a Cloudflare DNS A record with the external IP of the source machine
# Used to provide DDNS service for my home
# Needs the DNS record pre-created on Cloudflare
# Variables are deffined on a file named .secrets with following syntax:
#
#zone=
#cloudflare_auth_email=
#cloudflare_auth_key=
#notify_address=
#
# Cloudflare DNS record is provided has parameter, ex:
# update-cloudflare-record.sh my-machine.my-domain.com

# Proxy - uncomment and provide details if using a proxy
# export https_proxy=http://<proxyuser>:<proxypassword>@<proxyip>:<proxyport>

# Read variables from .secrets file
source $(dirname "$0")/.secrets

# dnsrecord is the A record which will be updated (passed as a parameter)
dnsrecord=$1

# Get the current external IP address
ip=$(curl -s -X GET https://checkip.amazonaws.com)

echo "Current IP is $ip"

if host $dnsrecord 1.1.1.1 | grep "has address" | grep "$ip"; then
  echo "$dnsrecord DNS record IP matches current host address, no changes needed"
  exit
fi

# if here, the dns record needs updating

# get the zone id for the requested zone
zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
  -H "X-Auth-Email: $cloudflare_auth_email" \
  -H "X-Auth-Key: $cloudflare_auth_key" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "Zoneid for $zone is $zoneid"

# get the dns record id
dnsrecordid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=A&name=$dnsrecord" \
  -H "X-Auth-Email: $cloudflare_auth_email" \
  -H "X-Auth-Key: $cloudflare_auth_key" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "DNSrecordid for $dnsrecord is $dnsrecordid"

# update the record
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid" \
  -H "X-Auth-Email: $cloudflare_auth_email" \
  -H "X-Auth-Key: $cloudflare_auth_key" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$ip\",\"ttl\":1,\"proxied\":false}" | jq

echo "New IP: ${ip}. DNS has been updated" | mail -s "Ip on ${hostname} has changed" $notify_address