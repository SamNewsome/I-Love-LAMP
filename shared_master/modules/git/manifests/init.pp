class git
{
	Exec { 
		path => ["/usr/bin", "/bin", "/usr/sbin"]
	}
		
		exec{ 'install git':
			command => 'sudo apt-get install -y git',
		}
}