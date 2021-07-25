class Tomcat < Inspec.resource(1)
  name 'tomcat'

  attr_reader :service, :user, :conf_dir, :tomcat_context_conf
  attr_reader :tomcat_web_conf, :tomcat_main_conf, :tomcat_users_conf
  attr_reader :tomcat_server_conf

  def initialize
    @service = 'tomcat'
    @user = 'tomcat'
    @conf_dir = '/usr/share/tomcat/conf'
    # @tomcat_server_conf = File.join @conf_dir, 'server.xml'
    # @tomcat_main_conf = File.join @conf_dir, 'tomcat.conf'
    # @tomcat_web_conf = File.join @conf_dir, 'web.xml'
    # @tomcat_users_conf = File.join @conf_dir, 'tomcat-users.xml'
    # @tomcat_context_conf = File.join @conf_dir, 'context.xml'
  end

  def to_s
    'Tomcat Environment'
  end
  end
