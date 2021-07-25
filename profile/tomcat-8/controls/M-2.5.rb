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

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-2.5" do
  title "2.5 Disable client facing Stack Traces (Scored)"
  desc  "When a runtime error occurs during request processing, Apache Tomcat
will display debugging information to the requestor. It is recommended that
such debug information be withheld from the requestor. Debugging information,
such as that found in call stacks, often contains sensitive information that
may useful to an attacker. By preventing Tomcat from providing this
information, the risk of leaking sensitive information to a potential attacker
is reduced. "
  impact 0.5
  tag "ref": "1.
https://tomcat.apache.org/tomcat-8.0doc/api/org/apache/tomcat/util/descriptor/web/ErrorPage.html"
  tag "severity": "medium"
  tag "cis_id": "2.5"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Perform the following to determine if Tomcat is configured
to prevent sending debug
information to the requestor Ensure an <error-page> element is defined in$
CATALINA_HOME/conf/web.xml. Ensure the <error-page> element has an
<exception-type> child element with a
value of java.lang.Throwable. Ensure the <error-page> element has a <location>
child element.
Note: Perform the above for each application hosted within Tomcat. Per
application
instances of web.xml can be found at
$CATALINA_HOME/webapps/<APP_NAME>/WEBINF/web.xml
"
  tag "fix": "Perform the following to prevent Tomcat from providing debug
information to the
requestor during runtime errors: Create a web page that contains the logic or
message you wish to invoke when
encountering a runtime error. For example purposes, assume this page is located
at
/error.jsp. Add a child element, <error-page>, to the <web-app>element, in the

$CATALINA_HOME/conf/web.xml file. Add a child element, <exception-type>, to the
<error-page> element. Set the value of
the <exception-type> element to java.lang.Throwable.
 Add a child element, <location>, to the <error-page> element. Set the value of
the
<location> element to the location of page created in #1.
The resulting entry will look as follows:
<error-page>
<exception-type>java.lang.Throwable</exception-type>
<location>/error.jsp</location>
</error-page>
"
  tag "Default Value": "Tomcat’s default configuration does not include an
<error-page> element in\n$CATALINA_HOME/conf/web.xml. Therefore, Tomcat will
provide debug information to\nthe requestor by default.\n"

  # Query the main web.xml
  web_conf = xml("#{TOMCAT_HOME}/conf/web.xml")
  errorIter = 1
  if web_conf['web-app/error-page'].is_a?(Array)
    numConnectors = web_conf['web-app/error-page'].count
    until errorIter > numConnectors  do
       describe web_conf["web-app/error-page[#{errorIter}]"] do
         it { should_not eq [] }
       end
       describe web_conf["web-app/error-page[#{errorIter}]/exception-type"] do
         it { should cmp "java.lang.Throwable"}
       end
       describe web_conf["web-app/error-page[#{errorIter}]/location"] do
         it { should_not eq [] }
       end
       errorIter +=1
     end
    if !web_conf['web-app/error-page'].any?
     describe web_conf["web-app/error-page"] do
       it { should_not eq [] }
     end
   end
  end

  # Query the web.xml for each webapp
  command("find #{TOMCAT_HOME}/webapps/ ! -path #{TOMCAT_HOME}/webapps/ -type d -maxdepth 1").stdout.split.each do |webappname|
    webapp_conf = xml("#{webappname}/WEB-INF/web.xml")
    webAppIter = 1
    if webapp_conf['web-app/error-page'].is_a?(Array)
      numConnectors = webapp_conf['web-app/error-page'].count
      until webAppIter > numConnectors  do
         describe webapp_conf["web-app/error-page[#{webAppIter}]"] do
           it { should_not eq [] }
         end
         describe webapp_conf["web-app/error-page[#{webAppIter}]/exception-type"] do
           it { should cmp "java.lang.Throwable"}
         end
         describe webapp_conf["web-app/error-page[#{webAppIter}]/location"] do
           it { should_not eq [] }
         end
         webAppIter +=1
       end
      if !webapp_conf['web-app/error-page'].any?
       describe webapp_conf["web-app/error-page"] do
         it { should_not eq [] }
       end
     end
    end
  end
end
