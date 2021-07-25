control "M-7.6" do
  title "7.6 Ensure directory in logging.properties is a secure location
(Scored)"
  desc  "The directory attribute tells Tomcat where to store logs. The
directory value should be a secure location with restricted access. Securing
the log location will help ensure the integrity and confidentiality of web
application activity records. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "7.6"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review the permissions of the directory specified by the
directory setting to ensure the
permissions are o-rwx and owned by tomcat_admin:tomcat:
# grep directory logging.properties
# ls –ld <log_location>
"
  tag "fix": "Perform the following: Add the following properties into your
logging.properties file if they do not exist
<application_name>.org.apache.juli.FileHandler.directory=<log_location>
<application_name>.org.apache.juli.FileHandler.prefix=<application_name> Set
the location pointed to by the directory attribute to be owned by
tomcat_admin:tomcat with permissions of o-rwx.
# chown tomcat_admin:tomcat <log_location>
# chmod o-rwx <log_location>
"
  tag "Default Value": "The directory location is configured to store logs in
$CATALINA_BASE/logs\n\n"
end
