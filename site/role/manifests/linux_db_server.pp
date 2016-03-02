class role::linux_db_server (
  $root_password,
  $admin_user,
  $admin_password,
  ){

  class { '::mysql::server':
    root_password           => $root_password,
    remove_default_accounts => true,
    override_options        => { 'mysqld' => { 'max_connections' => '1024' },
                                 'mysqld' => { 'bind-address' => "${::ipaddress}" }},
  }

  mysql::db { 'employees':
    user      => $admin_user,
    password  => $admin_password,
    host      => "${::fqdn}",
    sql       =>  '/tmp/employees.sql',
    require   => File['/tmp/employees.sql'],
  }

  file { "/tmp/employees.sql":
    ensure  => present,
    source  => "puppet:///modules/role/employees.sql",
  }
}
