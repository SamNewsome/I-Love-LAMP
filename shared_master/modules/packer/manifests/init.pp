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
}

exec { "copy zip file" :
cwd => '/opt/packer',
command => 'sudo cp /tmp/shared/installation_files/packer_0.12.1_linux_amd64.zip /opt/packer',
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

file { '/opt/packer/setpath.sh' :
ensure => present,
source => 'puppet:///modules/packer/setpath.sh',
require => Exec['extract packer'],
before => Exec['shell_perm'],
}

exec { 'shell_perm' :
cwd => '/opt/packer/',
command => 'sudo chmod a+x /opt/packer/setpath.sh',
require => File['/opt/packer/setpath.sh'],
before => Exec['path_app'],
}

exec { 'path_app' :
cwd => '/opt/packer/',
command => "sudo bash -c '/opt/packer/setpath.sh'",
require => Exec['shell_perm'],
before => Exec['load_path'],
}

exec { 'load_path' :
command => "sudo bash -c \"source /etc/environment\"",
require => Exec['path_app'],
}

exec { 'reload_path' :
command => "source /etc/environment",
require => Exec['load_path'],
}


}



