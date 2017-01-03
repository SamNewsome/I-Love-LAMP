class elk
($elasticsearch_archive = "elasticsearch-5.1.1.deb",
$logstash_archive = "logstash-5.1.1.tar.gz",
$kibana_archive = "kibana-5.1.1-linux-x86_64.tar.gz",
$KIBANA_HOME = "kibana-5.1.1-linux-x86_64",
$LOGSTASH_HOME = "logstash-5.1.1"
)
{

require java

Exec {
path => ["/usr/bin", "/bin", "/usr/sbin"]
}

##Move files across###

file { "/opt/${elasticsearch_archive}":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/elk/${elasticsearch_archive}"
}

file { "/opt/${logstash_archive}":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/elk/${logstash_archive}"
}

file { "/opt/${kibana_archive}":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/elk/${kibana_archive}"
}

###Unpackage and configure elasticsearch###

exec{ 'get elasticsearch debian key' :
command => "sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
require => File["/opt/${elasticsearch_archive}"],
}

package{ 'install elasticsearch':
ensure => installed,
provider => 'dpkg',
source => "/opt/${elasticsearch_archive}",
require => Exec["get elasticsearch debian key"],
}



###Unpackage and configure kibana###

exec{"sudo tar -xzf /opt/${kibana_archive}":
cwd => '/opt/',
creates => "/opt/${KIBANA_HOME}",
require => File["/opt/${kibana_archive}"],
}

file{"/opt/${KIBANA_HOME}/config/kibana.yml":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/elk/kibana.yml",
require => Exec["sudo tar -xzf /opt/${kibana_archive}"],
} 

###Unpackage and configure logstash###

exec{"sudo tar -xzf /opt/${logstash_archive}":
cwd => '/opt/',
creates => "/opt/${LOGSTASH_HOME}",
require => File["/opt/${logstash_archive}"],
}

file{"/opt/${LOGSTASH_HOME}/logstash.conf":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/elk/logstash.conf",
require => Exec["sudo tar -xzf /opt/${logstash_archive}"],
}

###Start services###

exec{ "sudo service elasticsearch start" :
require => Package['install elasticsearch'],
}

exec{ "sudo ./kibana &":
cwd => "/opt/${KIBANA_HOME}/bin",
require => File["/opt/${KIBANA_HOME}/config/kibana.yml"]
}

exec{ "sudo ./bin/logstash -f logstash.conf":
cwd => "/opt/${LOGSTASH_HOME}",
require => File["/opt/${LOGSTASH_HOME}/logstash.conf"],
}

}	