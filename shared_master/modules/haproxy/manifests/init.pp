class haproxy {
	
Exec {
path => ['/usr/bin', '/usr/sbin', '/bin'],
}

exec { "Install packages" :
	command => "sudo apt-get -y install build-essential libssl-dev libpcre++-dev",
}

exec { "remove user" :
	command => "sudo userdel haproxy",
	before => Exec['Add haproxy user'],
}

exec { "Add haproxy user" :
	command => "sudo useradd haproxy",
}

exec { "Copy haproxy tar file" :
        command => "sudo cp /tmp/shared/haproxy-1.7.1.tar.gz /opt",
	require => Exec['Add haproxy user'],
}

exec { "Extract haproxy tar file" :
        cwd => "/opt",
	command => "sudo tar -zxvf haproxy-1.7.1.tar.gz",
        require => Exec['Copy haproxy tar file'],
}

exec { "Compile haproxy" :
	cwd => "/opt/haproxy-1.7.1",
        command => "sudo make TARGET=linux2628 CPU=native USE_STATIC_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1",
        require => Exec['Extract haproxy tar file'],
}

exec { "Install haproxy" :
        cwd => "/opt/haproxy-1.7.1",
	command => "sudo make install",
        require => Exec['Compile haproxy'],
}

file { '/etc/init.d/haproxy' :
	ensure => present,
	source => 'puppet:///modules/haproxy/haproxy',
	require => Exec['Install haproxy'],
	before => Exec['haproxy executable'],
}

exec { 'haproxy executable' :
	cwd => '/etc/init.d',
	command => 'sudo chmod a+x /etc/init.d/haproxy',
	require => File['/etc/init.d/haproxy'],
}

exec { "Create haproxy folder" :
        command => "sudo mkdir /etc/haproxy",
        require => Exec['haproxy executable'],
}
	
file { '/etc/haproxy/haproxy.cfg' :
        ensure => present,
        source => 'puppet:///modules/haproxy/haproxy.cfg',
        require => Exec['Create haproxy folder'],
}

exec { "Start haproxy" :
        command => "sudo service haproxy start",
        require => File['/etc/haproxy/haproxy.cfg'],
}

}

