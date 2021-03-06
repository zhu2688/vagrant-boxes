class demo_security::splunk_inputs inherits demo_security {

  if defined(Class['splunk']) {

    splunk::input::monitor { "waratek_rules_system":
      path       => "/var/log/javad/*/rules.log",
      sourcetype => "waratek_security"
    }

    splunk::input::monitor { "waratek_rules_user":
      path       => "/home/*/demo/log/rules.log",
      sourcetype => "waratek_security"
    }

    splunk::input::monitor { "apache_access":
      path       => "/var/log/httpd/access_log",
      sourcetype => "access_combined"
    }

    splunk::input::monitor { "tomcat_access":
      path       => "/opt/apache-tomcat/tomcat7/logs/localhost_access_log.*",
      sourcetype => "access_common"
    }

    splunk::input::monitor { "tomcat_catalina":
      path       => "/opt/apache-tomcat/tomcat7/logs/catalina.out",
      sourcetype => "catalina"
    }

  } else {
    notice ("Skipping Splunk configuration")
  }

}
