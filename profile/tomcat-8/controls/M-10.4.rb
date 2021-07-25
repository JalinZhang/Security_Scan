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
  description: 'location of tomcat home',
  default: '/usr/share/tomcat'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-10.4" do
  title "10.4 Force SSL when accessing the manager application (Scored)"
  desc  "Use the transport-guarantee attribute to ensure SSL protection when
accessing the manager application. By default when accessing the manager
application, login information is sent over the wire in plain text. By using
the transport-guarantee attribute within web.xml, SSL is enforced. NOTE: This
requires SSL to be configured. "
  impact 0.5
  tag "ref": "1. https://www.owasp.org/index.php/Securing_tomcat"
  tag "severity": "medium"
  tag "cis_id": "10.4"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Ensure $CATALINA_HOME/webapps/manager/WEB-INF/web.xml has
the <transportguarantee> attribute set to CONFIDENTIAL.
# grep transport-guarantee $CATALINA_HOME/webapps/manager/WEB-INF/web.xml
"
  tag "fix": "Set $CATALINA_HOME/webapps/manager/WEB-INF/web.xml:
<security-constraint>
<user-data-constraint>
<transport-guarantee>CONFIDENTIAL</transport-guarantee>
<user-data-constraint>
</security-constraint>
"
  tag "Default Value": "By default, this configuration is not present.\n"

  begin
    describe xml('/usr/share/tomcat/webapps/manager/WEB-INF/web.xml') do
      its('web-app/security-constraint/user-data-constraint/transport-guarantee') { should eq ['CONFIDENTIAL'] }
    end
  end
end
