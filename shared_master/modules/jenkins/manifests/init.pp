class jenkins(
$jenkins_archive = "jenkins_2.1_all.deb")
{
	require java
	
	Exec { 
		path => ["/usr/bin", "/bin", "/usr/sbin"]
	}
	
	file { "/opt/${jenkins_archive}":
		ensure => present,
		owner => vagrant,
		mode => 755,
		source => "puppet:///modules/jenkins/${jenkins_archive}",
	}
	
	package{ 'install jenkins':
		ensure => installed,
		provider => 'dpkg',
		source => "/opt/${jenkins_archive}",
		require => File["/opt/${jenkins_archive}"],
	}
	
	exec { 'start jenkins':
		command => 'sudo service start jenkins',
		require => Package['install jenkins'],
	}
}