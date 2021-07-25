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

control "M-6.5" do
  title "6.5 Ensure SSL Protocol is set to TLS for Secure Connectors (Scored)"
  desc  "The sslProtocol setting determines which protocol Tomcat will use to
protect traffic. It is recommended that sslProtocol attribute be set to TLS.
The TLS protocol does not contain weaknesses that affect other secure transport
protocols, such as SSLv1 or SSLv2. Therefore, TLS is leveraged to protect the
confidentiality and integrity of data while in transit. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-8.0-doc/ssl-howto.html 2.
http://tomcat.apache.org/tomcat-8.0-doc/config/http.html"
  tag "severity": "medium"
  tag "cis_id": "6.5"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review server.xml to ensure the sslProtocol attribute is
set to TLS for all Connectors having
SSLEngine set to on.
"
  tag "fix": "In server.xml, set the sslProtocol attribute to 'TLS' for
Connectors having SSLEnabled set
to true.
<Connector
…
sslProtocol='TLS'
…
/>
"
  tag "Default Value": "If not specified, the default value of \"TLS\" will be
used.\n"

  begin
    tomcat_server = tomcat_server_xml("#{TOMCAT_CONF_SERVER}")

    tomcat_server.params.each do |connector|
      describe connector do
        if connector[:sslenable] == "true"
          its([:sslprotocol]) { should cmp 'TLS' }
        end
      end
    end
  end
end
