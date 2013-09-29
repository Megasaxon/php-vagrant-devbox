Vagrant.configure("2") do |config|

    #box configuration
    config.vm.box = "php-vagrant-devbox"
    config.vm.box_url = "http://files.craigrose.eu/vagrant-debian-wheezy64.box"

    #vm config
    config.vm.hostname = "example.com"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :private_network, ip: "192.168.1.121"

    config.vm.provider :virtualbox do |vb|
        #comment the below line out if you do not have VirtualBox installed!
        vb.customize ["modifyvm", :id, "--memory", "1024"] # Bump box memory from 384MB -> 1GB ram.
    end

    #sync Folder(s)
    #attempt to sync via NFS on linux/mac, otherwise use default shared folders
    config.vm.synced_folder "app/", "/app", :nfs => (RUBY_PLATFORM =~ /mingw32/).nil?

    #Puppet provisioning
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.facter = {
            :fqdn => "example.com",
        }
    end
end
