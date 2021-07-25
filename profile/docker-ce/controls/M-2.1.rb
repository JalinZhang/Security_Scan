control 'M-2.1' do
  title "2.1 Ensure network traffic is restricted between containers on
  the default bridge (Scored)"
  desc "
  By default, all network traffic is allowed between containers on the same
  host on the default network bridge. If not desired, restrict all the inter-container
  communication. Link specific containers together that require communication. Alternatively, you
  can a create custom network and only join containers that need to communicate to that
  custom network. By default, unrestricted network traffic is enabled between all containers
  on the same host on the default network bridge. Thus, each container has the potential of
  reading all packets across the container network on the same host. This might lead to an
  unintended and unwanted disclosure of information to other containers. Hence, restrict the
  inter-container communication on the default network bridge.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.1'
  tag "cis_control": ['6.2', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AU-3', '4']
  tag "check_text": "Run the below command and verify that the default network
  bridge has been configured to restrict inter-container communication. docker
  network ls --quiet | xargs docker network inspect --format '{{ .Name\n}}: {{
  .Options }}' It should return com.docker.network.bridge.enable_icc:false for
  the default network bridge."
  tag "fix": "Run the docker in daemon mode and pass --icc=false as an
  argument. For Example, dockerd --icc=false Alternatively, you can follow the
  Docker documentation and create a custom network and only join containers that
  need to communicate to that custom network. The --icc parameter only applies
  to the default docker bridge, if custom networks are used then the approach of
  segmenting networks should be adopted instead."
  tag "Default Value": "By default, all inter-container communication is
  allowed on the default network bridge.\n"
  ref 'Docker container networking', url: 'https://docs.docker.com/engine/userguide/networking/'
  ref 'communication-between-containers', url: 'https://docs.docker.com/engine/userguide/networking/default_network/containe
  r-communication/#communication-between-containers'

  describe json('/etc/docker/daemon.json') do
    its(['icc']) { should eq(false) }
  end
end

