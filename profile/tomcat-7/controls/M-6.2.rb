control "M-6.2" do
  title "6.2 Ensure SSLEnabled is set to True for Sensitive Connectors (Not
Scored)"
  desc  "The SSLEnabled setting determines if SSL is enabled for a specific
Connector. It is recommended that SSL be utilized for any Connector that sends
or receives sensitive information, such as authentication credentials or
personal information. The SSLEnabled setting ensures SSL is active, which will
in-turn ensure the confidentiality and integrity of sensitive information while
in transit. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-7.0-doc/ssl-howto.html 2.
https://tomcat.apache.org/tomcat-7.0-doc/config/http.html  "
  tag "severity": "medium"
  tag "cis_id": "6.2"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review server.xml and ensure all Connectors sending or
receiving sensitive information
have the SSLEnabled attribute set to true.
"
  tag "fix": "In server.xml, set the SSLEnabled attribute to true for each
Connector that sends or
receives sensitive information
<Connector
…
SSLEnabled='true'
…
/>
"
  tag "Default Value": "SSLEnabled is set to false.\n"
end
