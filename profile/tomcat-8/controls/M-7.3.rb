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

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end


control "M-7.3" do
  title "7.3 Ensure className is set correctly in context.xml (Scored)"
  desc  "Ensure the className attribute is set to AccessLogValve. The className
attribute determines the access log valve to be used for logging. Some log
valves are not suited for production and should not be used. Apache recommends
org.apache.catalina.valves.AccessLogValve "
  impact 0.5
  tag "ref": "1. https://tomcat.apache.org/tomcat-8.0-doc/config/valve.html"
  tag "severity": "medium"
  tag "cis_id": "7.3"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Execute the following to ensure className is set properly:

# grep org.apache.catalina.valves.AccessLogValve $CATALINA_BASE\\webapps\\<app

name>\\META-INF\\context.xml
"
  tag "fix": "Add the following statement into the
$CATALINA_BASE\\webapps\\<app name>\\METAINF\\context.xml file if it does not
already exist.
<Valve
className='org.apache.catalina.valves.AccessLogValve'
directory='$CATALINA_HOME/logs/'
prefix='access_log'
fileDateFormat='yyyy-MM-dd.HH'
suffix='.log'
pattern='%t %H cookie:%{SESSIONID}c request:%{SESSIONID}r %m %U %s %q %r'
/>
"
  tag "Default Value": "Does not exist by default.\n"

  begin
    context_xml = command("ls #{TOMCAT_HOME}/webapps/*/META-INF/context.xml").stdout.split.each do |web_file|
      describe xml(web_file) do
        its('Context/Valve/attribute::className') { should include "org.apache.catalina.valves.AccessLogValve" }
        its('Context/Valve/attribute::directory') { should cmp '$CATALINA_HOME/logs/' }
        its('Context/Valve/attribute::prefix') { should cmp 'access_log' }
        its('Context/Valve/attribute::fileDateFormat') { should cmp 'yyyy-MM-dd.HH' }
        its('Context/Valve/attribute::suffix') { should cmp '.log' }
        its('Context/Valve/attribute::pattern') { should cmp '%h %t %H cookie:%{SESSIONID}c request:%{SESSIONID}r %m %U %s %q %r' }
      end
    end
  end
end
