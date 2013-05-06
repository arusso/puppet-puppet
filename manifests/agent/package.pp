# == Class: puppet::agent::package
#
# Installs the puppet agent package
#
class puppet::agent::package {
  $package_r = 'puppet'
  package { $package_r: ensure => installed }
}
