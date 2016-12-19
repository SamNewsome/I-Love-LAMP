#!/bin/bash

#Install packages
sudo apt-get update
sudo apt-get -y install openssh-server openssh-client
sudo ufw disable
sudo apt-get -y install puppetmaster puppet

#Edit /etc/hosts
fqdn=$(facter fqdn)
ip=$(facter ipaddress_eth1)
sudo sed -i "1s/^/$ip $fqdn puppetmaster\n/" /etc/hosts
sudo sed -i "1s/^/127.0.0.1 $fqdn puppetmaster\n/" /etc/hosts

#Move modules to /usr/share/puppet/modules/
sudo cp -r /tmp/shared/modules/* /usr/share/puppet/modules/

#Move binary files to correct locations
#sudo cp /tmp/shared/installation_files/atlassian-bamboo-5.13.2.tar.gz /usr/share/puppet/modules/bamboo/files/
sudo cp /tmp/shared/installation_files/java.tar.gz /usr/share/puppet/modules/java/files/
sudo cp /tmp/shared/installation_files/jenkins_2.1_all.deb /usr/share/puppet/modules/jenkins/files/
sudo cp /tmp/shared/installation_files/jira.bin /usr/share/puppet/modules/jira/files/
sudo cp /tmp/shared/installation_files/maven.tar.gz /usr/share/puppet/modules/maven/files/
#sudo cp /tmp/shared/installation_files/mysql-serrver_5.7.15-1ubuntu14.04_amd64.deb-bundle.tar /usr/share/puppet/modules/mysql/files/
sudo cp /tmp/shared/installation_files/nexus-3.0.2-02-unix.tar.gz /usr/share/puppet/modules/nexus/files/
sudo cp /tmp/shared/installation_files/packer_0.12.1_linux_amd64.zip /usr/share/puppet/modules/packer/files/
sudo cp /tmp/shared/installation_files/apache-tomcat-7.0.73.tar.gz /usr/share/puppet/modules/tomcat/files/

sudo cp /tmp/shared/installation_files/daq-2.0.6.tar.gz /usr/share/puppet/modules/tomcat/files/
sudo cp /tmp/shared/installation_files/snort-2.9.9.0.tar.gz /usr/share/puppet/modules/tomcat/files/

sudo cp -r /usr/share/puppet/modules/ /etc/puppet/
#Setup secure autosigning
sudo cp /tmp/shared/autosign/autosign /usr/local/bin/

sudo echo "autosign = /usr/local/bin/autosign" >> /etc/puppet/puppet.conf
#sudo echo "autosign = true" >> /etc/puppet.conf
sudo chmod a+x /usr/local/bin/autosign

#copy site.pp to manifests
sudo cp /tmp/shared/site.pp /etc/puppet/manifests
