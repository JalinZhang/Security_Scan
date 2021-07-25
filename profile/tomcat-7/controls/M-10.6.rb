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

control "M-10.6" do
  title "10.6 Enable strict servlet Compliance (Scored)"
  desc  "The STRICT_SERVLET_COMPLIANCE influences Tomcat’s behavior in several
subtle ways. See the References below for the complete list. It is recommended
that STRICT_SERVLET_COMPLIANCE be set to true. When STRICT_SERVLET_COMPLIANCE
is set to true, Tomcat will always send an HTTP Content-type header when
responding to requests. This is significant as the behavior of web browsers is
inconsistent in the absence of the Content-type header. Some browsers will
attempt to determine the appropriate content-type by sniffing "
  impact 0.5
  tag "ref": "1.
http://tomcat.apache.org/tomcat-7.0-doc/config/systemprops.html "
  tag "severity": "medium"
  tag "cis_id": "10.6"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Ensure the above parameter is added to the startup script
which by default is located at
$CATALINA_HOME\\bin\\catalina.sh.
"
  tag "fix": "Start Tomcat with strict compliance enabled. Add the following to
your startup script.
-Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true
"
  tag "Default Value": "By default, this configuration parameter is not
present.\n"

  begin
    describe parse_config_file('/usr/share/tomcat/conf/catalina.properties') do
      its('org.apache.catalina.STRICT_SERVLET_COMPLIANCE') { should eq 'true' }
    end
  end
end
