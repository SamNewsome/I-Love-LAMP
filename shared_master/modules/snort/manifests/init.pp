class snort(
$snort_archive = "snort-2.9.9.0.tar.gz",
$snort_home = "snort-2.9.9.0",

$daq_archive = "daq-2.0.6.tar.gz",
$daq_home = "daq-2.0.6",

$snortBash_file = "snortRuleSetup.sh",
$snortBash_location = "/usr/share/puppet/modules/snort/files/",

$snortConf_file = "snort.conf",
$snortConf_location = "/usr/share/puppet/modules/snort/files/",

$community_archive = "community-rules.tar",
$community_home = "community-rules",

)
{

Exec {
path => ["/usr/bin", "/bin", "/usr/sbin"]
}

file { "/opt/${snort_archive}":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/snort/${snort_archive}"
}

exec { "install dependices":
command => "sudo apt-get install -y build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev libdnet",
require => File["/opt/${snort_archive}"]
}

## --------------------------------------------------------
## installing DAQ

exec { "install DAQ":
cwd => '/opt/',
creates => "/opt/${daq_home}",
command => "sudo tar zxvf ${daq_archive}",
require => Exec["install dependices"]
}

exec { "config DAQ":
cwd => '/opt/${daq_home}',
command => "sudo ./configure",
require => Exec["install DAQ"]
}

exec { "create make file DAQ":
cwd => '/opt/${daq_home}',
command => "sudo make",
require => Exec["config DAQ"]
}

exec { "install make file DAQ":
cwd => '/opt/${daq_home}',
command => "sudo make install",
require => Exec["create make file DAQ"]
}
## --------------------------------------------------------

## --------------------------------------------------------
## installing Snort

exec { "install SNORT":
cwd => '/opt/',
creates => "/opt/${snort_home}",
command => "sudo tar zxvf ${snort_archive}",
require => Exec["install make file DAQ"]
}

exec { "config Snort":
cwd => '/opt/${snort_home}',
command => "sudo ./configure --enable-sourcefire",
require => Exec["install SNORT"]
}

exec { "create make file Snort":
cwd => '/opt/${snort_home}',
command => "sudo make",
require => Exec["config Snort"]
}

exec { "install make file Snort":
cwd => '/opt/${snort_home}',
command => "sudo make install",
require => Exec["create make file Snort"]
}

## --------------------------------------------------------

## --------------------------------------------------------
## Setting up the rules and config for Snort

exec { "run bash script snortRuleSetup":
cwd => '${snortBash_location}',
command => "sudo bash ${snortBash_file}",
require => Exec["install make file Snort"]
}

exec { "copy snort.conf":
cwd => '${snortConf_location}',
command => "sudo cp ${snortConf_file} /opt/${snort_home}/etc/",
require => Exec["run bash script snortRuleSetup"]
}

## --------------------------------------------------------
## community rules

exec { "install communityRules":
cwd => '/opt/',
creates => "/opt/${community_home}",
command => "sudo tar xvf ${community_archive}",
require => Exec["run bash script snortRuleSetup"]
}

exec { "copy CommunityRules":
cwd => '/opt/${community_home}',
command => "sudo cp community-rules/* /etc/snort/rules/",
require => Exec["install communityRules"]
}

exec { "test settings":
cwd => '/opt/${snort_home}',
command => "sudo snort -T -c /etc/snort/snort.conf",
require => Exec["copy CommunityRules"]
}

exec { "run Snort":
cwd => '/usr/local/bin/',
command => "sudo ./snort -i eth0",
require => Exec["test settings"]
}


}












