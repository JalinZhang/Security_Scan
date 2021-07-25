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

control "M-3.2" do
  title "3.2 Disable the Shutdown port (Not Scored)"
  desc  "Tomcat listens on TCP port 8005 to accept shutdown requests. By
connecting to this port and sending the SHUTDOWN command, all applications
within Tomcat are halted. The shutdown port is not exposed to the network as it
is bound to the loopback interface. If this functionality is not used, it is
recommended that the Shutdown port be disabled. Disabling the Shutdown port
will eliminate the risk of malicious local entities using the shutdown command
to disable the Tomcat server. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-8.0-doc/config/server.html"
  tag "severity": "medium"
  tag "cis_id": "3.2"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Perform the following to determine if the shutdown port
has been disabled: Ensure the port attribute in $CATALINA_HOME/conf/server.xml
is set to -1.
$ cd $CATALINA_HOME/conf/
$ grep '<Server[[:space:]]\\+[^>]*port[[:space:]]*=[[:space:]]*'-1'' server.xml

"
  tag "fix": "Perform the following to disable the Shutdown port. Set the port
to -1 in the $CATALINA_HOME/conf/server.xml file:
<Server port='-1' shutdown='SHUTDOWN'>
"
  tag "Default Value": "The shutdown port is enabled on TCP port 8005, bound to
the loopback address.\n"

  describe xml("#{TOMCAT_HOME}/conf/server.xml") do
    its('Server/@port') { should cmp '-1' }
  end
end
