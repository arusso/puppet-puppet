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
  $autosign = '',
  $basemodulepath = '',
  $default_manifest = '',
  $dns_alt_names = '',
  $environmentpath = '',
  $hiera_config = '',
  $manifest = '',
  $master = false,
  $modulepath = '',
  $reports = '',
  $reportfrom = '',
  $sendmail = '',
  $server = '',
  $tagmap = undef
) {
  # Agent installer
  include puppet::agent
  Class['puppet'] -> Class['puppet::agent']

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0440',
    owner   => 'root',
    group   => 'puppet',
    content => "[main]\n[agent]",
    replace => false,
  }

  if any2bool($master) {
    include puppet::master
    Class['puppet'] -> Class['puppet::master']
  }
}
