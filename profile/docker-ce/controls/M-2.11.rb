control 'M-2.11' do
  title '2.11 Ensure that authorization for Docker client commands is enabled(Scored)'
  desc  "Use native Docker authorization plugins or a third party authorization
  mechanism with Docker daemon to manage access to Docker client commands.
  Dockers out-of-the-box authorization model is all or nothing. Any user
  with permission to access the Docker daemon can run any Docker client command. The same is
  true for callers using Dockers remote API to contact the daemon. If you require greater
  access control, you can create authorization plugins and add them to your Docker daemon
  configuration. Using an authorization plugin, a Docker administrator can configure granular
  access policies for managing access to Docker daemon.
  Third party integrations of Docker may implement their own authorization
  models to require authorization with the Docker daemon outside of docker's native
  authorization plugin (i.e. Kubernetes, Cloud Foundry, Openshift).
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.11'
  tag "cis_control": ['16', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['AC-2', '4']
  tag "check_text": "ps -ef | grep dockerd Ensure that the --authorization-plugin
  parameter is set as appropriate if using docker native authorization. docker
  search hello-world Ensure that docker daemon requires authorization to perform the above command."
  tag "fix": "Step 1: Install/Create an authorization plugin. Step 2:
  Configure the authorization policy as desired. Step 3: Start the docker daemon
  as below: dockerd --authorization-plugin=<PLUGIN_ID>"
  tag "Default Value": 'By default, authorization plugins are not set up.'
  ref 'Access authorization', url: 'https://docs.docker.com/engine/reference/commandline/daemon/#access-authorization'
  ref 'access-authorization', url: 'https://docs.docker.com/engine/reference/commandline/dockerd/#access- authorization'
  ref 'Auhtorization plugins', url: 'https://docs.docker.com/engine/extend/plugins_authorization/'
  ref 'Twistlock authorization plugin', url: 'https://github.com/twistlock/authz'

  describe json('/etc/docker/daemon.json') do
    its(['authorization-plugins']) { should_not be_empty }
    its(['authorization-plugins']) { should eq attribute('authorization_plugin') }
  end
end

