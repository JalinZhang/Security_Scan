control 'M-3.3' do
  title '3.3 Ensure that the docker.socket file ownership is set to root:root(Scored)'
  desc  "Verify that the docker.socket file ownership and group ownership is
  correctly set to root. The docker.socket file contains sensitive parameters that may alter the
  behavior of the Docker remote API. Hence, it should be owned and group-owned by root to maintain
  the integrity of the file.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '3.3'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.socket Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to verify that the file is owned
  and group-owned by root. For example, stat -c %U:%G
  /usr/lib/systemd/system/docker.socket | grep -v root:root The above command
  should not return anything."
  tag "fix": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.socket Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to set the ownership and group ownership
  for the file to root. For example, chown root:root /usr/lib/systemd/system/docker.socket"
  tag "Default Value": "This file may not be present on the system. In that
  case, this recommendation is not applicable. By default, if the file is
  present, the ownership and group-ownership for this file is correctly set to root."
  ref 'daemonsocket-option', url: 'https://docs.docker.com/engine/reference/commandline/dockerd/#daemonsocket-option'
  ref 'docker.socket', url: 'https://github.com/docker/dockerce/blob/master/components/packaging/deb/systemd/docker.socket'

  docker_socket_file = command('systemctl show -p FragmentPath docker.socket').stdout.strip

  equal_sign = docker_socket_file.index('=')

  docker_socket_file = docker_socket_file[equal_sign+1..-1]

  if file(docker_socket_file.to_s).exist?

    describe file('docker_socket_file') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

  else
    impact 0.0
    describe 'The docker socket file does not exist, therefore this control is N/A' do
      skip 'The docker socket file does not exist, therefore this control is N/A'
    end
  end
end

