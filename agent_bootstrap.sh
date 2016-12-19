#!/bin/bash
sudo apt-get update
sudo apt-get install -y openssh-server openssh-client
sudo ufw disable
sudo apt-get install -y puppet

fqdn=$(facter fqdn)
ip=$(facter ipaddress_eth1)

sudo sed -i "1s/^/$ip $fqdn puppet\n/" /etc/hosts
sudo sed -i "1s/^/127.0.0.1 $fqdn puppet\n/" /etc/hosts
sudo sed -i "1s/^/$masterIP $masterFQDN puppetmaster\n/" /etc/hosts
sudo sed -i "2s/^/server=$masterFQDN\n/" /etc/puppet/puppet.conf

sudo cp /tmp/shared/csr_attributes.yaml /etc/puppet

sudo service puppet restart
sudo puppet agent --enable
sudo puppet agent --test --server=$masterFQDN
