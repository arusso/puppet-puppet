# puppet Module #

This module provides mechanisms to manage your puppet agent and master 

# Examples #

<pre><code>
  class { 'puppet':
    dns_alt_names => [ 'pm.lan', 'pm', 'puppet', 'puppet.lan' ],
    manifest      => '/etc/puppet/manifests/site.pp',
    master        => true,
    modulepath    => [ '/etc/puppet/modules' ],
    pluginsync    => true,
    reports       => [ 'tagmail', 'rrdgraph', 'store' ],
    sendmail      => '/usr/sbin/sendmail',
    reportfrom    => 'puppet@pm.lan',
  }

  # on agents, this could be useful -- sets up pluginsync without needing any
  # modules
  include puppet::util::pluginsync
</code></pre>
 

License
-------

None

Change Log
----------

* 0.0.1 : Initial Release

Contact
-------

Aaron Russo <arusso@berkeley.edu>

Support
-------

Please log tickets and issues at the
[Projects site](https://github.com/arusso23/puppet-puppet/issues/)
