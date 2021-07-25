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

control "M-7.6" do
  title "7.6 Ensure directory in logging.properties is a secure location
(Scored)"
  desc  "The directory attribute tells Tomcat where to store logs. The
directory value should be a secure location with restricted access. Securing
the log location will help ensure the integrity and confidentiality of web
application activity records. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "7.6"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review the permissions of the directory specified by the
directory setting to ensure the
permissions are o-rwx and owned by tomcat_admin:tomcat:
# grep directory logging.properties
# ls –ld <log_location>
"
  tag "fix": "Perform the following: Add the following properties into your
logging.properties file if they do not exist
<application_name>.org.apache.juli.FileHandler.directory=<log_location>
<application_name>.org.apache.juli.FileHandler.prefix=<application_name> Set
the location pointed to by the directory attribute to be owned by
tomcat_admin:tomcat with permissions of o-rwx.
# chown tomcat_admin:tomcat <log_location>
# chmod o-rwx <log_location>
"
  tag "Default Value": "The directory location is configured to store logs in
$CATALINA_BASE/logs"

  begin
    log_prop = tomcat_properties_file.read_content("#{TOMCAT_HOME}/conf/logging.properties")
    app_dir = command("ls #{TOMCAT_HOME}/webapps").stdout.split
    app_prefix = command("ls #{TOMCAT_HOME}/webapps").stdout.split

    app_dir.each do |app|
      app << ".org.apache.juli.FileHandler.directory"
    end

    app_prefix.each do |app|
      app << ".org.apache.juli.FileHandler.prefix"
    end

    app_dir.each do |app|
        describe log_prop do
          its([app]) { should cmp "${catalina.base}/logs"}
        end
    end

    app_prefix.each do |app|
        describe log_prop do
          its([app]) { should cmp app.strip.split('.')[0] }
        end
    end
  end
end
