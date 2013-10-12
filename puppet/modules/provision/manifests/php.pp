class provision::php {

    package { 'php5-fpm': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-cli': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-curl': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-memcached': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-mcrypt': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-xhprof': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-xdebug': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-redis': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php-pear': 
        ensure  => present,
        require => Exec['apt-update'],
    }

    package { 'php5-mysqlnd': 
        ensure  => present,
        require => [
            Exec['apt-update'],
            Package['php5-fpm']
        ],
        notify  => Service['php5-fpm'],
    }

    exec { 'pear-upgrade':
        command => 'pear upgrade PEAR',
    }

    exec { 'pear-config':
        command => 'pear config-set auto_discover 1',
    }

    exec { 'pear-phpqatools':
        command => 'pear install pear.phpqatools.org/phpqatools',
    }

    file { 'vagrant-php5-fpm':
        path    => '/etc/php5/fpm/php.ini',
        ensure  => file,
        replace => true,
        require => Package['php5-fpm'],
        source  => 'puppet:///modules/php5-fpm/php.ini',
        notify  => Service['php5-fpm'],
    }
    
    service { 'php5-fpm':
        enable  => true,
        ensure  => running,
        require => Package['php5-fpm'],
    }
}