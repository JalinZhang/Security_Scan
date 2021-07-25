TOMCAT_SERVICE_NAME= attribute(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  default: 'tomcat'
)

TOMCAT_CONF_SERVER= attribute(
  'tomcat_conf_server',
  description: 'Path to tomcat server.xml',
  default: '/usr/share/tomcat/conf/server.xml'
)

TOMCAT_APP_DIR= attribute(
  'tomcat_app_dir',
  description: 'location of tomcat app directory',
  default: '/var/lib/tomcat'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-10.15" do
  title "10.15 Do not run applications as privileged (Scored)"
  desc  "Setting the privileged attribute for an application changes the class
loader to the Server class loader instead of the Shared class loader. Running
an application in privileged mode allows an application to load the manager
libraries. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-7.0-doc/config/context.html "
  tag "severity": "medium"
  tag "cis_id": "10.15"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Ensure all context.xml have the privileged attribute set
to false or privileged does not exist.
# find . -name context.xml | xargs grep 'privileged'
"
  tag "fix": "In all context.xml, set the privileged attribute to false unless
it is required like the manager
application:
<Context ... privileged=”false” />
"
  tag "Default Value": "By default, privileged has a value of false.\n"

  begin
    describe.one do
      describe command("find #{TOMCAT_APP_DIR} -name context.xml | xargs grep 'privileged'") do
        its('stdout') { should eq ''}
      end
      describe command ("find #{TOMCAT_APP_DIR} -name context.xml | xargs grep 'privileged'") do
        its('stdout') { should_not include 'privileged="true"' }
      end
    end
  end
end
