TOMCAT_BASE= attribute(
  'tomcat_base',
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

control "M-4.2" do
  title "4.2 Restrict access to $CATALINA_BASE (Scored)"
  desc  "$CATALINA_BASE is the environment variable that specifies the base
directory which most relative paths are resolved. $CATALINA_BASE is usually
used when there is multiple instances of Tomcat running. It is important to
protect access to this in order to protect the Tomcat-related binaries and
libraries from unauthorized modification. It is recommended that the ownership
of $CATALINA_BASE be tomcat_admin:tomcat. It is also recommended that the
permission on $CATALINA_BASE prevent read, write, and execute for the world
(orwx) and prevent write access to the group (g-w). The security of processes
and data that traverse or depend on Tomcat may become compromised if the
$CATALINA_BASE is not secured. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "4.2"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Perform the following to ensure the permission on the
$CATALINA_BASE directory prevent
unauthorized modification.
$ cd $CATALINA_BASE
$ find . -follow -maxdepth 0 \\( -perm /o+rwx,g=w -o ! -user tomcat_admin -o !
-group
tomcat \\) -ls
The above command should not emit any output.
"
  tag "fix": "Perform the following to establish the recommended state: Set the
ownership of the $CATALINA_BASE to tomcat_admin:tomcat. Remove read, write, and
execute permissions for the world Remove write permissions for the group.
# chown tomcat_admin.tomcat $CATALINA_BASE
# chmod g-w,o-rwx $CATALINA_BASE"

  describe directory("#{TOMCAT_BASE}") do
    its('owner') { should eq "#{TOMCAT_OWNER}" }
    its('group') { should eq "#{TOMCAT_GROUP}" }
    its('mode') { should cmp '0750' }
  end
end
