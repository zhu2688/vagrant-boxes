# == Class: waratek
#
# Full description of class waratek here.
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
#  class { waratek:
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
class waratek::install inherits waratek {

  if ($install_format == "tgz") {
    package { 'acl':
      ensure  => 'installed'
    } ->

    staging::deploy { "waratek_release_${version}_package.tar.gz":
      source => "$tgz_source",
      target => '/opt'
    } ~>

    exec { "chown-waratek":
      command     => "/bin/chown -R root:root /opt/waratek*",
      refreshonly => true
    }

  }

  if ($install_format == "rpm") {
    package { 'acl':
      ensure  => 'installed'
    } ->

    exec { 'import-gpg-key':
      command => '/bin/rpm --import http://download.waratek.com/keys/107183FC.txt?src=vagrant',
      unless  => '/bin/rpm -q gpg-pubkey-107183fc'
    } ->

    package { "$package_name":
      ensure   => $package_ensure,
      provider => 'rpm',
      source   => $real_package_source
    } ~>

    exec { 'alternatives-java':
      command     => $alternatives_command,
      refreshonly => true
    }
  }

}
