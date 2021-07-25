control "M-7.5" do
  title "7.5 Ensure pattern in context.xml is correct (Scored)"
  desc  "The pattern setting informs Tomcat what information should be logged.
At a minimum, enough information to uniquely identify a request, what was
requested, where the requested originated from, and when the request occurred
should be logged. The following will log the request date and time (%t), the
requested URL (%U), the remote IP address (%a), the local IP address (%A), the
request method (%m), the local port (%p), query string, if present, (%q), and
the HTTP status code of the response (%s). pattern='%t %U %a %A %m %p %q %s”
The level of logging detail prescribed will assist in identifying correlating
security events or incidents. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-7.0-doc/config/valve.html  "
  tag "severity": "medium"
  tag "cis_id": "7.5"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review the pattern settings per application to ensure it
contains all the variables required
by the installation.
# grep pattern context.xml
"
  tag "fix": "Add the following statement into the
$CATALINA_BASE\\webapps\\<app-name>\\METAINF\\context.xml file if it does not
already exist.
<Valve
className='org.apache.catalina.valves.AccessLogValve'
directory='$CATALINA_HOME/logs/'
prefix='access_log' fileDateFormat='yyyy-MM-dd.HH' suffix='.log'
pattern='%h %t %H cookie:%{SESSIONID}c request:%{SESSIONID}r %m %U %s %q %r'
/>
"
  tag "Default Value": "Does not exist by default\n"
end
