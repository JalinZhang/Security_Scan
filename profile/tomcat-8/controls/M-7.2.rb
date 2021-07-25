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

control "M-7.2" do
  title "7.2 Specify file handler in logging.properties files (Scored)"
  desc  "Handlers specify where log messages are sent. Console handlers send
log messages to the Java console and File handlers specify logging to a file.
Utilizing file handlers will ensure that security event information is
persisted to disk. "
  impact 0.5
  tag "ref": "1. https://tomcat.apache.org/tomcat-8.0-doc/logging.html"
  tag "severity": "medium"
  tag "cis_id": "7.2"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review each application’s logging.properties file located
in the applications
$CATALINA_BASE\\webapps\\<app name>\\WEB-INF\\classes directory and determine
if the
file handler properties are set.
$ grep handlers \\
$CATALINA_BASE\\webapps\\<app name>\\WEB-INF\\classes\\logging.properties
In the instance where an application specific logging has not been created, the

logging.properties file will be located in $CATALINA_BASE\\conf
$ grep handlers $CATALINA_BASE\\conf\\logging.properties
"
  tag "fix": "Add the following entries to your logging.properties file if they
do not exist.
handlers=org.apache.juli.FileHandler, java.util.logging.ConsoleHandler
Ensure logging is not off and set the logging level to the desired level such
as:
org.apache.juli.FileHandler.level=FINEST
"
  tag "Default Value": "No value for new applications by default.\n"

  begin
    log_prop = tomcat_properties_file.read_content("#{TOMCAT_HOME}/conf/logging.properties")

    describe log_prop do
      its(['handlers']) { should include 'org.apache.juli.FileHandler' }
      its(['handlers']) { should include 'java.util.logging.ConsoleHandler' }
      its(['org.apache.juli.FileHandler.level']) { should cmp 'FINEST' }
    end
  end
end
