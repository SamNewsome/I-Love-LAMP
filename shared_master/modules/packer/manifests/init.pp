class packer {

#$installer_location = '/tmp/shared/',
#$packer_archive = 'packer_0.12.1_linux_amd64.zip',
#$packer_home = '/opt/packer_0.12.1',
#$packer_folder = 'packer_0.12.1',
#$install_location = '/opt/packer'){

Exec {
path => ['/usr/bin', '/usr/sbin', '/bin'],
}

exec { "remove packer directory in opt" :
command => "sudo rm -r /opt/packer",
}

exec { "create packer directory in opt" :
cwd => '/opt/',
command => "sudo mkdir packer",
require => Exec["remove packer directory in opt"],
}

exec { "copy zip file" :
cwd => '/opt/packer',
command => 'sudo cp /tmp/shared/installation_files/packer_0.12.1_linux_amd64.zi$
require => Exec['create packer directory in opt'],
}

#file { "/opt/packer/packer_0.12.1_linux_amd64.zip":
#ensure => present,
#source => "puppet:///modules/packer/packer_0.12.1_linux_amd64.zip",
#owner => 'vagrant',
#mode => '755',
#}

exec { 'extract packer':
cwd => '/opt/packer/',
command => "sudo unzip packer_0.12.1_linux_amd64.zip",
require => Exec['copy zip file'],
#require => File["/opt/packer/packer_0.12.1_linux_amd64.zip"]
}

exec { "write to bashrc" :
command => 'sudo echo export PATH=$PATH:/opt/packer >> ~/.bashrc',
require => Exec["extract packer"]
}

}



