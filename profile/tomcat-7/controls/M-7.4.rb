control "M-7.4" do
  title "7.4 Ensure directory in context.xml is a secure location (Scored)"
  desc  "The directory attribute tells Tomcat where to store logs. It is
recommended that the location pointed to by the directory attribute be secured.
Securing the log location will help ensure the integrity and confidentiality of
web application activity. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "7.4"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review the permissions of the directory specified by the
directory setting to ensure the
permissions are o-rwx and owned by tomcat_admin:tomcat:
# grep directory context.xml
# ls –ld <log location>
"
  tag "fix": "Perform the following: Add the following statement into the
$CATALINA_BASE\\webapps\\<app-name>\\METAINF\\context.xml file if it does not
already exist.
<Valve className='org.apache.catalina.valves.AccessLogValve'
directory='$CATALINA_HOME/logs/'
prefix='access_log' fileDateFormat='yyyy-MM-dd.HH' suffix='.log' pattern='%t %H

cookie:%{SESSIONID}c request:%{SESSIONID}r %m %U %s %q %r'
/> Set the location pointed to by the directory attribute to be owned by
tomcat_admin:tomcat with permissions of o-rwx.
# chown tomcat_admin:tomcat $CATALINA_HOME/logs
# chmod o-rwx $CATALINA_HOME/logs
"
  tag "Default Value": "Does not exist by default\n\n"
end
