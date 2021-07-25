control 'M-2.2' do
  title "2.2 Ensure the logging level is set to 'info' (Scored)"
  desc  "Set Docker daemon log level to info.
  Setting up an appropriate log level, configures the Docker daemon to log events that you would want to review later.
  A base log level of info and above would capture all logs except debug logs.
  Until and unless required, you should not run Docker daemon at debug log level.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.1'
  tag "cis_control": ['6.2', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AU-3', '4']
  tag "check_text": "ps -ef | grep docker
  Ensure that either the --log-level parameter is not present or if present, then it is set to info."
  tag "fix": 'Run the Docker daemon as below: dockerd --log-level="info"'
  tag "Default Value": 'By default, Docker daemon is set to log level of info.'
  ref 'dockerd', url: 'https://docs.docker.com/edge/engine/reference/commandline/dockerd/'
  ref 'Docker daemon', url: 'https://docs.docker.com/engine/reference/commandline/daemon/'

  describe json('/etc/docker/daemon.json') do
    its(['log-level']) { should eq('info') }
  end
end

