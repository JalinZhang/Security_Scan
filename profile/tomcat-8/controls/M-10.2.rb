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

control "M-10.2" do
  title "10.2 Restrict access to the web administration (Not Scored)"
  desc  "Limit access to the web administration application to only those with
a required needed. Limiting access to the least privilege required will ensure
only those people with required need have access to a resource. The web
administration application should be limited to only administrators. "
  impact 0.5
  tag "ref": "1. https://tomcat.apache.org/tomcat-8.0-doc/config/valve.html"
  tag "severity": "medium"
  tag "cis_id": "10.2"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Review $CATALINA_HOME/conf/server.xml to ascertain that
the RemoteAddrValve option
is uncommented and configured to only allow access to systems required to
connect.
"
  tag "fix": "For the administration application, edit
$CATALINA_HOME/conf/server.xml and
uncomment the following:
<Valve className='org.apache.catalina.valves.RemoteAddrValve'
allow='127\\.0\\.0\\.1'/>
Note: The RemoteAddrValve property expects a regular expression, therefore
periods and
other regular expression meta-characters must be escaped.
"
  tag "Default Value": "By default, this configuration is not present.\n"

  begin
    describe xml(TOMCAT_CONF_SERVER) do
      its('Server/Service/Engine/Host/Valve/attribute::className') { should include "org.apache.catalina.valves.RemoteAddrValve" }
      its('Server/Service/Engine/Host/Valve/attribute::allow') { should_not be_empty }
      its('Server/Service/Engine/Host/Valve/attribute::allow') { should_not cmp '' }
    end
  end
end
