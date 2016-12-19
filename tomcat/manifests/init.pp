class tomcat(
$tomcat_archive = "apache-tomcat-7.0.73.tar.gz",
$tomcat_home = "apache-tomcat-7.0.73"){

require java


Exec {
path => ["/usr/bin", "/bin", "/usr/sbin"]
}

file { "/opt/${tomcat_archive}":
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/tomcat/${tomcat_archive}"
}

exec { "sudo tar zvxf /opt/${tomcat_archive}":
cwd => '/opt/',
creates => "/opt/${tomcat_home}",
require => File["/opt/${tomcat_archive}"]
}

exec{ "sudo ./startup.sh":
cwd => "/opt/${tomcat_home}/bin/",
require => Exec["sudo tar zvxf /opt/${tomcat_archive}"]
}
