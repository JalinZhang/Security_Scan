control "M-7.1" do
  title "7.1 Application specific logging (Scored)"
  desc  "By default, java.util.logging does not provide the capabilities to
configure per-web application settings, only per VM. In order to overcome this
limitation Tomcat implements JULI as a wrapper for java.util.logging. JULI
provides additional configuration functionality so you can set each web
application with different logging specifications. Establishing per application
logging profiles will help ensure that each application’s logging verbosity is
set to an appropriate level in order to provide appropriate information when
needed for security review. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "7.1"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Ensure a logging.properties file is locate at
$CATALINA_BASE\\webapps\\<app_name>\\WEB-INF\\classes.
"
  tag "fix": "Create a logging.properties file and place that into your
application WEB-INF\\classes
directory. Note: By default, installing Tomcat places a logging.properties file
in
$CATALINA_HOME\\conf. This file can be used as base for an application specific
logging
properties file
"
  tag "Default Value": "By default, per application logging is not
configured.\n\n"
end
