# == Class: puppet
#
# Manages puppet open source agent and master
#
# === Parameters:
#
# [*bucketdir*]
#   (optional) path where bucket files are stored.
#
#  Default: $vardir/bucket
#
# [*ca*]
#   (optional) true/false - sets ca = $ca in the [master] section.
#
# [*ca_name*]
#   (optional) the name of the Puppet CA server
#
# [*ca_port*]
#   (optional) the port the Puppet CA will be listening on
#
#   Default: $masterport
#
# [*ca_server*]
#   (optional) if set, points the agent to a central ca_server
#
#  Default: $server
#
# [*ca_ttl*]
#   (optional) the TTL for new certificates.
#
#   Default: 5y
#
# [*cacert*]
#   (optional) the location of the ca certificate.
#
#   Default: $cadir/ca_crt.pem
#
# [*cacrl*]
#   (optional) the ca revocation list for the CA. Used if present, otherwise
#   ignored.
#
#   Default: $cadir/ca_crl.pem
#
# [*cadir*]
#  (optional) the root directory for the certificate authority
#
#  Default: $ssldir/ca
#
# [*dns_alt_names*]
#   (Master only) DNS Alternative Names to use when generating the Puppet
#   master ssl cert
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
# Awesomeness:
#
# s/\$\([a-z_]\+\)\(\s\+=hiera('puppet::\1',\ \)'UNSET'\(),\)/
#                                                    $\1\2$puppet::param::\1\3/
class puppet (
  $agent                  =hiera('puppet::agent', 'UNSET'),
  $allow_duplicate_certs  =hiera('puppet::allow_duplicate_certs', 'UNSET'),
  $archive_file_server    =hiera('puppet::archive_file_server', 'UNSET'),
  $archive_files          =hiera('puppet::archive_files', 'UNSET'),
  $bindaddress            =hiera('puppet::bindaddress', 'UNSET'),
  $bucketdir              =hiera('puppet::bucketdir', 'UNSET'),
  $ca                     =hiera('puppet::ca', 'UNSET'),
  $ca_name                =hiera('puppet::ca_name', 'UNSET'),
  $ca_port                =hiera('puppet::ca_port', 'UNSET'),
  $ca_server              =hiera('puppet::ca_server', 'UNSET'),
  $ca_ttl                 =hiera('puppet::ca_ttl', 'UNSET'),
  $cacert                 =hiera('puppet::cacert', 'UNSET'),
  $cacrl                  =hiera('puppet::cacrl', 'UNSET'),
  $cadir                  =hiera('puppet::cadir', 'UNSET'),
  $cakey                  =hiera('puppet::cakey', 'UNSET'),
  $capass                 =hiera('puppet::capass', 'UNSET'),
  $caprivatedir           =hiera('puppet::caprivatedir', 'UNSET'),
  $capub                  =hiera('puppet::capub', 'UNSET'),
  $cert_inventory         =hiera('puppet::cert_inventory', 'UNSET'),
  $certdir                =hiera('puppet::certdir', 'UNSET'),
  $certificate_revocation =hiera('puppet::certificate_revocation', 'UNSET'),
  $certname               =hiera('puppet::certname', 'UNSET'),
  $classfile              =hiera('puppet::classfile',
                                  $puppet::param::classfile),
  $confdir                =hiera('puppet::confdir', 'UNSET'),
  $config                 =hiera('puppet::config', $puppet::param::config),
  $dns_alt_names          =hiera('puppet::dns_alt_names', 'UNSET'),
  $environment            =hiera('puppet::environment', 'UNSET'),
  $localconfig            =hiera('puppet::localconfig',
                                  $puppet::param::localconfig),
  $logdir                 =hiera('puppet::logdir', $puppet::param::logdir),
  $master                 =hiera('puppet::master', 'UNSET'),
  $manifest               =hiera('puppet::manifest', 'UNSET'),
  $manage_service         =hiera('puppet::manage_service', 'UNSET'),
  $module_repository      =hiera('puppet::module_respository', 'UNSET'),
  $module_working_dir     =hiera('puppet::module_working_dir', 'UNSET'),
  $modulepath             =hiera('puppet::modulepath', 'UNSET'),
  $postrun_command        =hiera('puppet::postrun_command', 'UNSET'),
  $pluginsync             =hiera('puppet::pluginsync', 'UNSET'),
  $prerun_command         =hiera('puppet::prerun_command', 'UNSET'),
  $report                 =hiera('puppet::report', $puppet::param::report),
  $report_server          =hiera('puppet::report_server', 'UNSET'),
  $reportfrom             =hiera('puppet::reportfrom', 'UNSET'),
  $reports                =hiera('puppet::reports', 'UNSET'),
  $reporturl              =hiera('puppet::reporturl', 'UNSET'),
  $rundir                 =hiera('puppet::rundir', $puppet::param::rundir),
  $sendmail               =hiera('puppet::sendmail', 'UNSET'),
  $ssldir                 =hiera('puppet::ssldir', $puppet::param::ssldir),
  $server                 =hiera('puppet::server', 'UNSET'),
  $tagmap                 =hiera('puppet::tagmap', 'UNSET'),
) inherits puppet::param {

  Ini_setting{
    ensure            => present,
    path              => $config,
    section           => 'main',
    key_val_separator => ' = ',
  }

  $req_main_settings = {
    'logdir' => { setting => 'logdir',
                  value   => $logdir, },

    'rundir' => { setting => 'rundir',
                  value   => $rundir, },

    'ssldir' => { setting => 'ssldir',
                  value   => $ssldir, },
  }
  create_resources( 'ini_setting', $req_main_settings )


  if $agent {
    class { 'puppet::agent':
      ca_port     => $ca_port,
      ca_server   => $ca_server,
      classfile   => $classfile,
      report      => $report,
      localconfig => $localconfig,
    }
  }

  if $master {
    class { 'puppet::master':
      dns_alt_names => $dns_alt_names,

    }
  }

  # Master installer
  $master_r = $master ? {
    undef   => false,
    default => any2bool($master)
  }
  validate_bool( $master_r )

  file { '/etc/puppet/puppet.conf':
    ensure  => present,
    mode    => '0440',
    owner   => 'root',
    group   => 'puppet',
    content => "[main]\n[agent]",
    replace => false,
  }

  if $master_r {
    include puppet::master
    Class['puppet'] -> Class['puppet::master']
  }
}
