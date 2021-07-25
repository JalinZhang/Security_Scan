control "M-6.1" do
  title "6.1 Setup Client-cert Authentication (Scored)"
  desc  "Client-cert authentication requires that each client connecting to the
server has a certificate used to authenticate. This is generally regarded as
strong authentication than a password as it requires the client to have the
cert and not just know a password. Certificate based authentication is more
secure than password based authentication. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-7.0-doc/ssl-howto.html 2.
http://tomcat.apache.org/tomcat-7.0-doc/ssl-howto.html  "
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
end
