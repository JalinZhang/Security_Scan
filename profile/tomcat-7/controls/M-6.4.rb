control "M-6.4" do
  title "6.4 Ensure secure is set to true only for SSL-enabled Connectors
(Scored)"
  desc  "The secure attribute is used to convey Connector security status to
applications operating over the Connector. This is typically achieved by
calling request.isSecure(). Ensure the secure attribute is only set to true for
Connectors operating with the SSLEnabled attribute set to true. Accurately
reporting the security state of the Connector will help ensure that
applications built on Tomcat are not unknowingly relying on security controls
that are not in place. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-7.0-doc/ssl-howto.html 2.
http://tomcat.apache.org/tomcat-7.0-doc/config/http.html  "
  tag "severity": "medium"
  tag "cis_id": "6.4"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review server.xml and ensure the secure attribute is set
to true for those Connectors
having SSLEnabled set to true. Also, ensure the secure attribute set to false
for those
Connectors having SSLEnabled set to false.
"
  tag "fix": "For each Connector defined in server.xml, set the secure
attribute to true for those
Connectors having SSLEnabled set to true. Set the secure attribute set to false
for those
Connectors having SSLEnabled set to false.
<Connector SSLEnabled='true'
…
secure='true'
…
/>
"
  tag "Default Value": "The secure attribute is set to false.\n"
end
