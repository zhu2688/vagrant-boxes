class waratek::demo_security() {

    class { "waratek": }
    
    class { "waratek::cloudvm-rpm":
        version => "2.6.5.GA.2.JAS-104"
    }

    class { "sqlmap": }

    class { "oracle_xe":
        version => "11.2.0-1.0",
    }

    service { "oracle-xe":
        ensure    => "running",
        enable    => "true",
        hasstatus => "false",
        pattern   => "tnslsnr"
    }

    class { "tomcat":
        tomcat_version => "7.0.54"
    }

    tomcat::tomcat_instance { "tomcat1":
        base_dir => "/home/vagrant/tomcat",
        port     => "8080",
        owner    => "vagrant",
        group    => "vagrant"
    }

    file { "/home/${vagrantuser}/demo":
        ensure => "directory",
        owner  => "${vagrantuser}",
        group  => "${vagrantuser}",
        mode   => 0755
    }

    file { "/home/${vagrantuser}/demo/restart.sh":
        ensure => "file",
        owner  => "${vagrantuser}",
        group  => "${vagrantuser}",
        mode   => 0755,
        source => "puppet:///modules/waratek/demo/restart.sh",
    }

    file { "/home/${vagrantuser}/demo/rules.jaf":
        ensure => "file",
        owner  => "${vagrantuser}",
        group  => "${vagrantuser}",
        mode   => 0664,
        source => "puppet:///modules/waratek/demo/rules.jaf",
    }


}
