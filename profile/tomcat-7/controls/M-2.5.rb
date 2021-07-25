control "M-2.5" do
  title "2.5 Disable client facing Stack Traces (Scored)"
  desc  "When a runtime error occurs during request processing, Apache Tomcat
will display debugging information to the requester. It is recommended that
such debug information be withheld from the requester. Debugging information,
such as that found in call stacks, often contains sensitive information that
may useful to an attacker. By preventing Tomcat from providing this
information, the risk of leaking sensitive information to a potential attacker
is reduced. "
  impact 0.5
  tag "ref": "1.
https://tomcat.apache.org/tomcat-7.0doc/api/org/apache/catalina/deploy/ErrorPage.html
 "
  tag "severity": "medium"
  tag "cis_id": "2.5"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "Perform the following to determine if Tomcat is configured
to prevent sending debug
information to the requester Ensure an <error-page> element is defined in$
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
requester during runtime errors: Create a web page that contains the logic or
message you wish to invoke when
encountering a runtime error. For example purposes, assume this page is located
at
/error.jsp. Add a child element, <error-page>, to the <web-app>element, in the

$CATALINA_HOME/conf/web.xml file. Add a child element, <exception-type>, to the
<error-page> element. Set the value of
the <exception-type> element to java.lang.Throwable. Add a child element,
<location>, to the <error-page> element. Set the value of the
<location> element to the location of page created in #1.
The resulting entry will look as follows:
<error-page>
<exception-type>java.lang.Throwable</exception-type>
<location>/error.jsp</location>
</error-page>
"
  tag "Default Value": "Tomcat’s default configuration does not include an
<error-page> element in\n$CATALINA_HOME/conf/web.xml. Therefore, Tomcat will
provide debug information to\nthe requester by default.\n"
end
