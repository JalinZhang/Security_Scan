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

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-10.9" do
  title "10.9 Do not allow custom header status messages (Scored)"
  desc  "Being able to specify custom status messages opens up the possibility
for additional headers to be injected. If custom header status messages are
required, make sure it is only in US-ASCII and does not include any
user-supplied data. Allowing user-supplied data into a header allows the
possibility of XSS. "
  impact 0.5
  tag "ref": "1.
http://tomcat.apache.org/tomcat-8.0-doc/config/systemprops.html"
  tag "severity": "medium"
  tag "cis_id": "10.9"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Ensure the above parameter is added to the startup script
which by default is located at
$CATALINA_HOME/bin/catalina.sh.
"
  tag "fix": "Start Tomcat with USE_CUSTOM_STATUS_MSG_IN_HEADER set to false.
Add the following
to your startup script.
-Dorg.apache.coyote.USE_CUSTOM_STATUS_MSG_IN_HEADER=false
"
  tag "Default Value": "By default, allowing custom header status messages is
set to false.\n"

  begin
    cat_prop = tomcat_properties_file.read_content("#{TOMCAT_HOME}/conf/catalina.properties")

    describe cat_prop['org.apache.coyote.USE_CUSTOM_STATUS_MSG_IN_HEADER'] do
      it { should cmp 'false' }
    end
  end
end
