class provision::base {

    exec { 'apt-get upgrade':
        command => 'apt-get -y upgrade',
        require => Class['apt::update'],
    }

    file { "/home/web": 
      ensure    => "directory", 
      owner     => "www-data", 
      group     => "www-data", 
      mode      => 700, 
      require   => [ User[www-data], Group[www-data] ], 
    } 

    group { 'www-data': 
      ensure => "present", 
    } 
    user { "www-data": 
      ensure    => "present", 
      home      => "/home/web", 
      name      => "web", 
    } 

    file { "/home/web/www":
        ensure => link,
        target => "/app/www",
    }

    package { 'mariadb-server': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    service { 'mysql':
        ensure  => running,
        require => Package['mariadb-server'],
    }

    package { 'redis-server': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    service { 'redis-server':
        ensure  => running,
        require => Package['redis-server'],
    }

    package { 'nginx': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    service { 'nginx':
        ensure  => running,
        require => Package['nginx'],
    }

    file { 'nginx-conf':
        path    => '/etc/nginx/nginx.conf',
        ensure  => file,
        replace => true,
        require => Package['nginx'],
        source  => '/vagrant/puppet/configs/nginx/nginx.conf',
        notify  => Service['nginx'],
    }

    file { 'vagrant-nginx':
        path    => '/etc/nginx/sites-available/vhost.conf',
        ensure  => file,
        replace => true,
        require => Package['nginx'],
        source  => '/vagrant/puppet/configs/nginx/vhost.conf',
        notify  => Service['nginx'],
    }

    file { 'default-nginx-disable':
        path    => '/etc/nginx/sites-enabled/default',
        ensure  => absent,
        require => Package['nginx'],
    }

    file { 'vagrant-nginx-enable':
        path    => '/etc/nginx/sites-enabled/vhost.conf',
        target  => '/etc/nginx/sites-available/vhost.conf',
        ensure  => link,
        notify  => Service['nginx'],
        require => [
          File['vagrant-nginx'],
          File['default-nginx-disable'],
        ],
    }
    
    #set up MySQL/MariaDB
    file { 'mysql-conf':
        path    => '/etc/mysql/my.cnf',
        ensure  => file,
        replace => true,
        require => Package['mariadb-server'],
        source  => '/vagrant/puppet/configs/mysql/my.cnf',
        notify  => Service['mysql'],
    }
    #give remote mysql access
    exec { "mysql-init":
      unless => "/usr/bin/mysql -u${user}",
      require => Package['mariadb-server'],
      command => "/usr/bin/mysql -uroot -e \"CREATE USER 'root'@'%' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;\"",
    }

    package { 'curl':
        ensure  => present,
        require => Exec['apt-update'],
    }
}