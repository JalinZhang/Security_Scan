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

TOMCAT_CONF_WEB= attribute(
  'tomcat_conf_web',
  description: 'location of tomcat web.xml',
  default: '/usr/share/tomcat/conf/web.xml'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-10.11" do
  title "10.11 Configure maxHttpHeaderSize (Scored)"
  desc  "The maxHttpHeaderSize limits the size of the request and response
headers defined in bytes. If not specified, the default is 8192 bytes. Limiting
the size of the header request can help protect against Denial of Service
requests. "
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-8.0-doc/config/http.html"
  tag "severity": "medium"
  tag "cis_id": "10.11"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Locate each maxHttpHeaderSize setting in
$CATALINA_HOME/conf/server.xml and verify
that they are set to 8192.
# grep maxHttpHeaderSize $CATALINA_HOME/conf/server.xml
"
  tag "fix": "Within $CATALINA_HOME/conf/server.xml ensure each connector is
configured to the
appropriate maxHttpHeaderSize setting.
maxHttpHeaderSize=”8192”
"
  tag "Default Value": "maxHttpHeaderSize is set to 8192\n"

  begin
    tomcat_conf = xml(TOMCAT_CONF_SERVER)

      if tomcat_conf['Server/Service/Connector/attribute::maxHttpHeaderSize'].is_a?(Array)
        tomcat_conf['Server/Service/Connector/attribute::maxHttpHeaderSize'].each do |x|
          describe x do
            it { should eq "8192" }
          end
        end
      else
        describe xml(tomcat_conf['Server/Service/Connector/attribute::maxHttpHeaderSize']) do
          it { should eq "8192" }
        end
      end
  end
end
