class jira(
		$jira_file = "jira.bin",
		$jira_home = "/usr/lib/atlassian/jira/",
		$jira_folder = "jira")
		{
		
		Exec {
			path => [ "/usr/bin", "/bin", "/usr/sbin"]
		}
		
		file { "/opt/${jira_file}" :
			ensure => "present",
			source => "puppet:///modules/jira/${jira_file}",
			owner  => vagrant,
			mode   => 755
		}
	
		file { '/opt/response.varfile' :
			ensure => "present",
			owner => vagrant,
			source => "puppet:///modules/jira/response.varfile",
			mode   => 755
		}

		exec {'Run jira':
			cwd => '/opt/',
			command => "sudo ./${jira_file} -q -varfile /opt/response.varfile",
			#creates => $jira_home,
			require => File["/opt/${jira_file}", '/opt/response.varfile']
		}
		
}