# == Class: puppet
#
# Manages puppet open source agent and master
#
# === Parameters:
#
# [*master*]
#
# Should we install the master? Default is false.
#
# [*service*]
#
# Should we manage the puppet service(s)? Default is true.
#
# [*manifest*]
#
# Location to manifest file.  Only effective on masters
#
# [*modulepath*]
#
# Array or colon-separated list of paths where puppet should search for
# modules.
#
class puppet (
  $dns_alt_names = undef,
  $manifest = undef,
  $master = undef,
  $modulepath = undef,
  pluginsync = undef,
  $reports = undef,
  $reportfrom = undef,
  $sendmail = undef,
  $server = undef,
  $service = undef,
  $tagmap = undef
) {
  # Agent installer
  include puppet::agent
  Class['puppet'] -> Class['puppet::agent']

  # Master installer
  $master_r = $master ? {
    undef   => false,
    default => any2bool($master)
  }
  validate_bool( $master_r )

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0440',
    owner   => 'root',
    group   => 'puppet',
    content => "[main]\n[agent]",
    replace => false,
  }

  if $master_r {
    include puppet::master
    Class['puppet'] -> Class['puppet::master']
  }
}
