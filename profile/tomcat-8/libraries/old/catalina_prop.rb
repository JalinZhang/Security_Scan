# encoding: utf-8

# require 'resources/postgres'
require 'inspec/utils/file_reader'

module Inspec::Resources
  class TomcatPropFile < Inspec.resource(1)
    name 'tomcat_properties_file'
    supports platform: 'unix'
    desc 'Use the `tomcat_properties_file` InSpec audit resource to query the
          properties data defined in the catalaina.properties file.'
    example "
      describe postgres_hba_conf.where { type == 'local' } do
        its('auth_method') { should eq ['peer'] }
      end
    "

    include FileReader

    attr_reader :conf_file, :params, :read_content

    # @todo add checks to ensure that we have data in our file
    def initialize(catalina_conf = nil)
      @conf_file = catalina_conf || File.expand_path('catalina.properties', "/usr/share/tomcat/conf")
      @content = ''
      @params = {}
      read_content
    end

    def to_s
      "Tomcat Properties File #{@conf_file}"
    end

    private

    def read_content(config_file = @conf_file)
      props = read_file_content(config_file).gsub(/\\\r?\n/, '')
      cfg = SimpleConfig.new(props)
      @params = cfg.params
    end
  end
end
