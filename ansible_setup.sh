#!/bin/sh

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

if [ -f "/etc/debian_version" ]; then
   apt-get install -y python
fi

if [ -f "/etc/redhat_release" ]; then
   yum install -y python
fi

