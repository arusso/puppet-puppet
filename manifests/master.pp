# == Class: puppet::master
#
# Installs an Open Source puppet master
#
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

  # cleanup settings out of main. we'll put it into the master config
  ini_setting {
    'puppet-main-modulepath':
      ensure  => 'absent',
      section => 'main',
      setting => 'modulepath';

    'puppet-main-manifest':
      ensure  =>  'absent',
      section => 'main',
      setting => 'manifest';
  }

  # configure manifest directive
  ini_setting { 'puppet-master-manifest':
    ensure  => ter($puppet::manifest,'',absent,present),
    setting => 'manifest',
    value   => $puppet::manifest,
  }

  # configure modulepath directive
  ini_setting { 'puppet-master-modulepath':
    ensure  => ter($puppet::modulepath,'',absent,present),
    setting => 'modulepath',
    value   => $puppet::modulepath,
  }

  # configure dns_alt_names directive
  $dns_alt_names = is_array($puppet::dns_alt_names) ? {
    true  => join($puppet::dns_alt_names,','),
    false => $puppet::dns_alt_names,
  }
  ini_setting { 'puppet-master-dns_alt_names':
    ensure  => ter($dns_alt_names,'',absent,present),
    setting => 'dns_alt_names',
    value   => $dns_alt_names,
  }

  # configure our reports directive
  $reports = is_array( $puppet::reports ) ? {
    true  => join($puppet::reports,','),
    false => $reports,
  }
  ini_setting { 'puppet-master-reports':
    ensure  => ter($reports,'',absent,present),
    setting => 'reports',
    value   => $reports,
  }

  # configure our reportfrom directive
  ini_setting { 'puppet-master-reportfrom':
    ensure  => ter($puppet::reportfrom,'',absent,present),
    setting => 'reportfrom',
    value   => $puppet::reportfrom,
  }

  # configure our tagmap directive
  ini_setting { 'puppet-master-tagmap':
    ensure  => ter($puppet::tagmap,'',absent,present),
    setting => 'tagmap',
    value   => $puppet::tagmap,
  }

  ini_setting { 'puppet-master-default_manifest':
    ensure  => ter($puppet::default_manifest,'',absent,present),
    setting => 'default_manifest',
    value   => $puppet::default_manifest,
  }

  ini_setting { 'puppet-master-basemodulepath':
    ensure  => ter($puppet::basemodulepath,'',absent,present),
    setting => 'basemodulepath',
    value   => $puppet::basemodulepath,
  }

  ini_setting { 'puppet-master-hiera_config':
    ensure  => ter($puppet::hiera_config,'',absent,present),
    setting => 'hiera_config',
    value   => $puppet::hiera_config,
  }

  ini_setting { 'puppet-master-environmentpath':
    ensure  => ter($puppet::environmentpath,'',absent,present),
    setting => 'environmentpath',
    value   => $puppet::environmentpath,
  }

  ini_setting { 'puppet-master-autosign':
    ensure  => ter($puppet::autosign,'',absent,present),
    setting => 'autosign',
    value   => $puppet::autosign,
  }
}
