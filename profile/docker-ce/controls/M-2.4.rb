control 'M-2.4' do
  title '2.4 Ensure insecure registries are not used (Scored)'
  desc  "Docker considers a private registry either secure or insecure. By default,
  registries are considered secure.
  A secure registry uses TLS. A copy of registry's CA certificate is placed
  on the Docker host at /etc/docker/certs.d/<registry-name>/ directory. An insecure registry is the
  one not having either valid registry certificate or is not using TLS. You should
  not be using any insecure registries in the production environment. Insecure registries can
  be tampered with leading to possible compromise to your production system.
  Additionally, If a registry is marked as insecure then docker pull, docker
  push, and docker search commands will not result in an error message and the user
  might be indefinitely working with insecure registries without ever being notified
  of the potential danger.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.4'
  tag "cis_control": ['14.2', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SC-8', '4']
  tag "check_text": "Run docker info or execute the below command to find out if any
  insecure registries are used: ps -ef | grep dockerd Ensure that the
  --insecure-registry parameter is not present."
  tag "fix": "Do not use any insecure registries. For example, do not start
  the Docker daemon as below: dockerd --insecure-registry 10.1.0.0/16"
  tag "Default Value": 'By default, Docker assumes all, but local, registries are secure.'
  ref 'Insecure registry', url: 'https://docs.docker.com/registry/insecure/'

  describe json('/etc/docker/daemon.json') do
    its(['insecure-registries']) { should be_empty }
  end
end

