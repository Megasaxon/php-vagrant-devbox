Exec {
    path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/']
}

stage { 'dotdeb':
    before => Stage['libs']
}

stage { 'libs':
    before => Stage['main']
}


class dotdeb {
    stage => 'libs',
    include apt
    include apt-update

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

    exec { 'apt-get upgrade':
        command => 'apt-get -y upgrade',
        require => Class['apt::update'],
    }

}


#class { 'init':
#    stage => first
#    user { 'web':
#        ensure => "present",
#        home => "/home/web",
#        name => "web",
#        shell => "/bin/bash",
#        managehome => true,
#        #groups => 'www-data',
#        require => Group['www-data']
#    }
#    file { "/home/web":
#        ensure => "directory",
#        owner  => "web",
#        group  => "web",
#        mode   => 700,
#        require =>  [ User[web], Group[www-data] ],
#
#   }
#}   

group { 'puppet':
    ensure => present,
}

exec { 'apt-update': 
    command => '/usr/bin/apt-get update',
}

#run an apt-update every time we install a package, just incase :)
Exec["apt-update"] -> Package <| |>

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

package { 'php5-mysql': 
    ensure => present,
    require => [
        Exec['apt-update'],
        Package['php5-fpm']
    ],
    notify => Service['php5-fpm'],
}

package { 'nginx': 
    ensure => present,
    require => Exec['apt-update'],
}

service { 'php5-fpm':
    enable => true,
    ensure => running,
    require => Package['php5-fpm'],
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

file { "/home/web/www/":
    ensure => link,
    target => "/app/",
}