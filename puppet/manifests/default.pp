#set up some paths
Exec {
    path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/']
}

stage { [init, base, php, last]: }

Stage['init']->Stage['main']->Stage['base']->Stage['php']->Stage['last']

class { 'provision::init':
    stage => init,
}

class { 'provision::base':
    stage => base,
}

class { 'provision::php':
    stage => php,    
}

class {'provision::last':
    stage => last,
}