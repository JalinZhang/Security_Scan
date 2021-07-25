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

TOMCAT_REALMS_LIST= attribute(
  'tomcat_realms_list',
  description: 'A list of Realms that should not be enabled',
  default: ['org.apache.catalina.realm.MemoryRealm',
            'org.apache.catalina.realm.JDBCRealm',
            'org.apache.catalina.realm.UserDatabaseRealm',
            'org.apache.catalina.realm.JAASRealm']
)

only_if do
  service(TOMCAT_SERVICE_NAME).installed?
end

control "M-5.1" do
  title "5.1 Use secure Realms (Scored)"
  desc  "A realm is a database of usernames and passwords used to identify
valid users of web applications. Review the Realms configuration to ensure
Tomcat is not configured to use JDBCRealm, UserDatabaseRealm or JAASRealm.
Specifically, Tomcat should not utilize MemoryRealm. The MemoryRealm is not
intended for production use as any changes to tomcat-users.xml require a
restart of Tomcat to take effect. The JDBCRealm is not recommended for
production use as it is single threaded for all authentication and
authorization options. Use the DataSourceRealm instead. The UserDatabaseRealm
is not intended for large-scale installations. It is intended for small-scale,
relatively static environments. The JAASRealm is not widely used and therefore
the code is not as mature as the other realms. Additional testing is
recommended before using this realm."
  impact 0.5
  tag "ref": "1. http://tomcat.apache.org/tomcat-7.0-doc/realm-howto.html  "
  tag "severity": "medium"
  tag "cis_id": "5.1"
  tag "cis_control": ["No CIS Control", "6.1"]
  tag "cis_level": 2
  tag "audit text": "Perform the following to ensure the MemoryRealm is not in
use:
# grep \"Realm className\" $CATALINA_HOME/conf/server.xml | grep MemoryRealm
# grep \"Realm className\" $CATALINA_HOME/conf/server.xml | grep JDBCRealm
# grep \"Realm className\" $CATALINA_HOME/conf/server.xml | grep UserDatabaseRealm
# grep \"Realm className\" $CATALINA_HOME/conf/server.xml | grep JAASRealm

The above command should not emit any output.
"
  tag "fix": "Set the Realm className setting in $CATALINA_HOME/conf/server.xml
to one of the
appropriate realms.
"

  describe xml("#{TOMCAT_HOME}/conf/server.xml") do
    its('Server/Service/Engine/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }

    its('Server/Service/Engine/Realm/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }

    its('Server/Service/Host/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }

    its('Server/Service/Host/Realm/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }

    its('Server/Service/Context/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }

    its('Server/Service/Context/Realm/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }
  end

  describe xml("#{TOMCAT_HOME}/conf/context.xml") do
    its('Context/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }

    its('Context/Realm/Realm/@className') { should_not be_in TOMCAT_REALMS_LIST }
  end
end
