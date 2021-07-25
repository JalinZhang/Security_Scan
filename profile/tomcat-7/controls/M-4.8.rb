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

control "M-4.8" do
  title "4.8 Restrict access to Tomcat catalina.policy (Scored)"
  desc  "The catalina.policy file is used to configure security policies for
Tomcat. It is recommended that access to this file has the proper permissions
to properly protect from unauthorized changes. Restricting access to this file
will prevent local users from maliciously or inadvertently altering Tomcat’s
security policy. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "4.8"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Perform the following to determine if the ownership and
permissions on
$CATALINA_HOME/conf/catalina.policy care securely configured. Change to the
location of the $CATALINA_HOME/ and execute the following:
# cd $CATALINA_HOME/conf/
# find catalina.policy -follow -maxdepth 0 \\( -perm /o+rwx -o ! -user
tomcat_admin -o ! -group tomcat \\) -ls
Note: If the ownership and permission are set correctly, no output should be
displayed when executing the above command.
"
  tag "fix": "Perform the following to restrict access to
$CATALINA_HOME/conf/catalina.policy. Set the owner and group owner of the
contents of $CATALINA_HOME/ to
tomcat_admin and tomcat, respectively.
# chmod 770 $CATALINA_HOME/conf/catalina.policy
# chown tomcat_admin:tomcat $CATALINA_HOME/conf/catalina.policy
"
  tag "Default Value": "The default permissions of catalina.policy is 600.\n\n"

  describe file("#{TOMCAT_HOME}/conf/catalina.policy") do
    its('owner') { should eq "#{TOMCAT_OWNER}" }
    its('group') { should eq "#{TOMCAT_GROUP}" }
    its('mode') { should cmp '0770' }
  end
end
