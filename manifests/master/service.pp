# == Class: puppet::master::service
#
# Controls the puppet master service
#
class puppet::master::service {
  if $caller_module_name != $module_name {
    fail("class ${name} cannot be instantiated outside of ${module_name}")
  }

  service { 'puppetmaster':
    ensure    => 'running',
    enable    => true,
    subscribe => Class[puppet::agent::service],
  }
}
