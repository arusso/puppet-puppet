# == Class: puppet
#
# Manages puppet open source agent and master
#
# === Parameters:
#
# [*dns_alt_names*]
#
# (Master only) DNS Alternative Names to use when generating the Puppet master
# ssl cert
#
# [*manifest*]
#
# The manifest filepath
#
# [*master*]
#
# Should we install the puppet master? Default: false
#
# [*modulepath*]
#
# Array of paths that make up the modulepath.
#
# [*pluginsync*]
#
# (Agent only) Should we enable pluginsync?
#
# [*reports*]
#
# (Master only) Determines which report processors our master will use.
#
# [*reportfrom*]
#
# (Master only) Email address reports will come from if email reports are setup.
#
# [*sendmail*]
#
# (Master only) Location of sendmail binary on the host (needed for tagmap
# reports)
#
# [*server*]
#
# (Agent only) Sets the puppet server name to connect to.
#
# [*service*]
#
# Should we manage the puppet service(s)? Default is true.
#
# [*tagmap*]
#
# (Master only) specifies the location of the tagmap file
#
class puppet (
  $dns_alt_names = undef,
  $manifest = undef,
  $master = undef,
  $modulepath = undef,
  $pluginsync = undef,
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
