control 'M-2.3' do
  title '2.3 Ensure Docker is allowed to make changes to iptables (Scored)'
  desc  "Iptables are used to set up, maintain, and inspect the tables of IP packet
  filter rules in the Linux kernel. Allow the Docker daemon to make changes to the iptables.
  Docker will never make changes to your system iptables rules if you choose
  to do so. Docker server would automatically make the needed changes to iptables based
  on how you choose your networking options for the containers if it is allowed to do
  so. It is recommended to let Docker server make changes to iptables automatically to
  avoid networking misconfiguration that might hamper the communication between
  containers and to the outside world. Additionally, it would save you hassles of
  updating iptables every time you choose to run the containers or modify networking
  options.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '2.3'
  tag "cis_control": ['5', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6', '4']
  tag "check_text": "ps -ef | grep dockerd Ensure that the --iptables parameter is
  either not present or not set to false."
  tag "fix": "Do not run the Docker daemon with --iptables=false parameter. For
  example, do not start the Docker daemon as below: dockerd --iptables=false"
  tag "Default Value": 'By default, iptables is set to true.'
  ref 'networking', url: 'https://docs.docker.com/v1.8/articles/networking/'
  ref 'container-communication', url: 'https://docs.docker.com/engine/userguide/networking/default_network/container-communication/'
  ref 'docker-and-iptables', url: 'https://fralef.me/docker-and-iptables.html'

  describe json('/etc/docker/daemon.json') do
    its(['iptables']) { should eq(true) }
  end
end

