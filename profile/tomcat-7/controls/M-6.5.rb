control "M-6.5" do
  title "6.5 Ensure SSL Protocol is set to TLS for Secure Connectors (Scored)"
  desc  "The sslProtocol setting determines which protocol Tomcat will use to
protect traffic. It is recommended that sslProtocol attribute be set to TLS.
The TLS protocol does not contain weaknesses that affect other secure transport
protocols, such as SSLv1 or SSLv2. Therefore, TLS is leveraged to protect the
confidentiality and integrity of data while in transit. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-7.0-doc/ssl-howto.html 2.
http://tomcat.apache.org/tomcat-7.0-doc/config/http.html  "
  tag "severity": "medium"
  tag "cis_id": "6.5"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review server.xml to ensure the sslProtocol attribute is
set to TLS for all Connectors having
SSLEngine set to on.
"
  tag "fix": "In server.xml, set the sslProtocol attribute to TLS for all
Connectors having SSLEngine set to
on.
<Connector
…
sslProtocol='TLS'
…
/>
"
  tag "Default Value": "If the sslProtocol attribute is not set, Tomcat will
utilize TLS.\n"
end
