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

TOMCAT_EXTRANEOUS_RESOURCE_LIST= attribute(
  'tomcat_extraneous_resource_list',
  description: 'List of extraneous resources that should not exist',
  default: ["webapps/docs",
            "webapps/examples",
            "webapps/host-manager",
            "webapps/manager"]
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-1.1" do
  title "1.1 Remove extraneous files and directories (Scored)"
  desc  "The installation may provide example applications, documentation, and
other directories which may not serve a production use. Removing sample
resources is a defense in depth measure that reduces potential exposures
introduced by these resources. "
  impact 0.5
  tag "severity": "medium"
  tag "cis_id": "1.1"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Perform the following to determine the existence of
extraneous resources:
List all files extraneous files. The following should yield no output:
$ ls -l $CATALINA_HOME/webapps/docs \\
$CATALINA_HOME/webapps/examples
"
  tag "fix": "Perform the following to remove extraneous resources:
The following should yield no output:
$ rm -rf $CATALINA_HOME/webapps/docs \\
$CATALINA_HOME/webapps/examples
If the Manager application is not utilized, also remove the following
resources:
$ rm –rf $CATALINA_HOME/webapps/host-manager \\
$CATALINA_HOME/webapps/manager \\
$CATALINA_HOME/conf/Catalina/localhost/manager.xml

"
  tag "Default Value": "\"docs\", \"examples\", \"manager\" and
\"host-manager\" are default web applications shipped\nwith Tomcat."

  TOMCAT_EXTRANEOUS_RESOURCE_LIST.each do |app|
    describe command("ls -l #{TOMCAT_HOME}/#{app}") do
      its('stdout.strip') { should eq '' }
    end
  end
end
