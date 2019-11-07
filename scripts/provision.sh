#!/usr/bin/env bash

# Specify the product you would like to install
P=consul

# Installing the latest version of the specified product
VERSION=$(curl -sL https://releases.hashicorp.com/${P}/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)
    
# Determine your arch
if [[ "`uname -m`" =~ "arm" ]]; then
  ARCH=arm
else
  ARCH=amd64
fi

wget -q -O /tmp/${P}.zip https://releases.hashicorp.com/${P}/${VERSION}/${P}_${VERSION}_linux_${ARCH}.zip
unzip -o -d /usr/local/bin /tmp/${P}.zip
rm /tmp/${P}.zip

# Create consul configuration directory if not created
[ -d /etc/consul.d ] || {
  mkdir /etc/consul.d
}

# Add configuration file for web service to consul.d directory if not added
#[ -f /etc/consul.d/web.json] || {
#  cp /vagrant/web.json /etc/consul.d/
#}

# Add configuration file for socat to consul.d directory if not added
#[ -f /etc/consul.d/socat.json] || {
#  cp /vagrant/socat.json /etc/consul.d/
#}

# Install socat if not installed
which socat || {
  apt-get update
  apt-get install -y socat
}