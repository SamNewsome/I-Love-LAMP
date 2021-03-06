node default {
	include java
	include git
	include haproxy
}

node 'jenkinsAgent.qac.local' {
	include jenkins
	include maven
}

node 'nexusAgent.qac.local' {
	include nexus
}

node 'jiraAgent.qac.local' {
	include jira
}

node 'tomcatAgent.qac.local'{
	include tomcat
}

node 'snortAgent.qac.local'{
	include snort
}
