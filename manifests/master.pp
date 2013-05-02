# == Class: puppet::master
# Installs an Open Source puppet master
# == Dependencies:
# === Classes:
#  puppet::master::package
#  puppet::master::service
#  puppet::agent::package
#
# === Variables:
#  puppet::modulepath
#  puppet::manifest
#  puppet::dns_alt_names
#  puppet::
class puppet::master {
  # Install our packages and setup our service
  #
  anchor { 'puppet::master::begin':
    before => Class['puppet::master::package'],
    notify => Class['puppet::master::service'],
  }
  include puppet::master::package, puppet::master::service

  # Configure our puppet.conf file
  #
  Ini_setting {
    ensure  => present,
    section => 'master',
    path    => '/etc/puppet/puppet.conf',
    notify  => Class['puppet::master::service'],
    require => Class['puppet::master::package'],
  }

  # Set our manifest file
  #
  if $puppet::manifest {
    validate_absolute_path( $manifest )
    $manifest_r = $manifest }
  else { $manifest_r = '/etc/puppet/manifests/site.pp' }
  ini_setting { 'main-manifest':
    section => 'main',
    setting => 'manifest',
    value   => $manifest_r,
  }

  # Set our modulepath
  #
  if $puppet::modulepath { $modulepath_r = $puppet::modulepath }
  else { $modulepath_r = '/etc/puppet/modules:/opt/puppet/modules' }
  ini_setting { 'main-modulepath':
    section => 'main',
    setting => 'modulepath',
    value   => $modulepath_r,
  }

  # Set our dns_alt_names
  #
  if is_array( $puppet::dns_alt_names ) {
    $dns_alt_names_r = join( $puppet::dns_alt_names, ',' )
  } else {
    $dns_alt_names_r = $puppet::dns_alt_names
  }
  if $dns_alt_names_r {
    ini_setting { 'puppet-master-dns_alt_names':
      setting => 'dns_alt_names',
      value   => $dns_alt_names_r,
    }
  }

  # Set our reports
  #
  if is_array( $puppet::reports ) {
    $reports_r = join ( $puppet::reports , ',' )
  } else {
    $reports_r = $puppet::reports
  }
  if $reports_r {
    ini_setting { 'puppet-master-reports':
      setting => 'reports',
      value   => $reports_r,
    }
  }

  # Set our reportfrom
  #
  $reportfrom_r = $puppet::reportfrom
  if $reportfrom_r {
    ini_setting { 'puppet-master-reportfrom':
      setting => 'reportfrom',
      value   => $reportfrom_r,
    }
  }

  # Set our tagmap
  #
  $tagmap_r = $puppet::tagmap
  if $tagmap_r {
    ini_setting { 'puppet-master-tagmap':
      setting => 'tagmap',
      value   => $tagmap_r,
    }
  }
}
