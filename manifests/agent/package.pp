class puppet::agent::package {
  $package_r = 'puppet'
  package { $package_r: ensure => installed }
}
