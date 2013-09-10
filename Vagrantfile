Vagrant.configure("2") do |config|

	#box configuration
	config.vm.box = "devbox"
	config.vm.box_url = "http://craigrose.eu/vagrant/vagrant-raring64.box"

	#vm config
	config.vm.hostname = "example.com"
	config.vm.network :forwarded_port, guest: 80, host: 8080
	config.vm.network :private_network, ip: "192.168.1.121"

	config.vm.provider :virtualbox do |vb|
		vb.customize ["modifyvm", :id, "--memory", "1024"] # Bump box memory from 384MB -> 1GB ram.
	end

	#sync Folder(s)
	config.vm.synced_folder "app/", "/app", :nfs => true

	#Puppet provisioning
	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = "puppet/manifests"
		puppet.manifests_file = "default.pp"
		puppet.module_path = "puppet/modules"
	end
end