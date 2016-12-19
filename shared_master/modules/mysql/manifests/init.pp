#parameterised for future change/updates
class mysql($mysql_archive	= 'mysql-server_5.7.15-1ubuntu14.04_amd64.deb-bundle.tar'){
	
	Exec {
		path	=>	['/usr/bin', '/usr/sbin', '/bin'],
		returns =>	[0, 2, 14, 100],
	}
	
	package { 'libaio1' : 
		ensure => present,
	}
	
	package { 'libmecab2' : 
		ensure => present,
		require => Package['libaio1']
	}
	
	exec { 'opt_dir' :
	command	=> 'mkdir -p /opt/mysql && mkdir mkdir -p /opt/mysql/tmp', 
	require => Package['libmecab2'],
	}
	
#FOLDER START	
	# EXTRACT ARCHIVE
	
	file {"/opt/mysql/${mysql_archive}" : 
		ensure  => present,
		source  => "puppet:///modules/mysql/${mysql_archive}",
		require => Exec["opt_dir"]
	}
	
	exec { "extract_mysql" :
		cwd	=> "/opt/mysql",
		command	=> "sudo tar xvf ${mysql_archive}",
		require	=> File["/opt/mysql/${mysql_archive}"],
	}
	# EXTRACT END
	
	# PRESEED ANSWERS
	exec { "set_ans" : 
		cwd		=> "/opt/mysql",
		command	=> "sudo bash -c 'debconf-set-selections <<< \"mysql-community-server  mysql-community-server/root-pass password root\"'",
		require	=> Exec['extract_mysql'],
	}
	
	exec { "set_ans2" :
		cwd		=> "/opt/mysql",
		command	=> "sudo bash -c 'debconf-set-selections <<< \"mysql-community-server  mysql-community-server/re-root-pass password root\"'",
		require	=> Exec['set_ans'],
	}
	# PRESEED END
	
#FOLDER END

#INSTALL BEGIN
	#INSTALL MYSQL
	exec { "install_sql" : 
		cwd			=> "/opt",
		environment =>  [ "DEBIAN_FRONTEND=noninteractive" ],
		command		=> "sudo bash -c 'DEBIAN_FRONTEND=noninteractive dpkg -R --install mysql/'",
		require		=> Exec['set_ans2'],
	}
	#INTALL END
	
	#ENSURING SQL STATEMENTS AND CONF FILES ARE LOADED
	#COPY POST CONFIGS
	file { "/opt/mysql/tmp/post_install.sql" : 
		ensure  => present,
		source  => "puppet:///modules/mysql/post_install.sql",
		require => Exec["install_sql"]
	}
	
	file { "/opt/mysql/tmp/mysqld.cnf" : 
		ensure  => present,
		source  => "puppet:///modules/mysql/mysqld.cnf",
		require => File["/opt/mysql/tmp/post_install.sql"]
	}
	#COPY POST CONFIGS END
	
	#COPY MYSQL MY.CNF FILE FOR REMOTE ACCESS
	exec { "sql_conf" : 
		cwd		=> "/opt/mysql/tmp",
		command	=> 'sudo cp ./mysqld.cnf /etc/mysql/mysql.conf.d/',
		require	=> File["/opt/mysql/tmp/mysqld.cnf"],
	}
	
	#EXECUTE SQL STATEMENT
	exec { "sql_stat" : 
		cwd		=> "/opt/mysql/tmp",
		command	=> 'mysql -sfu root --password=root < "post_install.sql"',
		require	=> Exec['sql_conf'],
	}
	
	#REMOVE TMP FOLDER
	exec { "rm_post" : 
		command => "rm -rf /opt/mysql/tmp",
		require	=> Exec['sql_stat'],
	}
	
	#RESTART MYSQL SERVICE
	exec { "sql_stop" : 
		command => "sudo /etc/init.d/mysql restart",
		require	=> Exec['rm_post'],
	}
}
 
