#Set the hostname you wish to use for the box/web.
BOX_HOST_NAME       = "example.com"

#Specify the details for self-signed SSL certificate creation, feel free to leave as-is.
ssl_location        = "Somewhere"
ssl_country         = "DE"
ssl_state           = "test"
ssl_organization    = "test"
ssl_unit            = "dev"

#Main vagrant config
Vagrant.configure("2") do |config|

    #box configuration
    config.vm.box       = "php-vagrant-devbox"
    config.vm.box_url   = "http://files.craigrose.eu/vagrant-debian-wheezy64.box"

    #vm config
    config.vm.hostname = BOX_HOST_NAME
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 3306, host: 3310
    config.vm.network :private_network, ip: "192.168.1.121"

    config.vm.provider :virtualbox do |vb|
        #comment the below line out if you do not have VirtualBox installed!
        vb.customize ["modifyvm", :id, "--memory", "1024"] # Bump box memory from 384MB -> 1GB ram.
    end

    #sync Folder(s)
    #attempt to sync via NFS on linux/mac, otherwise use default shared folders, hopefully :)
    config.vm.synced_folder "app/", "/app", :nfs => (RUBY_PLATFORM =~ /mingw32/).nil?

    #Puppet provisioning
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path   = "puppet/manifests"
        puppet.module_path      = "puppet/modules"
        puppet.facter           = {
            :fqdn           => BOX_HOST_NAME,
            #pass some variables on to puppet
            "vhostname"     => BOX_HOST_NAME,
            "ssl_location"  => ssl_location,
            "ssl_country"   => ssl_country,
            "ssl_state"     => ssl_state,
            "ssl_org"       => ssl_organization,
            "ssl_unit"      => ssl_unit,
            "ssl_cn"        => BOX_HOST_NAME,            
        }
    end
end
