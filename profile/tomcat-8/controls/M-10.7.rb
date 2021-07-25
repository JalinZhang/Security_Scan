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

control "M-10.7" do
  title "10.7 Turn off session façade recycling (Scored)"
  desc  "The RECYCLE_FACADES can specify if a new façade will be created for
each request. If a new façade is not created there is a potential for
information leakage from other sessions. When RECYCLE_FACADES is set to false,
Tomcat will recycle the session façade between requests. This will allow for
information leakage between requests. "
  impact 0.5
  tag "ref": "1.
http://tomcat.apache.org/tomcat-8.0-doc/config/systemprops.html 2.
https://tomcat.apache.org/tomcat-8.0-doc/security-howto.html"
  tag "severity": "medium"
  tag "cis_id": "10.7"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Ensure the above parameter is added to the startup script
which by default is located at
$CATALINA_HOME/bin/catalina.sh.
"
  tag "fix": "Start Tomcat with RECYCLE_FACADES set to true. Add the following
to your startup script.
-Dorg.apache.catalina.connector.RECYCLE_FACADES=true
"
  tag "Default Value": "If not specified, the default value of false will be
used.\n"

  begin
    cat_prop = tomcat_properties_file.read_content("#{TOMCAT_HOME}/conf/catalina.properties")

    describe cat_prop['org.apache.catalina.connector.RECYCLE_FACADES'] do
      it { should cmp 'true' }
    end
  end
end
