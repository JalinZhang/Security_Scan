require 'happymapper'

class Role
  include HappyMapper
  tag 'role'

  attribute :name, String, tag: 'rolename'
end

class User
  include HappyMapper
  tag 'user'

  attribute :username, String, tag: 'username'
  attribute :password, String, tag: 'password'
  attribute :raw_roles, String, tag: 'roles'
  # attribute :roles, Array, tag: 'roles', on_load: lambda {|text| text.split(',')}, on_save: lambda {|array| array.join(',')}
  # attribute :roles, Array, tag: 'roles', deliminter: ','

  def roles
    raw_roles.split(',')
  end
end

class TomcatUsers
  include HappyMapper
  tag 'tomcat-users'

  has_many :roles, Role, tag: 'role'
  has_many :users, User, tag: 'user'
end

# class TomcatUsersConf < Inspec.resource(1)
#   name 'tomcat_users_conf'
#   include HappyMapper
#
#   attr_reader :params, :test, :happymapped_users
#
#   def initialize(path = nil)
#     @conf_path = path || '/usr/share/tomcat/conf/tomcat-users.xml'
#     # @content = File.read(@conf_path)
#     @params = {}
#     parse_conf
#     # include HappyMapperusers.roles.first.rolename
#   end
#
#   filter = FilterTable.create
#   filter.add_accessor(:where)
#         .add_accessor(:entries)
#         .add(:users,           field: 'username')
#         .add(:passwords,       field: 'password')
#         .add(:roles,           field: 'roles')
#   filter.connect(self, :fetch_users)
#
#   def parse_conf
#     @params = TomcatUsers.parse(@conf_path)
#   end
#
#   def fetch_users
#     @params.users.map { |x| { username: x.username, password: x.password, roles: x.roles } }
#   end
#
#   def get_roles
#     @params.roles.map { |user| user.join(',') }
#   end
# end
