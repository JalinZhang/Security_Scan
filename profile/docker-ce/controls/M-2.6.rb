control 'M-2.6' do
  title '2.6 Ensure TLS authentication for Docker daemon is configured (Scored)'
  desc  "It is possible to make the Docker daemon to listen on a specific IP and
  port and any other Unix socket other than default Unix socket. Configure TLS authentication to
  restrict access to Docker daemon via IP and port.
  By default, Docker daemon binds to a non-networked Unix socket and runs
  with root privileges. If you change the default docker daemon binding to a TCP port
  or any other Unix socket, anyone with access to that port or socket can have full access to
  Docker daemon and in turn to the host system. Hence, you should not bind the Docker
  daemon to another IP/port or a Unix socket.
  If you must expose the Docker daemon via a network socket, configure TLS authentication
  for the daemon and Docker Swarm APIs (if using). This would restrict the
  connections to your Docker daemon over the network to a limited number of clients who could
  successfully authenticate over TLS.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.6'
  tag "cis_control": ['9.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['CM-7(1)', '4']
  tag "check_text": "ps -ef | grep dockerd Ensure that the below parameters are
  present: --tlsverify --tlscacert --tlscert --tlskey "
  tag "fix": "Follow the steps mentioned in the Docker documentation or other
  references."
  tag "Default Value": 'By default, TLS authentication is not configured.'
  ref 'Protect Docker deamon socket', url: 'https://docs.docker.com/engine/security/https/'

  describe json('/etc/docker/daemon.json') do
    its(['tls']) { should eq(true) }
    its(['tlsverify']) { should eq(true) }
    its(['tlscacert']) { should eq attribute('daemon_tlscacert') }
    its(['tlscert']) { should eq attribute('daemon_tlscert') }
    its(['tlskey']) { should eq attribute('daemon_tlskey') }
  end
end

