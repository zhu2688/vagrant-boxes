# == Class: demo_security
#
# Full description of class demo_security here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { demo_security:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class demo_security::centos inherits demo_security {

  file { "/home/${demo_user}/demo":
    ensure => "directory",
    owner  => "${demo_user}",
    group  => "${demo_group}",
    mode   => 0755
  }

  file { "/home/${demo_user}/demo/reload_rules.sh":
    ensure => "file",
    owner  => "${demo_user}",
    group  => "${demo_group}",
    mode   => 0755,
    source => "puppet:///modules/demo_security/reload_rules.sh",
  }

  file { "/home/${demo_user}/demo/restart.sh":
    ensure => "file",
    owner  => "${demo_user}",
    group  => "${demo_group}",
    mode   => 0755,
    source => "puppet:///modules/demo_security/restart.sh",
  }

  file { "/home/${demo_user}/demo/jvc.rules":
    ensure => "file",
    owner  => "${demo_user}",
    group  => "${demo_group}",
    mode   => 0644,
    source => "puppet:///modules/demo_security/jvc.rules",
  }

  if ($::vagrant == "true") {
    host { 'kali':
      ip           => "$kali_ip",
      host_aliases => 'kali.localdomain'
    }

    service { 'iptables':
      ensure => false,
      enable => false
    }

    service { 'ip6tables':
      ensure => false,
      enable => false
    }
  }

  exec { 'disable-selinux':
    command => '/usr/sbin/setenforce 0',
    onlyif  => '/usr/bin/test `/usr/sbin/getenforce | /bin/grep Enforcing`'
  }

  augeas { 'disable-selinux':
    context => '/files/etc/selinux/config',
    changes => [
      'set SELINUX permissive'
    ],
  }

  class { '::tomcat':
    user         => "$demo_user",
    group        => "$demo_group",
    manage_user  => false,
    manage_group => false
  }

  anchor { 'demo_security::begin': }     ->
  class  { '::demo_security::httpd': }  ->
  class  { '::demo_security::tomcat6': }  ->
  class  { '::demo_security::tomcat7': }  ->
  class  { '::demo_security::struts2': } ->
  class  { '::demo_security::spiracle': } ->
  class  { '::demo_security::webgoat': } ->
  class  { '::demo_security::jforum': } ->
  anchor { 'demo_security::end': }

}