control 'M-3.2' do
  title '3.2 Ensure that the docker.service file permissions are set to 644 or more restrictive (Scored)'
  desc  "Verify that the docker.service file permissions are correctly set to 644 or
  more restrictive. The docker.service file contains sensitive parameters that may alter the
  behavior of the Docker daemon. Hence, it should not be writable by any other user other than root
  to maintain the integrity of the file.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '3.2'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.service Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to verify that the file permissions are set
  to 644 or more restrictive. For example, stat -c %a
  /usr/lib/systemd/system/docker.service"
  tag "fix": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.service Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to set the file permissions to 644. For
  example, chmod 644 /usr/lib/systemd/system/docker.service"
  tag "Default Value": "This file may not be present on the system. In that
  case, this recommendation is not applicable. By default, if the file is
  present, the file permissions are correctly set to 644."
  ref 'systemd', url: 'https://docs.docker.com/articles/systemd/'
  docker_service_file = command('systemctl show -p FragmentPath docker.service').stdout.strip

  equal_sign = docker_service_file.index('=')

  docker_service_file = docker_service_file[equal_sign+1..-1]

  if file(docker_service_file.to_s).exist?

    describe file(docker_service_file.to_s) do
      it { should exist }
      it { should be_file }
      its('mode') { should cmp <= '0644' }
    end

  else
    impact 0.0
    describe 'The docker service file does not exist, therefore this control is N/A' do
      skip 'The docker service file does not exist, therefore this control is N/A'
    end
  end
end

