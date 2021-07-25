TOMCAT_HOME= attribute(
  'tomcat_home',
  description: 'location of tomcat home directory',
  default: '/usr/share/tomcat'
)

TOMCAT_SERVER_NUMBER= attribute(
  'tomcat_server_number',
  description: 'server.number value',
  default: 'server.number=7.0.76.0'
)

TOMCAT_SERVICE_NAME= attribute(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  default: 'tomcat'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-2.2" do
  title "2.2 Alter the Advertised server.number String (Scored)"
  desc  "The server.number attribute represents the specific version of Tomcat
that is executing. This value is presented to Tomcat clients when connect.
Advertising a valid server version may provide attackers with information
useful for locating vulnerabilities that affect the server platform. Altering
the server version string may make it harder for attackers to determine which
vulnerabilities affect the server platform. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "2.2"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Perform the following to determine if the server.number
value has been changed: Extract the ServerInfo.properties file and examine the
server.number attribute.
$ cd $CATALINA_HOME/lib
$ jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties
$ grep server.number org/apache/catalina/util/ServerInfo.properties
"
  tag "fix": "Perform the following to alter the server version string that
gets displayed when clients
connect to the server. Extract the ServerInfo.properties file from the
catalina.jar file:
$ cd $CATALINA_HOME/lib
$ jar xf catalina.jar org/apache/catalina/util/ServerInfo.properties Navigate
to the util directory that was created
$ cd org/apache/Catalina/util Open ServerInfo.properties in an editor Update
the server.number attribute
server.number=<someversion> Update the catalina.jar with the modified
ServerInfo.properties file.
$ jar uf catalina.jar org/apache/catalina/util/ServerInfo.properties
"
  tag "Default Value": "The default value for the server.number attribute is a
four part version number, such as\n\n5.5.20.0.\n\n"

  describe command("unzip -p #{TOMCAT_HOME}/lib/catalina.jar org/apache/catalina/util/ServerInfo.properties | grep server.number") do
    its('stdout.strip') { should eq "#{TOMCAT_SERVER_NUMBER}" }
  end
end
