# == Class: puppet::master::package
#
# Installs the puppet master package
#
class puppet::master::package {
  $package_r = 'puppet-server'
  # we should ensure this gets installed before the puppet agent
  # package, otherwise we wont get a full config.
  $before_r = 'Class[puppet::agent::package]'

  package { $package_r:
    ensure => installed,
    before => $before_r,
  }
}
