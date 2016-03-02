# The `puppetmaster` profile sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class profile::master::puppetserver {
  include 'git'

  # Puppet master firewall rules
  Firewall {
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '110 puppetmaster allow all': dport  => '8140';  }
  firewall { '110 dashboard allow all':    dport  => '443';   }
  firewall { '110 mcollective allow all':  dport  => '61613'; }

  ##################
  # Configure Puppet
  ##################

  class { 'hiera':
    datadir_manage => false,
    datadir        => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
    hierarchy      => [
      'nodes/%{clientcert}',
      'pods/%{pod}',
      'environment/%{environment}',
      'datacenter/%{datacenter}',
      'virtual/%{virtual}',
      'common',
    ],
    eyaml          => true,
  }

  # We cannot simply set notify => Service['pe-puppetserver'] on Class['hiera']
  # because this profile is sometimes used by `puppet apply`, and other times
  # used in combination with pe-provided roles. So instead we'll collect the
  # service and add a subscribe relationship.
  Service <| title == 'pe-puppetserver' |> {
    subscribe +> Class['hiera'],
  }

  # We have to manage this file like this because of ROAD-706
  $key = file('profile/license.key')
  exec { 'Create License':
    command => "/bin/echo \"${key}\" > /etc/puppetlabs/license.key",
    creates => '/etc/puppetlabs/license.key',
  }

  # SET-84 Turn off Dujour / telemetry for demo env for 2015.2
   file { '/etc/puppetlabs/puppetserver/opt-out':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}
