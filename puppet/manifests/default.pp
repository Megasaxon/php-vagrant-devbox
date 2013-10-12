#set up some paths
Exec {
    path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/']
}
#require puppetlabs stdlib
include stdlib

class { 'provision::init':
    stage => setup,
}

class { 'provision::base':
    stage => runtime,
}

class { 'provision::php':
    stage => setup_infra,    
}

class {'provision::last':
    stage => deploy_infra,
}