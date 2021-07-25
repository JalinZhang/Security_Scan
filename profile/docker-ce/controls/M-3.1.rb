control 'M-3.1' do
  title '3.1 Ensure that docker.service file ownership is set to root:root (Scored)'
  desc  "Verify that the docker.service file ownership and group-ownership are
  correctly set to root. The docker.service file contains sensitive parameters that may alter the
  behavior of the Docker daemon. Hence, it should be owned and group-owned by root to maintain the
  integrity of the file.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '3.1'
  tag "cis_control": ['5.1', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-6(9)', '4']
  tag "check_text": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.service Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to verify that the file is owned
  and group-owned by root. For example, stat -c %U:%G
  /usr/lib/systemd/system/docker.service | grep -v root:root The above command
  should not return anything."
  tag "fix": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.service Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to set the ownership and group ownership
  for the file to root. For example, chown root:root
  /usr/lib/systemd/system/docker.service"
  tag "Default Value": "This file may not be present on the system. In that
  case, this recommendation is not applicable. By default, if the file is
  present, the ownership and group-ownership for this file is correctly set to
  root."
  ref 'systemd', url: 'https://docs.docker.com/engine/admin/systemd/'

  docker_service_file = command('systemctl show -p FragmentPath docker.service').stdout.strip

  equal_sign = docker_service_file.index('=')

  docker_service_file = docker_service_file[equal_sign+1..-1]

  if file(docker_service_file.to_s).exist?

    describe file('docker_service_file') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

  else
    impact 0.0
    describe 'The docker service file does not exist, therefore this control is N/A' do
      skip 'The docker service file does not exist, therefore this control is N/A'
    end
  end
end

