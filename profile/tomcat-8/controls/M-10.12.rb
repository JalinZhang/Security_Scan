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

control "M-10.12" do
  title "10.12 Force SSL for all applications (Scored)"
  desc  "Use the transport-guarantee attribute to ensure SSL protection when
accessing all applications. This can be overridden to be disabled on a per
application basis in the application configuration. By default, when accessing
applications SSL will be enforced to protect information sent over the network.
By using the transport-guarantee attribute within web.xml, SSL is enforced.
NOTE: This requires SSL to be configured. "
  impact 0.5
  tag "ref": "1. http://www.owasp.org/index.php/Securing_tomcat"
  tag "severity": "medium"
  tag "cis_id": "10.12"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Ensure $CATALINA_HOME/conf/web.xml has the attribute set
to CONFIDENTIAL.
# grep transport-guarantee $CATALINA_HOME/conf/web.xml
"
  tag "fix": "In $CATALINA_HOME/conf/web.xml, set the following:
<user-data-constraint>
<transport-guarantee>CONFIDENTIAL</transport-guarantee>
<user-data-constraint>
"
  tag "Default Value": "By default, this configuration is not present.\n"

  begin
    describe xml(TOMCAT_CONF_WEB) do
      its('web-app/security-constraint/user-data-constraint/transport-guarantee') { should eq ['CONFIDENTIAL'] }
    end
  end
end
