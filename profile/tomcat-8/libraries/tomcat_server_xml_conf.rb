require 'happymapper'
require 'inspec/utils/file_reader'

class Listener
  include HappyMapper
  tag 'Listener'

  attribute :classname, String, tag: 'className'
end

class Resource
  include HappyMapper
  tag 'Resource'

  attribute :name, String, tag: 'name'
  attribute :auth, String, tag: 'auth'
  attribute :type, String, tag: 'type'
  attribute :desc, String, tag: 'description'
  attribute :factory, String, tag: 'factory'
  attribute :path, String, tag: 'pathname'
end

class GlobalNamingResources
  include HappyMapper
  tag 'GlobalNamingResource'

  has_many :resources, Resource, tag: 'resource'
end

class Connector
  include HappyMapper
  tag 'Connector'

  attribute :port, String, tag: 'port'
  attribute :protocol, String, tag: 'protocol'
  attribute :timeout, String, tag: 'connectionTimeout'
  attribute :redirectport, String, tag: 'redirectPort'
  attribute :sslprotocol, String, tag: 'sslProtocol'
  attribute :scheme, String, tag: 'scheme'
  attribute :sslenable, String, tag: 'SSLEnabled'
  attribute :clientauth, String, tag: 'clientAuth'
  attribute :secure, String, tag: 'secure'
end


class Service
  include HappyMapper
  tag 'Service'

  attribute :name, String, tag: 'name'
  has_many :connectors, Connector, tag: 'Connector'
end


# class Engine
#
# class Realm
# end

class Server
  include HappyMapper
  tag 'Server'

  attribute :port, String, tag: 'port'
  attribute :shutdown, String, tag: 'shutdown'
  has_many :listeners, Listener, tag: 'Listener'
  has_one :globalnameres, GlobalNamingResources, tag: 'GlobalNamingResource'
  has_one :service, Service, tag: 'Service'
end

class TomcatServerXml < Inspec.resource(1)
  name 'tomcat_server_xml'
  include HappyMapper
  include FileReader

  attr_reader :params

  def initialize(path = nil)
    @conf_path = path || '/usr/share/tomcat/conf/server.xml'
    @content = read_file_content(@conf_path)
    @params = []
    parse_conf
  end

  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:ports,                field: :port)
        .add(:protocols,            field: :protocol)
        .add(:sslenables,           field: :sslenable)
        .add(:schemes,              field: :scheme)
        .add(:sslprotocols,         field: :sslprotocol)
        .add(:secures,              field: :secure)
        .add(:clientauths,          field: :clientauth)
        .add(:exists?) { |x| x.entries.any? }
  filter.connect(self, :params)

  def parse_conf
    @tomcat_server = Server.parse(@content)
    fetch_connectors
  end

  def fetch_connectors
    @tomcat_server.service.connectors.each { |connector| @params <<
      {
        port: connector.port,
        protocol: connector.protocol,
        timeout: connector.timeout,
        redirect: connector.redirectport,
        sslprotocol: connector.sslprotocol,
        scheme: connector.scheme,
        sslenable: connector.sslenable,
        clientauth: connector.clientauth,
        secure: connector.secure
      }}
  end
end
