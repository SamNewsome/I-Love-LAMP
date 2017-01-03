class elasticsearch(
$elasticsearch_archive = "elasticsearch-5.1.1.tar.gz",
$elasticsearch_home = "elasticsearch-5.1.1",
)
{
Exec{
path => ["/usr/bin", "/bin", "usr/bin"]
}

exec { "import elasticsearch":
cwd => '/etc/tmp/shared/installation_files',
command => "sudo cp ${elasticsearch_archive} /opt",
}

file{ "/opt/$elasticsearch_archive"}:
ensure => present,
owner => vagrant,
mode => 755,
source => "puppet:///modules/elasticsearch/${elasticsearch_archive}",
}

exec { "install elasticsearch":
cwd => '/opt/',
creates => "/opt/${elasticsearch_home}",
command => "sudo tar zxvf ${elasticsearch_archive}",
}

exec { "run elasticsearch":
cwd => '/opt/${elasticsearch_home}',
command => "sudo elasticsearch -T -c /etc/elasticsearch/elasticsearch.conf",
require => Exec["copy elasticsearch.yml"],
}
}
