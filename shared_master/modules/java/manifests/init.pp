class java (
  $java_archive = 'java.tar.gz',
  $java_home    = '/opt/jdk1.8.0_45',
  $java_folder  = 'jdk1.8.0_45',
  ){
  
  Exec {
    path => [ '/usr/bin', 'usr/sbin', '/bin'],
  }

  file { "/opt/${java_archive}" :
    ensure      => present,
    source      => "puppet:///modules/java/${java_archive}",
    owner       => vagrant,
    mode        => 755,
  }

  exec {'extract jdk':
    cwd         => '/opt/',
    command     => "sudo tar zxfv ${java_archive}",
    #creates     => '$java_home',
    require     => File["/opt/${java_archive}"]
  }

  exec { 'install java':
    require     => Exec ['extract jdk'],
    logoutput   => true,
    command     => "update-alternatives --install /usr/bin/java java ${java_home}/bin/java 100",
  }

  exec {'install javac':
    require    => Exec['extract jdk'],
    logoutput  => true,
    command    => "update-alternatives --install /bin/javac javac ${java_home}/bin/javac 100",
  }

#file { '/etc.profile.d/java/sh':
#content => "export JAVA_HOME=${java_home}
#            export PATH=\$PATH:\$JAVA_HOME/bin"
#			}
			
}

