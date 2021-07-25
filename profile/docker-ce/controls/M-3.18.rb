control 'M-3.18' do
  title '3.18 Ensure that the daemon.json file permissions are set to 644 or more restrictive (Scored)'
  desc  "Verify that the daemon.json file permissions are correctly set to 644 or more restrictive.
  The daemon.json file contains sensitive parameters that may alter the behavior
  of the docker daemon. Hence, it should be writable only by root to maintain the integrity
  of the file.
  "
  impact 0.5
  tag "ref": "1.
  https://docs.docker.com/engine/reference/commandline/dockerd/#daemonconfiguration-file"
  tag "severity": 'medium'
  tag "cis_id": '3.18'
  tag "cis_control": ['14.4', '6.1']
  tag "cis_level": 'Level 1 - Docker'
  tag "nist": ['AC-3 (3)', '4']
  tag "check_text": "Execute the below command to verify that the file permissions
  are correctly set to 644 or more restrictive: stat -c %a
  /etc/docker/daemon.json"
  tag "fix": "chmod 644 /etc/docker/daemon.json This would set the file
  permissions for this file to 644."
  tag "Default Value": "This file may not be present on the system. In that
  case, this recommendation is not applicable."
  ref url: 'https://docs.docker.com/engine/reference/commandline/cli/#daemon-socket-option'
  ref url: 'https://docs.docker.com/engine/quickstart/'

  describe file('/etc/docker/daemon.json') do
    it { should exist }
    it { should be_file }
    it { should be_readable.by('owner') }
    it { should be_writable.by('owner') }
    it { should_not be_executable.by('owner') }
    it { should be_readable.by('group') }
    it { should_not be_writable.by('group') }
    it { should_not be_executable.by('group') }
    it { should be_readable.by('other') }
    it { should_not be_writable.by('other') }
    it { should_not be_executable.by('other') }
  end
end

