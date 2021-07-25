
require 'inspec/utils/file_reader'
require 'inspec/utils/simpleconfig'

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

  attr_reader :conf_file, :params

  # @todo add checks to ensure that we have data in our file
  def initialize(properties_file = nil)
    @conf_file = properties_file
    return skip_resource 'You must provide a path to the Tomcat Properites file' if @conf_file.nil?
    return skip_resource "Can't find file #{@conf_file}" unless @conf_file.file?
    @content = ''
    @params = {}
    read_content
  end

  def to_s
    "Tomcat Properties File #{@conf_file}"
  end

  def read_content(config_file = @conf_file)
    file = inspec.file(config_file)
    return skip_resource "Can't find file \"#{@conf_file}\"" unless file.file?

    raw_conf = file.content

    if raw_conf.empty? && !file.empty?
      return skip_resource("Can't read the contents of \"#{@conf_file}\"")
    end

    props = read_file_content(config_file).gsub(/\\\r?\n/, '')
    cfg = SimpleConfig.new(props)
    @params = cfg.params
  end
end
