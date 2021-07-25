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

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-10.19" do
  title "10.19 Setting Security Lifecycle Listener (Scored)"
  desc  "The Security Lifecycle Listener performs a number of security checks
when Tomcat starts and prevents Tomcat from starting if they fail. Enable the
Security Lifecycle Listener canEnforce a blacklist of OS users that must not be
used to start Tomcat. set the least restrictive umask before Tomcat start "
  impact 0.5
  tag "ref": "1.
https://tomcat.apache.org/tomcat-7.0doc/config/listeners.html#Security_Lifecycle_Listener__org.apache.catalina.security.SecurityListener
"
  tag "severity": "medium"
  tag "cis_id": "10.19"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review server.xml to ensure the Security Lifecycle
Listener element is uncommented and
checkedOsUsers, minimumUmask attributes are set with expected value.
"
  tag "fix": "To enabled it uncomment the listener in
$CATALINA_BASE/conf/server.xml. If the
operating system supports umask then the line in $CATALINA_HOME/bin/catalina.sh
that
obtains the umask also needs to be uncommented.
Within Server elements add:checkedOsUsers: A comma separated list of OS users
that must not be used to start
Tomcat. If not specified, the default value of root is used.
minimumUmask: The least restrictive umask that must be configured before Tomcat

will start. If not specified, the default value of 0007 is used.
<Listener className='org.apache.catalina.security.SecurityListener'
checkedOsUsers='alex,bob' minimumUmask='0007' />
"
  tag "Default Value": "The Security Lifecycle Listener is not enabled by
default. For checkedOsUsers, If not\nspecified, the default value of root is
used. For minimumUmask, if not specified, the default\nvalue of 0007 is used.\n"

  begin
    describe xml(TOMCAT_CONF_SERVER) do
      its('Server/Listener/attribute::className') { should include 'org.apache.catalina.security.SecurityListener' }
      its('Server/Listener/attribute::checkedOsUsers') { should include 'root' }
      its('Server/Listener/attribute::minimumUmask') { should cmp <= '0007' }
    end
  end
end
