define puppet::master::environment (
  $manifest = undef,
  $modulepath = undef
) {
  # Make sure we've already installed our master before setting up the
  # environment
  Class['puppet::master'] -> Puppet::Master::Environment[$name]
  validate_re( $name, '^[a-z]+$' )

  # Allow both array and string module paths
  if is_array( $modulepath ) { $modulepath_r = join( $modulepath, ':' ) }
  else { $modulepath_r = $modulepath }

  Ini_setting {
    path    => '/etc/puppet/puppet.conf',
    ensure  => present,
    section => $name,
    require => Class['puppet::master::package'],
    notify  => Class['puppet::master::service'],
  }

  if $manifest {
    ini_setting { "puppet-master-env-${name}-manifest":
      setting => 'manifest',
      value   => $manifest,
    }
  }

  if $modulepath {
    ini_setting { "puppet-master-env-${name}-modulepath":
      setting => 'modulepath',
      value   => $modulepath_r,
    }
  }
}
