TOMCAT_HOME= attribute(
  'tomcat_home',
  description: 'location of tomcat home directory',
  default: '/usr/share/tomcat'
)

TOMCAT_SERVICE_NAME= attribute(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  default: 'tomcat'
)

TOMCAT_GROUP= attribute(
  'tomcat_group',
  description: 'group owner of files/directories',
  default: 'tomcat'
)

TOMCAT_OWNER= attribute(
  'tomcat_owner',
  description: 'user owner of files/directories',
  default: 'tomcat_admin'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-4.4" do
  title "4.4 Restrict access to Tomcat logs directory (Scored)"
  desc  "The Tomcat $CATALINA_HOME/logs/ directory contains Tomcat logs. It is
recommended that the ownership of this directory be tomcat_admin:tomcat. It is
also recommended that the permissions on this directory prevent read, write,
and execute for the world (o-rwx). Restricting access to these directories will
prevent local users from maliciously or inadvertently altering Tomcat’s logs. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "4.4"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Perform the following to determine if the ownership and
permissions on
$CATALINA_HOME/logs are securely configured. Change to the location of the
$CATALINA_HOME/logs and execute the following:
# cd $CATALINA_HOME
# find logs -follow -maxdepth 0 \\( -perm /o+rwx -o ! -user tomcat_admin -o !
group tomcat \\) -ls
Note: If the ownership and permission are set correctly, no output should be
displayed when executing the above command.
"
  tag "fix": "Perform the following to restrict access to Tomcat log files: Set
the ownership of the $CATALINA_HOME/logs to tomcat_admin:tomcat. Remove read,
write, and execute permissions for the world
# chown tomcat_admin:tomcat $CATALINA_HOME/logs
# chmod o-rwx $CATALINA_HOME/logs
"
  tag "Default Value": "The default permissions of the top-level directories is
770.\n\n"

  describe directory("#{TOMCAT_HOME}/logs") do
    its('owner') { should eq "#{TOMCAT_OWNER}" }
    its('group') { should eq "#{TOMCAT_GROUP}" }
    its('mode') { should cmp '0770' }
  end
end
