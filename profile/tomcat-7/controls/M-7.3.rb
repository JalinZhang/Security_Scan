control "M-7.3" do
  title "7.3 Ensure className is set correctly in context.xml (Scored)"
  desc  "Ensure the className attribute is set to AccessLogValve. The className
attribute determines the access log valve to be used for logging. Some log
valves are not suited for production and should be used. Apache recommends
org.apache.catalina.valves.AccessLogValve "
  impact 0.5
  tag "ref": "1. https://tomcat.apache.org/tomcat-7.0-doc/config/valve.html  "
  tag "severity": "medium"
  tag "cis_id": "7.3"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Execute the following to ensure className is set properly:

# grep org.apache.catalina.valves.AccessLogValve $CATALINA_BASE\\webapps\\<app

name>\\META-INF\\context.xml
"
  tag "fix": "Add the following statement into the
$CATALINA_BASE\\webapps\\<app name>\\METAINF\\context.xml file if it does not
already exist.
<Valve
className='org.apache.catalina.valves.AccessLogValve'
directory='$CATALINA_HOME/logs/'
prefix='access_log'
fileDateFormat='yyyy-MM-dd.HH'
suffix='.log'
pattern='%t %H cookie:%{SESSIONID}c request:%{SESSIONID}r %m %U %s %q %r'
/>
"
  tag "Default Value": "Does not exist by default.\n"
end
