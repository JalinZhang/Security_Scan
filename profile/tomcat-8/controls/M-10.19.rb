TOMCAT_APP_DIR= attribute(
  'tomcat_app_dir',
  description: 'location of tomcat app directory',
  default: '/var/lib/tomcat'
)

TOMCAT_SERVICE_NAME= attribute(
  'tomcat_service_name',
  description: 'Name of Tomcat service',
  default: 'tomcat'
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-10.19" do
  title "10.19 use the logEffectiveWebXml and metadata-complete settings for
deploying applications in production (Scored)"
  desc  "Both Fragments and annotations give rise to security concerns. web.xml
contains a metadata-complete attribute in the web-app element whose binary
value defines whether other sources of metadata should be considered when
deploying this web application, this includes annotations on class files
(@WebServlet, but also @WebListener, @WebFilter, …), web-fragment.xml as well
as classes located in WEB-INF/classes. In addition, Tomcat 7 could allow you to
log the effective web.xml, when an application starts, and the effective
web.xml is the result of taking the main web.xml for your application merging
in all the fragments applying all the annotations. By logging that you are able
to review it, and see if that is in fact what you actually want. Enable
'logEffectiveWebXml' will allow you to log the effective web.xml and you are
able to see if that is in fact what you actually want. Enable
'metadata-complete' so that the web.xml is the only metadata considered. "
  impact 0.5
  tag "ref": "1. https://tomcat.apache.org/tomcat-8.0-doc/config/context.html
2.
https://alexismp.wordpress.com/2010/07/28/servlet-3-0-fragments-and-webxml-to-rule-them-all/
 Appendix: Summary Table "
  tag "severity": "medium"
  tag "cis_id": "10.19"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 1
  tag "audit text": "1. Review each application’s web.xml file located in the
applications
$CATALINA_BASE\\<app name>\\WEB-INF\\web.xml and determine if the
metadatacomplete property is set.
<web-app
...
metadata-complete='true'
...
> Review each application’s context.xml file located in the applications
$CATALINA_BASE\\<app name>\\META-INF\\context.xml and determine if the
metadata-complete property is set.
<Context
...
logEffectiveWebXml='true'
...
>

"
  tag "fix": "Set the metadata-complete value in the web.xml in each of
applications to true,
the web.xml contains a metadata-complete attribute in the web-app element whose

binary value defines whether other sources of metadata should be considered
when
deploying this web application, this includes annotations on class files
(@WebServlet, but also @WebListener, @WebFilter, ...), web-fragment.xml as well

as classes located in WEB-INF/classes. If set to true, all of these will be
ignored
and web.xml is the only metadata considered.
NOTE: 'The metadata-complete option is not enough to disable all of annotation

scanning. If there is a ServletContainerInitializer with a @HandlesTypes
annotation,
Tomcat has to scan your application for classes that use annotations or
interfaces
specified in that annotation.
Set the logEffectiveWebXml value in the context.xml in each of applications to
true
"
  tag "Default Value": "If logEffectiveWebXml not specified, the default value
of false is used; If metadatacomplete not specified, the default value of false
is used\n"

  begin

  web_xml = command("ls #{TOMCAT_APP_DIR}/webapps/*/WEB-INF/web.xml").stdout.split.each do |web_file|
    describe xml(web_file) do
      its('web-app/attribute::metadata-complete') { should eq ['true'] }
    end
  context_xml = command("ls #{TOMCAT_APP_DIR}/webapps/*/META-INF/context.xml").stdout.split.each do |web_file|
    describe xml(web_file) do
      its('web-app/attribute::logEffectiveWebXml') { should eq ['true'] }
    end
  end
  end
end
end
