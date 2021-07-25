TOMCAT_SERVICE_NAME= attribute(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  default: 'tomcat'
)

TOMCAT_CONF_SERVER= attribute(
  'tomcat_conf_server',
  description: 'Path to tomcat server.xml',
  default: '/usr/share/tomcat/conf/server.xml'
)

TOMCAT_APP_DIR= attribute(
  'tomcat_app_dir',
  description: 'location of tomcat app directory',
  default: '/var/lib/tomcat'
)

TOMCAT_CONF_WEB= attribute(
  'tomcat_conf_web',
  description: 'location of tomcat web.xml',
  default: '/usr/share/tomcat/conf/web.xml'
)

TOMCAT_HOME= attribute(
  'tomcat_home',
  description: 'location of tomcat home directory',
  default: '/usr/share/tomcat'
)

TOMCAT_LOGS= attribute(
  'tomcat_logs',
  description: 'location of tomcat log directory',
  default: '/usr/share/tomcat/logs'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

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
  tag "Default Value": "By default, per application logging is not configured."

  begin
    apps = command("ls #{TOMCAT_HOME}/webapps/").stdout.split
    ignore = ['docs', 'examples', 'host-manager', 'manager', 'ROOT']

    ignore.each do |x|
      if apps.include?(x)
        apps.delete(x)
      end
    end

    apps.each do |app|
      describe command("ls #{TOMCAT_HOME}/webapps/#{app}/WEB-INF/classes/logging.properties") do
        its('stdout') { should_not eq "" }
      end
    end
  end
end
