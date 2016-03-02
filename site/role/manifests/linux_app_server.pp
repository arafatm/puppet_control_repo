# I am installing from source to show a different way of installing
# instead of standard packages

class role::linux_app_server {

  class { 'tomcat': }
  class { 'java': }
  tomcat::instance { 'app':
    catalina_base => '/opt/apache-tomcat',
    source_url => 'http://apache.mirrors.hoobly.com/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz'
  }->
  tomcat::service { 'default': }
}
