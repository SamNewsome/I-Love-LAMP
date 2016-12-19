class bamboo(

$installer_location = '/tmp/shared/',
$bamboo_archive = 'atlassian-bamboo-5.13.2.tar.gz',
$bamboo_home = '/opt/atlassian-bamboo-5.13.2',
$bamboo_folder = 'bamboo',
$install_location  ='/opt/'){

Exec {
path => ['/usr/bin', '/usr/sbin', '/bin'],
}



file {'/home/bamboo/bamboo-home':
ensure => present,
}

file { "/opt/${bamboo_archive}":
ensure => present,
source => "puppet:///modules/bamboo/${bamboo_archive}",
owner => vagrant,
mode => 755,
}

exec { 'extract bamboo':
cwd => '/opt/',
command => "sudo tar zxvf ${bamboo_archive}",
require => File["/opt/${bamboo_archive}", '/home/bamboo/bamboo-home'],
}

exec { 'Specify home directory' :
command => 'sudo echo "bamboo.home=/home/bamboo/bamboo-home" >> /opt/atlassian-bamboo-5.13.2/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties',
require => Exec['extract bamboo']
}


exec { 'change permissions to bamboo.init':
command => 'sudo chmod 755 /opt/atlassian-bamboo-5.13.2/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties',
require => Exec['Specify home directory'],
}

exec { 'start bamboo':
command => "sudo /opt/atlassian-bamboo-5.13.2/bin/start-bamboo.sh",
require => Exec['change permissions to bamboo.init'],
}


}
