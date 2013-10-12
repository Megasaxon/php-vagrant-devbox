class provision::last {

    exec { 'fetch composer':
        command => 'curl -sS https://getcomposer.org/installer | php',
        path    => ['/usr/bin', '/usr/sbin']
    }

  exec { 'copy composer bin': 
    command => 'mv composer.phar /usr/local/bin/composer',
    require => Exec['fetch composer'],
    unless  => 'test -f /usr/local/bin/composer',
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
  }
}