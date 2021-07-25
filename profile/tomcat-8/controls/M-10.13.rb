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

control "M-10.13" do
  title "10.13 Do not allow symbolic linking (Scored)"
  desc  "Symbolic links allows one application to include the libraries from
another. This allows for re-use of code but also allows for potential security
issues when applications include libraries from other applications they should
not have access to. Allowing symbolic links opens up Tomcat to directory
traversal vulnerability. Also there is a potential that an application could
link to another application it should not be linking too. On case-insensitive
operating systems there is also the threat of source code disclosure. "
  impact 0.5
  tag "ref": "1. https://tomcat.apache.org/tomcat-8.0-doc/config/resources.html
2. http://tomcat.apache.org/tomcat-8.0-doc/config/context.html"
  tag "severity": "medium"
  tag "cis_id": "10.13"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Ensure all context.xml have the allowLinking attribute set
to false or allowLinking
does not exist.
# find . -name context.xml | xargs grep 'allowLinking'
"
  tag "fix": "In all context.xml, set the allowLinking attribute to false:
<Context
...
<Resources ... allowLinking=”false” />
...
</Context>
"
  tag "Default Value": "By default, allowLinking has a value of false\n"

  begin
    describe.one do
      describe command("find #{TOMCAT_APP_DIR} -name context.xml | xargs grep 'allowLinking'") do
        its('stdout') { should eq ''}
      end
      describe command ("find #{TOMCAT_APP_DIR} -name context.xml | xargs grep 'allowLinking'") do
        its('stdout') { should_not include 'allowLinking="true"' }
      end
    end
  end
end
