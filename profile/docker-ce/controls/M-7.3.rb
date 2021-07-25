control 'M-7.3' do
  title '7.3 Ensure swarm services are binded to a specific host interface(Scored)'
  desc  "By default, the docker swarm services will listen on all interfaces on the
  host, which may not be necessary for the operation of the swarm where the host has multiple
  network interfaces. When a swarm is initialized the default value for the --listen-addr flag is
  0.0.0.0:2377 which means that the swarm services will listen on all interfaces on the
  host. If a host has multiple network interfaces this may be undesirable as it may expose the
  docker swarm services to networks which are not involved in the operation of the swarm.
  By passing a specific IP address to the --listen-addr, a specific network
  interface can be specified limiting this exposure.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '7.3'
  tag "cis_control": ['9', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['SC-7', '4']
  tag "check_text": "List the network listener on port 2377/TCP (the default for
  docker swarm) and confirm that it is only listening on specific interfaces.
  For example, using ubuntu this could be done with the following
  command: netstat -lt | grep -i 2377"
  tag "fix": "Remediation of this requires re-initialization of the swarm
  specifying a specific interface for the --listen-addr parameter."
  tag "Default Value": "By default, docker swarm services listen on all
  available host interfaces."
  ref '#--listen- addr', url: 'https://docs.docker.com/engine/reference/commandline/swarm_init/#--listen- addr'
  ref 'recover-from-disaster', url: 'https://docs.docker.com/engine/swarm/admin_guide/#recover-from-disaster'
  if attribute('swarm_mode') == 'active'
    describe port(attribute('swarm_port')) do
      its('addresses') { should_not include '0.0.0.0' }
      its('addresses') { should_not include '::' }
    end
  else
    impact 0.0
    describe 'The docker swarm mode is not being used, therefore this control is N/A' do
      skip 'The docker swarm mode is not being used, therefore this control is N/A'
    end
  end
end

