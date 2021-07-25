control 'M-3.4' do
  title '3.4 Ensure that docker.socket file permissions are set to 644 or more restrictive (Scored)'
  desc  "Verify that the docker.socket file permissions are correctly set to 644 or more restrictive.
  The docker.socket file contains sensitive parameters that may alter the behavior of the Docker remote API.
  Hence, it should be writable only by root to maintain the integrity of the file.
  "
  impact 0.5
  tag "severity": 'medium'
  tag "cis_id": '3.4'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.socket Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to verify that the file permissions are set
  to 644 or more restrictive. For example, stat -c %a
  /usr/lib/systemd/system/docker.socket"
  tag "fix": "Step 1: Find out the file location: systemctl show -p
  FragmentPath docker.socket Step 2: If the file does not exist, this
  recommendation is not applicable. If the file exists, execute the below
  command with the correct file path to set the file permissions to 644. For
  example, chmod 644 /usr/lib/systemd/system/docker.socket"
  tag "Default Value": "This file may not be present on the system. In that
  case, this recommendation is not applicable. By default, if the file is
  present, the file permissions for this file are correctly set to 644."
  ref 'quickstart', url: 'https://docs.docker.com/engine/quickstart/'
  ref 'bind-dockerto-another-hostport-or-a-unix-socket', url: 'https://docs.docker.com/engine/reference/commandline/dockerd/#bind-dockerto-another-hostport-or-a-unix-socket'
  ref 'docker.socker', url: 'https://github.com/YungSang/fedora-atomic-packer/blob/master/oem/docker.socket'
  ref 'centos-7rhel-7-and-docker-containers-on-boot', url: 'https://daviddaeschler.com/2014/12/14/centos-7rhel-7-and-docker-containers-on-boot/'

  docker_socket_file = command('systemctl show -p FragmentPath docker.socket').stdout.strip

  equal_sign = docker_socket_file.index('=')

  docker_socket_file = docker_socket_file[equal_sign+1..-1]

  if file(docker_socket_file.to_s).exist?

    describe file('docker_socket_file') do
      it { should exist }
      it { should be_file }
      its('mode') { should cmp <= 0644 }
    end

  else
    impact 0.0
    describe 'The docker socket file does not exist, therefore this control is N/A' do
      skip 'The docker socket file does not exist, therefore this control is N/A'
    end
  end
end

