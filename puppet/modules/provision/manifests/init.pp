class provision::init {
    
    exec { 'apt-update': 
        command => '/usr/bin/apt-get update',
    }

    #include the required puppet labs apt
    include ::apt
    include ::apt::update

    #dotdeb PHP 5.5.x
    apt::source { 'dotdeb-php':
        location   => 'http://ftp.hosteurope.de/mirror/packages.dotdeb.org/',
        release    => 'wheezy-php55',
        repos      => 'all',
        key        => '89DF5277',
        key_server => 'keys.gnupg.net',
    }

    #dotdeb Main
    apt::source { 'dotdeb-main':
        location   => 'http://ftp.hosteurope.de/mirror/packages.dotdeb.org/',
        release    => 'wheezy',
        repos      => 'all',
        key        => '89DF5277',
        key_server => 'keys.gnupg.net',
    }
    #add MariaDB
    apt::source { 'mariadb':
        location   => 'http://mirror.netcologne.de/mariadb/repo/10.0/debian',
        release    => 'wheezy',
        repos      => 'main',
        key        => '1BB943DB',
        key_server => 'keyserver.ubuntu.com',
    }
    #SSL Cert Generation
    $subject            = "/C=${ssl_country}/ST=${ssl_state}/L=${ssl_location}/O=${ssl_org}/OU=${ssl_unit}/CN=${ssl_cn}"
    $createcertificate  = "openssl req -new -newkey rsa:2048 -x509 -days 365 -nodes -out localhost-ssl.crt -keyout localhost-ssl.key -subj \"${subject}\""
    
    #Create cert via OpenSSL
    exec { "openssl-csr":
      command   => $createcertificate,
      cwd       => '/etc/',
      creates   => "/etc/localhost-ssl.key"
    }
}