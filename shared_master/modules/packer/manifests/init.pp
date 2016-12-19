class packer (

$installer_location = '/tmp/shared/',
$packer_archive = 'packer_0.12.1_linux_amd64.zip',
$packer_home = '/opt/packer_0.12.1',
$packer_folder = 'packer_0.12.1',
$install_location = '/opt/packer'){

exec { "create packer directory in opt" :
cwd => /opt/
command => "sudo mkdir packer"
}


Exec {
path => ['/usr/bin', '/usr/sbin', '/bin'],
}


file { "/opt/packer/${packer_archive}":
ensure => present,
source => "puppet:///modules/packer/${packer_archive}",
owner => vagrant,
mode => 755,
}

exec { 'extract packer':
cwd => '/opt/packer/',
command => "sudo unzip ${packer_archive}",
require => File["/opt/packer/${packer_archive}"]
}

}