class puppet::agent {
  include puppet::agent::package, puppet::agent::service

  $service_notify = $puppet::service ? {
    false   => undef,
    default => 'Class[puppet::agent::service]',
  }

  Ini_setting {
    ensure  => present,
    section => 'agent',
    path    => '/etc/puppet/puppet.conf',
    require => Class['puppet::agent::package'],
    notify  => $service_notify,
    #notify  => Class['puppet::agent::service'],
  }

  case $pluginsync {
    true,'true': { $pluginsync_r = 'true' }
    false,'false': { $pluginsync_r = 'false' }
    default: { $pluginsync_r = undef }
  }

  if $pluginsync_r {
    ini_setting { 'puppet-agent-pluginsync':
      setting => 'pluginsync',
      value   => $pluginsync_r,
    }
  }
  ini_setting { 'puppet-agent-report':
    setting => 'report',
    value   => 'true',
  }
  ini_setting { 'puppet-agent-classfile':
    setting => 'classfile',
    value   => '$vardir/classes.txt',
  }
  ini_setting { 'puppet-agent-localconfig':
    setting => 'localconfig',
    value   => '$vardir/localconfig',
  }
  ini_setting { 'puppet-main-logdir':
    section => 'main',
    setting => 'logdir',
    value   => '/var/log/puppet',
  }
  ini_setting { 'puppet-main-rundir':
    section => 'main',
    setting => 'rundir',
    value   => '/var/run/puppet',
  }
  ini_setting { 'puppet-main-ssldir':
    section => 'main',
    setting => 'ssldir',
    value   => '$vardir/ssl',
  }

  $server_r = $puppet::server
  if $server_r {
    ini_setting { 'puppet-agent-server':
      setting => 'server',
      value   => $server_r,
    }
  }
}
