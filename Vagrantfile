# -*- mode: ruby -*-
# vi: set ft=ruby :

masterIP = "192.168.1.153"
masterFQDN = "supremeleader"

Vagrant.configure("2") do |config|

    config.vm.box = "chad-thompson/ubuntu-trusty64-gui"
	
	config.vm.define "master" do |master|
		master.vm.network :public_network, ip: masterIP
		master.vm.hostname = masterFQDN
		master.vm.synced_folder "shared_master", "/tmp/shared"
		master.vm.provision :shell, path: "master_bootstrap.sh" 
		
		
		master.vm.provider :virtualbox do |masterVM|
			masterVM.gui = true
			masterVM.name = "master"
			masterVM.memory = 4096
			masterVM.cpus = 2
		end
	end    
    	
	agent_nodes = [
		{ :hostname => 'jenkinsAgent.qac.local',	:ip => '192.168.1.160',	:ram => 4096},
		#{ :hostname => 'nexusAgent.qac.local',	:ip => '192.168.1.22', 	:ram => 2048},
		#{ :hostname => 'jiraAgent.qac.local',	:ip => '192.168.1.23', 	:ram => 2048},
		#{ :hostname => 'bambooAgent.qac.local',	:ip => '192.168.1.24', 	:ram => 2048},
		#{ :hostname => 'mysqlAgent.qac.local',	:ip => '192.168.1.25', 	:ram => 2048},
	]
	
	agent_nodes.each do |agent|
		config.vm.define agent[:hostname] do |agentconfig|
			agentconfig.vm.network :public_network, ip: agent[:ip]
			agentconfig.vm.hostname = agent[:hostname]
			agentconfig.vm.synced_folder "shared_agent", "/tmp/shared"
			agentconfig.vm.provision :shell, path: "agent_bootstrap.sh", env: {"masterFQDN" => masterFQDN, "masterIP" => masterIP}
			
		
			agentconfig.vm.provider :virtualbox do |agentVM| 
				agentVM.gui = true
				agentVM.name = agent[:hostname]
				agentVM.memory = agent[:ram]
				agentVM.cpus = 2
			end
		end  
	end
end
