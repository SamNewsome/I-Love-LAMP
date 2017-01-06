#!/usr/bin/env bash

##Install dependencies##
sudo apt-get install -y autoconf gcc libc6 build-essential bc gawk dc gettext libmcrypt-dev libssl-dev make unzip apache2 apache2-utils php5 libgd-dev

##Create nagios user##

sudo useradd -m -s bash nagios
sudo groupadd nagios
sudo usermod -G nagios nagios

##Create nagcmd group for allowing external commands to be submitted through the web interface##

sudo /usr/sbin/groupadd nagcmd
sudo /usr/sbin/usermod -a -G nagcmd nagios
sudo /usr/sbin/usermod -a -G nagcmd www-data

##Move files and extract##

sudo cp /etc/puppet/modules/nagios/files/etc/nagios-4.2.4.tar.gz /opt
sudo cp /etc/puppet/modules/nagios/files/nagios-plugins-2.1.4.tar.gz /opt

sudo tar zvxf /opt/nagios-4.2.4.tar.gz
sudo tar zvxf /opt/nagios-plugins-2.1.4.tar.gz

##Configure nagios script and install binaries##

sudo ./opt/nagios-4.2.4/configure --with-command-group=nagcmd --with-httpd-conf=/etc/apache2/sites-enabled

sudo make all -C /opt/nagios-4.2.4
sudo make install -C /opt/nagios-4.2.4
sudo make install-init -C /opt/nagios-4.2.4
sudo make install-config -C /opt/nagios-4.2.4
sudo make install-commandmode -C /opt/nagios-4.2.4
sudo update-rc.d nagios defaults 

##Configure Web Interface##

sudo make install-webconf -C /opt/nagios-4.2.4
sudo a2enmod rewrite
sudo a2enmod cgi

sudo ufw allow Apache
sudo ufw reload

##Configure Nagios plugins##

sudo ./opt/nagios-plugins-2.14/configure
sudo make -C /opt/nagios-plugins-2.1.4
sudo make install -C /opt/nagios-plugins-2.1.4

##Start service##

sudo service apache2 restart
sudo service nagios start
