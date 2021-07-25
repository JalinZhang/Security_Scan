control 'M-2.13' do
  title '2.13 Ensure operations on legacy registry (v1) are Disabled (Scored)'
  desc  "The latest Docker registry is v2. All operations on the legacy registry
  version (v1) should be restricted.
  Docker registry v2 brings in many performance and security improvements
  over v1. It supports container image provenance and other security features such as
  image signing and verification. Hence, operations on Docker legacy registry should be restricted.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.13'
  tag "cis_control": ['18', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SI-1', '4']
  tag "check_text": "ps -ef | grep dockerd The above command should list
  --disable-legacy-registry as an option passed to the docker daemon."
  tag "fix": "Start the docker daemon as below:\ndockerd
  --disable-legacy-registry"
  tag "Default Value": 'By default, legacy registry operations are allowed.'
  ref 'legacyregistries', url: 'https://docs.docker.com/edge/engine/reference/commandline/dockerd/#legacyregistries'
  ref 'Docker daemon storage driver options', url: 'https://docs.docker.com/engine/reference/commandline/daemon/#storage-driver-options'
  ref 'Proposal: Provenance step 1 - Transform images for validation and verification', url: 'https://github.com/docker/docker/issues/8093'
  ref 'Proposal: JSON Registry API V2.1', url: 'https://github.com/docker/docker/issues/9015'
  ref 'Registry next generation', url: 'https://github.com/docker/docker-registry/issues/612'
  ref 'Docker Registry HTTP API V2', url: 'https://docs.docker.com/registry/spec/api/'
  ref 'Creating Private Docker Registry 2.0 with Token Authentication Service', url: 'https://the.binbashtheory.com/creating-private-docker-registry-2-0-with-token-authentication-service/'
  ref 'New Tool to Migrate From V1 Registry to Docker Trusted Registry or V2 Open Source Registry', url: 'https://blog.docker.com/2015/07/new-tool-v1-registry-docker-trusted-registry-v2-open-source/'
  ref 'Docker Registry V2', url: 'https://www.slideshare.net/Docker/docker-registry-v2'

  describe json('/etc/docker/daemon.json') do
    its(['disable-legacy-registry']) { should eq(true) }
  end
end

