# == Class: puppet::util::pluginsync
#
# For an initial --pluginsync run, if not already installed
#
class puppet::util::pluginsync (
  $change_state = false
) {
  file { '/usr/local/sbin/puppet_setup_pluginsync':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0550',
    source => 'puppet:///modules/puppet/puppet_setup_pluginsync',
  }


  $rc = $change_state ? {
    true    => '1',
    default => '2',
  }

  # Only install it if it hasn't been configured.
  $onlyif_cmnd = [ '/bin/sh /usr/local/sbin/puppet_setup_pluginsync',
                    "/usr/bin/test $? -ge ${rc}" ]
  exec { 'setup-pluginsync':
    command => '/usr/local/sbin/puppet_setup_pluginsync u',
    onlyif  => join( $onlyif_cmnd, '; ' ),
    require => [ Class['puppet'],
                  File['/usr/local/sbin/puppet_setup_pluginsync'] ],
  }
}
