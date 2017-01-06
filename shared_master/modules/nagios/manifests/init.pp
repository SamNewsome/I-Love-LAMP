class nagios(
$nagios_archive = "nagios-4.2.4.tar.gz",
$nagios_plugins_archive = "nagios-plugins-2.1.4.tar.gz",
$NAGIOS_HOME = "nagios-4.2.4"
)
{

Exec {
path => ["/usr/bin", "/bin", "/usr/sbin"]
}

###Set up users and groups###
user{"nagios":
ensure => present,
}

group{"nagios":
ensure => present,
}

group{"nagcmd":
ensure => present,
}




##Move files to opt##

file{"/opt/${nagios_archive}":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/nagios/${nagios_archive}"
}

file{"/opt/${nagios_plugins_archive}":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/nagios/${nagios_plugins_archive}"
}

##Extract and configure##

exec{"sudo tar zxvf /opt/${nagios_archive}":
cwd => '/opt',
require => File["/opt/${nagios_archive}"]
}

exec{



