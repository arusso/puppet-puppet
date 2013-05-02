# == Class: puppet::master::service
# Controls the puppet master service
# == Dependencies:
# === Variables:
#  $puppet::service
class puppet::master::service {
  # we assume that if this class is included, that the service should be
  # managed

  $service_name_r = 'puppetmaster'
  $service_ensure_r = 'running'
  $service_enable_r = true

  service { $service_name_r:
    ensure    => $service_ensure_r,
    enable    => $service_enable_r,
    subscribe => Class['puppet::agent::service'],
  }
}
