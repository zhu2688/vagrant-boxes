class oracle_xe ( $version ) {

    $swapfile = "/var/swapfile.xe"

    # Create swapfile on EC2
    if ($ec2_ami_id) {
        exec { "create-swapfile":
            command => "/bin/dd if=/dev/zero of=${swapfile} bs=1M count=2560",
            creates => "${swapfile}",
            notify  => Exec["enable-swap"]
        }

        exec { "enable-swap":
            command     => "/sbin/mkswap ${swapfile} && /sbin/swapon ${swapfile}",
            unless      => "/sbin/swapon -s | /bin/grep ${swapfile}",
            before      => Exec["install-oracle-xe"],
            require     => Exec["create-swapfile"]
        }
    }

    exec { "install-oracle-xe":
        command  => "/bin/rpm -i /vagrant/synced_folder/oracle-xe-${version}.x86_64.rpm || /bin/rpm -i http://rpm/vagrant/oracle-xe-${version}.x86_64.rpm",
        creates  => "/etc/init.d/oracle-xe",
    }

    file { "/root/xe.rsp":
        ensure   => "present",
        source   => "puppet:///modules/oracle_xe/xe.rsp",
        owner    => "root",
        group    => "root",
        mode     => "0600"
    }

    exec { "oracle-xe-configure":
        command  => "/etc/init.d/oracle-xe configure responseFile=/root/xe.rsp",
        creates  => "/etc/sysconfig/oracle-xe",
        require  => [ Exec [ "install-oracle-xe"], File [ "/root/xe.rsp"] ]
    }

    file { "/etc/profile.d/oracle-xe.sh":
        ensure => 'file',
        owner  => "root",
        group  => "root",
        mode   => '0644',
        source => 'puppet:///modules/oracle_xe/etc/profile.d/oracle-xe.sh',
    }

}
