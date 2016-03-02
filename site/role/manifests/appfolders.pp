# Creates required application skeleton after tomcat is installed
# Sometimes you have to run this twice because I didn't line up proper
# before and require
class role::appfolders {

  $app_dirs = [ '/opt/apache-tomcat/webapps/puppetlabs', '/opt/apache-tomcat/webapps/puppetlabs/WEB-INF',
                '/opt/apache-tomcat/webapps/puppetlabs/META-INF', '/opt/apache-tomcat/webapps/puppetlabs/WEB-INF/src',
                '/opt/apache-tomcat/webapps/puppetlabs/WEB-INF/classes', '/opt/apache-tomcat/webapps/puppetlabs/WEB-INF/lib']
  file { $app_dirs:
    ensure  => 'directory',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0765',
    before  => File['/opt/apache-tomcat/webapps/puppetlabs/META-INF/context.xml'],
  }

  file {'/opt/apache-tomcat/webapps/puppetlabs/META-INF/context.xml':
    ensure  => 'file',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0765',
    source  => 'puppet:///modules/role/context.xml',
  }

  file {'/opt/apache-tomcat/webapps/puppetlabs/WEB-INF/web.xml':
    ensure  => 'file',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0765',
    source  => 'puppet:///modules/role/web.xml',
  }

  file {'/opt/apache-tomcat/webapps/puppetlabs/query.jsp':
    ensure  => 'file',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0765',
    source  => 'puppet:///modules/role/query.jsp',
  }

  file {'/opt/apache-tomcat/lib/mysql-connector-java-5.1.38-bin.jar':
    ensure  => 'file',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0765',
    source  => 'puppet:///modules/role/mysql-connector-java-5.1.38-bin.jar',
    }
}
