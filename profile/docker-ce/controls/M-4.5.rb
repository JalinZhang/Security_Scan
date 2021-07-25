control 'M-4.5' do
  title '4.5 Ensure Content trust for Docker is Enabled (Scored)'
  desc  "Content trust is disabled by default. You should enable it.
  Content trust provides the ability to use digital signatures for data sent
  to and received from remote Docker registries. These signatures allow client-side
  verification of the integrity and publisher of specific image tags. This ensures provenance of
  container images.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/security/trust/content_trust/2.
  https://docs.docker.com/engine/reference/commandline/cli/#notary3.
  https://docs.docker.com/engine/reference/commandline/cli/#environmentvariables"
  tag "severity": 'medium'
  tag "cis_id": '4.5'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 2 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": 'echo $DOCKER_CONTENT_TRUST This should return 1.'
  tag "fix": "To enable content trust in a bash shell, enter the following
  command: export DOCKER_CONTENT_TRUST=1 Alternatively, set this environment
  variable in your profile file so that content trust is nenabled on every
  login."
  tag "Default Value": 'By default, content trust is disabled.'
  ref 'https://docs.docker.com/engine/reference/commandline/cli/#notary'
  ref 'https://docs.docker.com/engine/reference/commandline/cli/#environment-variables'
  ref 'https://docs.docker.com/engine/security/trust/content_trust/'

  describe os_env('DOCKER_CONTENT_TRUST') do
    its('content') { should eq '1' }
  end
end

