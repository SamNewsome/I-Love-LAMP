# iLove LAMP

Jira HTTP Port: 8081
Jira RMI Port: 8006

Once Bamboo is up and running the Port is: http://localhost:8085/

Nexus has to run on port 8081, cannot get to work with changed port

To run the master and the agents, the master vagrant files and master bootstrap.sh can be used. They can also be modified for the users own preferences such as how many agents are being used and what modules they will initiate (to share to load). It is also possible to change the ram of each agent

1.	download github repository 
2.	move all binary files to shared_master/installation_files
3.	then open gitbash in the directory and "vagrant up" to run all virtual machines;
  a.	use "vagrant up 'agentname'" to run a specific machine
4.	to test that;
  a.	jira - type 'localhost:8081' in browser
  c.	nexus - type 'localhost:8081' in browser
  e.	jenkins - type 'localhost:8080' in browser
