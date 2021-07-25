require 'happymapper'
require 'inspec/utils/file_reader'

module Inspec::Resources
  class TomcatUsers < Inspec.resource(1)
    name 'tomcat_users'
    supports platform: 'unix'
    supports platform: 'windows'
    desc 'Use the tomcat_users_conf InSpec audit resource to test the contents
          of the configuration file for PostgreSQL, typically located at
          /etc/postgresql/<version>/main/postgresql.conf or
          /var/lib/postgres/data/postgresql.conf, depending on the platform.'
    example "
      describe postgres_conf do
        its('max_connections') { should eq '5' }
      end
    "

    # include FileReader

    def initialize(conf_path = nil)
      @conf_path = conf_path || '/usr/share/tomcat/conf/tomcat-users.xml'
      if @conf_path.nil?
        return skip_resource 'The tomcat conf path is not set'
      end
      @conf_dir = File.expand_path(File.dirname(@conf_path))
      @files_contents = {}
      @content = File.read(conf_path)
      @params = TomcatUsers.parse(content)
      read_content
      content = read_file_content(conf_path)
    end
  end
end
# <tomcat-users>
#     <role rolename="tomcat"/>
#     <role rolename="role1"/>
#     <user username="tomcat" password="tomcat" roles="tomcat"/>
#     <user username="both" password="tomcat" roles="tomcat,role1"/> <<=list??/array
#     <user username="role1" password="tomcat" roles="role1"/>
# </tomcat-users>

class Role
  include HappyMapper
  tag 'role'

  attribute :rolename, String, tag: 'rolename'
end

class User
  include HappyMapper
  tag 'user'

  attribute :username, String, tag: 'username'
  attribute :password, String, tag: 'password'
  attribute :roles, Array, tag: 'roles'
end

class TomcatUsers
  include HappyMapper
  tag 'tomcat-users'

  has_many :roles, Role, tag: 'rolename'
  has_many :users, User, tag: 'user'
end
