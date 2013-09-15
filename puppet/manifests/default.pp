group { 'puppet':
    ensure => present,
}

exec { 'apt-update': 
    command => '/usr/bin/apt-get update',
}

#run an apt-get update every time we install a package, just incase :)
Exec["apt-update"] -> Package <| |>

package { 'curl':
    ensure => present,
    require => Exec['apt-get update'],
}

package { 'php5-fpm': 
    ensure => present,
    require => Exec['apt-get update'],
}

package { 'php5-mysql': 
    ensure => present,
    require => [
        Exec['apt-get update'],
        Package['php5-fpm']
    ],
    notify => Service['php5-fpm'],
}

package { 'nginx': 
    ensure => present,
    require => Exec['apt-get update'],
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