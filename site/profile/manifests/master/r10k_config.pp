class profile::master::r10k_config (
  String  $gms_api_token,
  String  $gms_server_fqdn,
  String  $git_management_system,
  String  $project_name,
  String  $r10k_ssh_key_file,
){

  firewall { '110 webhook allow all': 
    proto  => 'tcp',
    dport  => '8088',
    action => 'accept',
  }
  
  # HACK fix permission error or puppetserver won't come up!
  file { '/etc/puppetlabs/code/environments/production/modules/gms/lib/puppet/provider/gms_webhook/github.rb'
    mode    => '0644',
  }

  # Instead of running via mco, run r10k directly
  class {'r10k::webhook::config':
    use_mcollective => false,
    enable_ssl      => false,
    protected       => false
  }

  # The hook needs to run as root when not running using mcollective
  # It will issue r10k deploy environment <branch_from_gitlab_payload> -p
  # When git pushes happen.
  class {'r10k::webhook':
    use_mcollective => false,
    user            => 'root',
    group           => '0',
    require         => Class['r10k::webhook::config'],
  }

  # Add deploy key and webook to git management system
  if ($git_management_system in ['gitlab', 'github']) and ($gms_api_token != '') {

    git_deploy_key { "add_deploy_key_to_puppet_control-${::fqdn}":
      ensure       => present,
      name         => $::fqdn,
      path         => "${r10k_ssh_key_file}.pub",
      token        => $gms_api_token,
      project_name => $project_name,
      server_url   => "https://${gms_server_fqdn}",
      provider     => $git_management_system,
    }

    git_webhook { "web_post_receive_webhook_payload_${::fqdn}" :
      ensure               => present,
      webhook_url          => "http://${::fqdn}:8088/payload",
      token                => $gms_api_token,
      merge_request_events => false,
      project_name         => $project_name,
      server_url           => "https://${gms_server_fqdn}",
      provider             => $git_management_system,
    }

  }


}
