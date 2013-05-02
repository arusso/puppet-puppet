class puppet::agent::service (
  $ensure = undef,
  $enable = undef
) {

  if $::puppet_agent_ensure {
    $ensure_r = $::puppet_agent_ensure
    validate_re( $ensure_r, '(running|stopped)' )
  } else {
    $ensure_r = $ensure ? {
      undef   => 'running',
      default => $ensure,
    }
    validate_re( $ensure_r, '(running|stopped)' )
  }

  if $::puppet_agent_enable {
    $enable_r = any2bool($::puppet_agent_enable)
    validate_bool( $enable_r )
  } else {
    $enable_r = $enable ? {
      undef   => true,
      default => any2bool($enable),
    }
    validate_bool( $enable_r )
  }

  $service_r = $::is_pe ? {
    undef    => 'puppet',
    /false|/ => 'puppet',
    default  => 'pe-puppet',
  }

  service { $service_r:
    ensure => $ensure_r,
    enable => $enable_r,
  }
}
