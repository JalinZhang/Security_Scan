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

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-10.17" do
  title "10.17 Enable memory leak listener (Scored)"
  desc  "The JRE Memory Leak Prevention Listener provides a work-around for
known places where the Java Runtime environment uses the context class loader
to load a singleton as this will cause a memory leak if a web application class
loader happens to be the context class loader at the time. The work-around is
to initialize these singletons when this listener starts as Tomcat's common
class loader is the context class loader at that time. It also provides
work-arounds for known issues that can result in locked JAR files. Enable the
JRE Memory Leak Prevention Listener provides a work-around for preventing a
memory leak. "
  impact 0.5
  tag "ref": "1.
https://tomcat.apache.org/tomcat-8.0doc/config/listeners.html#JRE_Memory_Leak_Prevention_Listener__org.apache.catalina.core.JreMemoryLeakPreventionListener"
  tag "severity": "medium"
  tag "cis_id": "10.17"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Review the $CATALINA_HOME/conf/server.xml and see whether
JRE Memory Leak
Prevention Listener is enabled.
"
  tag "fix": "Uncomment the JRE Memory Leak Prevention Listener in
$CATALINA_HOME/conf/server.xml
<Listener className='org.apache.catalina.core.JreMemoryLeakPreventionListener'
/>
"

  begin
    describe xml(TOMCAT_CONF_SERVER) do
      its('Server/Listener/attribute::className') { should include 'org.apache.catalina.core.JreMemoryLeakPreventionListener' }
    end
  end
end
