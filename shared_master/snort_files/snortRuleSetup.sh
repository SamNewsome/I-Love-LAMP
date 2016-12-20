#!/bin/bash
snort_src="/opt/snort-2.9.9.0"
echo "adding group and user for snort..."
sudo groupadd snort &> /dev/null
sudo useradd snort -r -s /sbin/nologin -d /var/log/snort -c snort_idps -g snort &> /dev/null #snort configuration
echo "Configuring snort..."mkdir -p /etc/snort
sudo mkdir -p /etc/snort/rules
sudo touch /etc/snort/rules/black_list.rules
sudo touch /etc/snort/rules/white_list.rules
sudo touch /etc/snort/rules/local.rules
sudo mkdir /etc/snort/preproc_rules
sudo mkdir /var/log/snort
sudo mkdir -p /usr/local/lib/snort_dynamicrules
sudo chmod -R 775 /etc/snort
sudo chmod -R 775 /var/log/snort
sudo chmod -R 775 /usr/local/lib/snort_dynamicrules
sudo chown -R snort:snort /etc/snort
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules
###copy  configuration and rules from  etc directory under source code of snort
echo "copying from snort source to /etc/snort ....."
echo $snort_src
echo "-------------"
sudo cp $snort_src/etc/*.conf* /etc/snort
sudo cp $snort_src/etc/*.map /etc/snort
##enable rules
sudo sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/' /etc/snort/snort.conf
echo "---DONE---"
