class nexus (
                $NEXUS_VERSION ="nexus-3.2.0-01",
)
                {
        Exec {
                path => ["/usr/bin","/bin","/usr/sbin"]
        }

        exec { 'install java part1' :
                command => 'sudo apt-get install python-software-properties',
        }

        exec { 'install java part2' :
                command => 'sudo add-apt-repository -y ppa:webupd8team/java',
                require => Exec['install java part1'],
        }

        exec { 'install java part3' :
                command => 'sudo apt-get -y update',
                require => Exec['install java part2'],
        }


        exec { 'install java part4' :
                command => 'echo debconf shared/accepted-oracle-license-v1-1 select true | \
                            sudo debconf-set-selections',
                require => Exec['install java part3'],
        }

        exec { 'install java part5' :
                command => 'echo debconf shared/accepted-oracle-license-v1-1 seen true | \
                            sudo debconf-set-selections',
                require => Exec['install java part4'],
        }

        exec { 'install java part6' :
                command => 'sudo apt-get install -y oracle-java8-installer',
                require => Exec['install java part5'],
        }

	exec { 'copy nexus tar file' :
                command => 'sudo cp /tmp/shared/nexus-3.2.0-01-unix.tar.gz /opt',
        	require => Exec['install java part6']
	}

        exec { 'extract nexus tar file' :
                cwd => '/opt',
                command => 'sudo tar zxvf nexus-3.2.0-01-unix.tar.gz',
                require => Exec['copy nexus tar file'],
	}

	exec { 'add nexus user' : 
		command => 'sudo adduser --no-create-home --disabled-login --disabled-password --gecos "" nexus',
		require => Exec['install java part6'],
	}
	
	exec { 'add nexus password' : 
		command => 'echo -e "nexus\nnexus" | sudo passwd nexus',
		require => Exec['add nexus user'],
	}	
	
	exec { 'edit nexus file part1' : 
		cwd => '/opt/nexus-3.2.0-01/bin',
		command => 'sudo sed -i "21i NEXUS_HOME="/opt/nexus-3.2.0-01/bin/nexus"" nexus',
		require => Exec['extract nexus tar file'], 
	}

	exec { 'edit nexus file part2' : 
		cwd => '/opt/nexus-3.2.0-01/bin',
		command => 'sudo sed -i "459s/''/'nexus'/" nexus',
		require => Exec['edit nexus file part1'], 
        }

	exec { 'make file executable' :
                cwd => '/opt/nexus-3.2.0-01/bin',
                command => 'sudo chmod a+x nexus',
                require => Exec['edit nexus file part2'],
        }

	exec { 'change ownership to nexus' :
                cwd => '/opt/',
                command => 'sudo chown -R nexus:nexus nexus-3.2.0-01 sonatype-work',
                require => Exec['make file executable'],
        }

	exec { 'change user to nexus' :
                command => 'echo -e "nexus" | su nexus',
                require => Exec['change ownership to nexus'],
        }

        exec { 'install nexus' :
                cwd => '/opt/nexus-3.2.0-01/bin',
                command => 'sudo ./nexus run',
                require => Exec['extract nexus tar file'],
        }
	
	exec { 'start nexus' :
                cwd => '/opt/nexus-3.2.0-01/bin',
                command => 'sudo ./nexus restart',
                require => Exec['extract nexus tar file'],
        }
}