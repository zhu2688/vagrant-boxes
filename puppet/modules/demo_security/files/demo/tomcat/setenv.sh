#!/bin/bash

export JAVA_HOME="/usr/lib/jvm/java-waratek/jre"
export JMX_OPTS="-Dcom.waratek.management.jmxremote \
-Dcom.waratek.management.jmxremote.port=1234 \
-Dcom.waratek.management.jmxremote.authenticate=false \
-Dcom.waratek.management.jmxremote.ssl=false \
-Dcom.waratek.jmxhttp.jolokia"

export WARATEK_OPTS="-Dcom.waratek.jvm.name=tomcat7 \
-Dcom.waratek.rules.file=$HOME/demo/jvc.rules \
-Dcom.waratek.log.properties=$HOME/demo/logProps.xml"

export CATALINA_OPTS="-Xmx512M $WARATEK_OPTS $JMX_OPTS"

# WebGoat will write a UserDatabase file to the directory
# specified by the user.dir system property
#
# Changing directory to Tomcat's temp dir will allow us
# to configure a consistent write rule to this dir

cd $CATALINA_HOME/temp

