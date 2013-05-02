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
  $master = undef,
  $modulepath = undef,
  $manifest = undef,
  $service = undef,
  $dns_alt_names = undef,
  $server = undef,
  $reportfrom = undef,
  $sendmail = undef,
  $tagmap = undef,
  $reports = undef
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

  if $master_r {
    include puppet::master
    Class['puppet'] -> Class['puppet::master']
  }
}
