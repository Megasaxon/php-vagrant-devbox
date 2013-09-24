Exec {
    path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/']
}

stage { 'dotdeb':
    before => Stage['main']
}
stage { 'last':
}

class { 'dotdeb':
    stage => dotdeb,
}

class { 'base':
    stage => main,
}

Stage['main'] -> Stage['last']

class dotdeb {    
    include apt
    include apt::update

    apt::source { 'dotdeb-php':
        location   => 'http://packages.dotdeb.org',
        release    => 'wheezy-php55',
        repos      => 'all',
        key        => '89DF5277',
        key_server => 'keys.gnupg.net',
    }
    apt::source { 'dotdeb-main':
        location   => 'http://packages.dotdeb.org',
        release    => 'wheezy',
        repos      => 'all',
        key        => '89DF5277',
        key_server => 'keys.gnupg.net',
    }

}

class base {

    exec { 'apt-get upgrade':
        command => 'apt-get -y upgrade',
        require => Class['apt::update'],
    }

    file { "/home/web": 
      ensure => "directory", 
      owner => "www-data", 
      group => "www-data", 
      mode => 700, 
      require => [ User[www-data], Group[www-data] ], 
    } 

    group { 'www-data': 
      ensure => "present", 
    } 
    user { "www-data": 
      ensure => "present", 
      home => "/home/web", 
      name => "web", 
    } 

    file { "/home/web/www":
        ensure => link,
        target => "/app/www",
    }

    package { 'nginx': 
        ensure => present,
        require => Exec['apt-update'],
    }

    service { 'nginx':
        ensure => running,
        require => Package['nginx'],
    }

    file { 'nginx-conf':
        path => '/etc/nginx/nginx.conf',
        ensure => file,
        replace => true,
        require => Package['nginx'],
        source => 'puppet:///modules/nginx/nginx.conf',
        notify => Service['nginx'],
    }

    file { 'vagrant-nginx':
        path => '/etc/nginx/sites-available/vhost.conf',
        ensure => file,
        replace => true,
        require => Package['nginx'],
        source => 'puppet:///modules/nginx/vhost.conf',
        notify => Service['nginx'],
    }

    file { 'default-nginx-disable':
        path => '/etc/nginx/sites-enabled/default',
        ensure => absent,
        require => Package['nginx'],
    }

    file { 'vagrant-nginx-enable':
        path => '/etc/nginx/sites-enabled/vhost.conf',
        target => '/etc/nginx/sites-available/vhost.conf',
        ensure => link,
        notify => Service['nginx'],
        require => [
          File['vagrant-nginx'],
          File['default-nginx-disable'],
        ],
    }

    file { 'vagrant-php5-fpm':
        path => '/etc/php5/fpm/php.ini',
        ensure => file,
        replace => true,
        require => Package['php5-fpm'],
        source => 'puppet:///modules/php5-fpm/php.ini',
        notify => Service['php5-fpm'],
    }
    package { 'curl':
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-fpm': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-cli': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-curl': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-memcached': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-mcrypt': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-xhprof': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-xdebug': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-redis': 
        ensure => present,
        require => Exec['apt-update'],
    }

    package { 'php5-mysqlnd': 
        ensure => present,
        require => [
            Exec['apt-update'],
            Package['php5-fpm']
        ],
        notify => Service['php5-fpm'],
    }

    service { 'php5-fpm':
        enable => true,
        ensure => running,
        require => Package['php5-fpm'],
    }

}
  

exec { 'apt-update': 
   command => '/usr/bin/apt-get update',
}
