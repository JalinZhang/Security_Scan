control 'M-3.16' do
  title '3.16 Ensure that the docker socket file permissions are set to 660 or more restrictive (Scored)'
  desc  "Verify that the Docker socket file has permissions of 660 or more restrictive.
  Only root and members of the docker group should be allowed to read and write
  to the default Docker Unix socket. Hence, the Docker socket file must have permissions of
  660 or more restrictive.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/dockerd/#daemonsocket-option2.
  https://docs.docker.com/engine/reference/commandline/dockerd/#bind-dockerto-another-hostport-or-a-unix-socket"
  tag "severity": 'medium'
  tag "cis_id": '3.16'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "Execute the below command to verify that the Docker socket file
  has permissions of 660 or more restrictive: stat -c %a /var/run/docker.sock"
  tag "fix": "chmod 660 /var/run/docker.sock This would set the file
  permissions of the Docker socket file to 660."
  tag "Default Value": "By default, the permissions for the Docker socket file is
  correctly set to 660."
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/#daemon-socket-option'
  ref url: 'https://docs.docker.com/engine/quickstart/'

  describe file('/var/run/docker.sock') do
    it { should exist }
    it { should be_socket }
    it { should be_readable.by('owner') }
    it { should be_writable.by('owner') }
    it { should_not be_executable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_writable.by('group') }
    it { should_not be_executable.by('group') }
    it { should_not be_readable.by('other') }
    it { should_not be_writable.by('other') }
    it { should_not be_executable.by('other') }
  end
end

