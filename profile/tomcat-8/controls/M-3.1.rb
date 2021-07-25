TOMCAT_HOME= attribute(
  'tomcat_home',
  description: 'location of tomcat home directory',
  default: '/usr/share/tomcat'
)

TOMCAT_SERVICE_NAME= attribute(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  default: 'tomcat'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-3.1" do
  title "3.1 Set a nondeterministic Shutdown command value (Scored)"
  desc  "Tomcat listens on TCP port 8005 to accept shutdown requests. By
connecting to this port and sending the SHUTDOWN command, all applications
within Tomcat are halted. The shutdown port is not exposed to the network as it
is bound to the loopback interface. It is recommended that a nondeterministic
value be set for the shutdown attribute in $CATALINA_HOME/conf/server.xml.
Setting the shutdown attribute to a nondeterministic value will prevent
malicious local users from shutting down Tomcat. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-8.0-doc/config/server.html"
  tag "severity": "medium"
  tag "cis_id": "3.1"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Perform the following to determine if the shutdown port is
configured to use the default
shutdown command: Ensure the shutdown attribute in
$CATALINA_HOME/conf/server.xml is not set to
SHUTDOWN.
$ cd $CATALINA_HOME/conf
$ grep ‘shutdown[[:space:]]*=[[:space:]]*”SHUTDOWN‟’ server.xml
"
  tag "fix": "Perform the following to set a nondeterministic value for the
shutdown attribute. Update the shutdown attribute in
$CATALINA_HOME/conf/server.xml as follows:
<Server port='8005' shutdown='NONDETERMINISTICVALUE'>

Note: NONDETERMINISTICVALUE should be replaced with a sequence of random
characters.
"
  tag "Default Value": "The default value for the shutdown attribute is
SHUTDOWN.\n"

  describe xml("#{TOMCAT_HOME}/conf/server.xml") do
    its('Server/@shutdown') { should_not cmp 'SHUTDOWN' }
  end
end
