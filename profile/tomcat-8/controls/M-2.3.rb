TOMCAT_HOME= attribute(
  'tomcat_home',
  description: 'location of tomcat home directory',
  default: '/usr/share/tomcat'
)

TOMCAT_SERVER_BUILT= attribute(
  'tomcat_server_built',
  description: 'server.built value',
  default: 'server.built=Oct 30 2017 10:21:55 UTC'
)

TOMCAT_SERVICE_NAME= attribute(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  default: 'tomcat'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-2.3" do
  title "2.3 Alter the Advertised server.built Date (Scored)"
  desc  "The server.built date represents the date which Tomcat was compiled
and packaged. This value is presented to Tomcat clients when clients connect to
the server. Altering the server.built string may make it harder for attackers
to fingerprint which vulnerabilities affect the server platform. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "2.3"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Perform the following to determine if the server.built
value has been changed: Extract the ServerInfo.properties file and examine the
server.built attribute.
$ cd $CATALINA_HOME/lib
$ jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties
$ grep server.built org/apache/catalina/util/ServerInfo.properties
"
  tag "fix": "Perform the following to alter the server version string that
gets displayed when clients
connect to the server. Extract the ServerInfo.properties file from the
catalina.jar file:
$ cd $CATALINA_HOME/lib
$ jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties Navigate
to the util directory that was created
$ cd org/apache/Catalina/util Open ServerInfo.properties in an editor Update
the server.built attribute in the ServerInfo.properties file.
server.built= Update the catalina.jar with the modified ServerInfo.properties
file.
$ jar uf catalina.jar org/apache/catalina/util/ServerInfo.properties

"
  tag "Default Value": "The default value for the server.built attribute is
build date and time. For example, Jul 8\n2008 11:40:35."

  describe command("unzip -p #{TOMCAT_HOME}/lib/catalina.jar org/apache/catalina/util/ServerInfo.properties | grep server.built") do
    its('stdout.strip') { should eq "#{TOMCAT_SERVER_BUILT}" }
  end
end
