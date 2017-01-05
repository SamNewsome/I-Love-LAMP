class haproxy {

Exec {
path => ['/usr/bin', '/usr/sbin', '/bin'],
}

exec { "Install packages" :
        command => "sudo apt-get -y install build-essential libssl-dev libpcre++-dev",
}

#exec { "remove user" :
#       command => "sudo userdel haproxy",
#       before => Exec['Add haproxy user'],
#}

exec { "Add haproxy user" :
        command => "sudo useradd haproxy",
}

exec { "Copy haproxy tar file" :
        command => "sudo cp /etc/puppet/modules/haproxy/files/haproxy-1.7.1.tar.gz /var/lib/haproxy-1.7.1.tar.gz
        require => Exec['Add haproxy user'],
}

exec { "Extract haproxy tar file" :
        cwd => "/var/lib",
        command => "sudo tar -zxvf haproxy-1.7.1.tar.gz",
        require => Exec['Copy haproxy tar file'],
}

exec { "Compile haproxy" :
        cwd => "/var/lib/haproxy-1.7.1",
        command => "sudo make TARGET=linux2628 CPU=native USE_STATIC_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1",
        require => Exec['Extract haproxy tar file'],
}

exec { "Install haproxy" :
        cwd => "/var/lib/haproxy-1.7.1",
        command => "sudo make install",
        require => Exec['Compile haproxy'],
}

exec { "copy executable haproxy file" :
        cwd => '/etc/init.d',
        command => 'sudo cp /etc/puppet/modules/haproxy/files/haproxy haproxy',
        require => Exec['Install haproxy'],
}

exec { "Create haproxy folder" :
        command => 'sudo mkdir /etc/haproxy',
        require => Exec['copy executable haproxy file'],
}

exec { "copy haproxy.cfg file" :
        cwd => '/etc/haproxy',
        command => 'sudo cp /etc/puppet/modules/haproxy/files/haproxy.cfg haproxy.cfg',
        require => Exec['Create haproxy folder'],
}

exec { "copy files part1" :
        command => "sudo cp /var/lib/haproxy-1.7.1/haproxy /usr/sbin/haproxy",
        require => Exec['copy haproxy.cfg file'],
}

exec { "copy files part2" :
        command => "sudo cp /var/lib/haproxy-1.7.1/haproxy-systemd-wrapper /usr/sbin/haproxy-systemd-wrapper",
        require => Exec['copy files part1'],
}

exec { "Start haproxy" :
        command => "sudo service haproxy start",
        require => Exec['copy files part2'],
}

}

