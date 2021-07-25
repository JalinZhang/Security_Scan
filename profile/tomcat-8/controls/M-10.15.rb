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
  title "10.15 Do not allow cross context requests (Scored)"
  desc  "Setting crossContext to true allows for an application to call
ServletConext.getContext to return a dispatcher for another application.
Allowing crossContext creates the possibility for a malicious application to
make requests to a restricted application. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-8.0-doc/config/context.html"
  tag "severity": "medium"
  tag "cis_id": "10.15"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Ensure all context.xml have the crossContext attribute set
to false or crossContext does not
exist.
# find . -name context.xml | xargs grep 'crossContext'
"
  tag "fix": "In all context.xml, set the crossContext attribute to false:
<Context ... crossContext=”false” />
"
  tag "Default Value": "By default, crossContext has a value of false.\n"

  begin
    describe.one do
      describe command("find #{TOMCAT_APP_DIR} -name context.xml | xargs grep 'crossContext'") do
        its('stdout') { should eq ''}
      end
      describe command ("find #{TOMCAT_APP_DIR} -name context.xml | xargs grep 'crossContext'") do
        its('stdout') { should_not include 'crossContext="true"' }
      end
    end
  end
end
