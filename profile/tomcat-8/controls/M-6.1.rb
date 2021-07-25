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
  description: 'location of tomcat home directory',
  default: '/usr/share/tomcat'
)

TOMCAT_LOGS= attribute(
  'tomcat_logs',
  description: 'location of tomcat log directory',
  default: '/usr/share/tomcat/logs'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-6.1" do
  title "6.1 Setup Client-cert Authentication (Scored)"
  desc  "Client-cert authentication requires that each client connecting to the
server has a certificate used to authenticate. This is generally regarded as
strong authentication than a password as it requires the client to have the
cert and not just know a password. Certificate based authentication is more
secure than password based authentication. "
  impact 0.5
  tag "ref": "1. https://tomcat.apache.org/tomcat-8.0-doc/config/http.html 2.
http://tomcat.apache.org/tomcat-8.0-doc/ssl-howto.html"
  tag "severity": "medium"
  tag "cis_id": "6.1"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Review the Connector configuration in server.xml and
ensure the clientAuth parameter is
set to true.
"
  tag "fix": "In the Connector element, set the clientAuth parameter to true.
<-- Define a SSL Coyote HTTP/1.1 Connector on port 8443 -->
<Connector
port='8443' minProcessors='5' maxProcessors='75'
enableLookups='true' disableUploadTimeout='true'
acceptCount='100' debug='0' scheme='https' secure='true';
clientAuth='true' sslProtocol='TLS'/>
"
  tag "Default Value": "Not configured\n"

  begin
    tomcat_server = tomcat_server_xml("#{TOMCAT_CONF_SERVER}")

    tomcat_server.params.each do |connector|
      describe connector do
        if connector[:secure] == 'true'
          its([:clientauth]) { should cmp 'true' }
        end
      end
    end
  end
end
